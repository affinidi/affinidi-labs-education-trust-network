import 'dart:convert';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:ssi/ssi.dart';

import 'user_config.dart';

/// Service for loading DID Manager from user configuration
class DidManagerLoader {
  final Logger _logger;

  DidManagerLoader({Logger? logger}) : _logger = logger ?? Logger();

  /// Load DID Manager from user_config.json
  ///
  /// This creates a DidPeerManager with keys imported from the privateKeyJwk
  /// in the user configuration secrets.
  Future<DidManagerLoadResult> loadFromConfig(UserConfig config) async {
    final profile = config.primaryProfile;

    if (profile == null) {
      throw Exception('No DID profile found in user configuration');
    }

    final did = profile.key;
    final profileConfig = profile.value;

    _logger.i('Loading DID Manager for: $did');
    _logger.i('Profile alias: ${profileConfig.alias}');
    _logger.i('Secrets count: ${profileConfig.secrets.length}');

    // Validate did:peer
    if (!did.startsWith('did:peer:')) {
      throw Exception('Only did:peer method is supported. Found: $did');
    }

    // Create wallet and keystore
    final keyStore = InMemoryKeyStore();
    final wallet = PersistentWallet(keyStore);

    // Import each secret into the wallet
    final importedKeyIds = <String>[];

    for (final secret in profileConfig.secrets) {
      _logger.d('Importing secret: ${secret.id}');

      try {
        final keyId = await _importPrivateKeyJwk(
          wallet: wallet,
          keyStore: keyStore,
          secretId: secret.id,
          privateKeyJwk: secret.privateKeyJwk,
        );

        importedKeyIds.add(keyId);
        _logger.i('Successfully imported key: $keyId');
      } catch (e) {
        _logger.e('Failed to import secret ${secret.id}', error: e);
        rethrow;
      }
    }

    // Create DidPeerManager
    final didManager = DidPeerManager(
      store: InMemoryDidStore(),
      wallet: wallet,
    );

    // Add verification methods with proper relationships based on key type
    for (var i = 0; i < profileConfig.secrets.length; i++) {
      final keyId = importedKeyIds[i];
      final secret = profileConfig.secrets[i];
      final keyType = _getKeyTypeFromJwk(secret.privateKeyJwk);

      // Determine relationships based on key type and purpose
      // For did:peer, first key is typically verification (P256), second is encryption (secp256k1)
      final relationships = <VerificationRelationship>{};

      if (keyType == KeyType.secp256k1) {
        // secp256k1 is used for encryption (key agreement)
        relationships.add(VerificationRelationship.keyAgreement);
        _logger.d('Adding key $keyId for keyAgreement (secp256k1)');
      } else if (keyType == KeyType.p256 || keyType == KeyType.ed25519) {
        // P256 and Ed25519 are used for authentication and assertion
        relationships.add(VerificationRelationship.authentication);
        // relationships.add(VerificationRelationship.assertionMethod);
        _logger.d(
            'Adding key $keyId for authentication/assertionMethod ($keyType)');
      } else {
        // Default: add all relationships for other key types
        relationships.add(VerificationRelationship.authentication);
        relationships.add(VerificationRelationship.assertionMethod);
        // relationships.add(VerificationRelationship.keyAgreement);
        _logger.d('Adding key $keyId with all relationships ($keyType)');
      }

      await didManager.addVerificationMethod(keyId,
          relationships: relationships);
      _logger.i('Successfully added verification method for: $keyId');
    }

    // await didManager.addServiceEndpoint(ServiceEndpoint(
    //   type: 'DIDCommMessaging',
    //   serviceEndpoint: const StringEndpoint(
    //       'https://apse1.mediator.affinidi.io/.well-known'),
    //   id: '#service',
    // ));

    final didDoc = await didManager.getDidDocument();
    _logger.i('Loading DID Manager from DidPeer : ${didDoc.id}');

    _logger.i('DID Manager loaded successfully');

    return DidManagerLoadResult(
      didManager: didManager,
      did: did,
      alias: profileConfig.alias,
      keyIds: importedKeyIds,
    );
  }

  /// Import a private key JWK into the wallet/keystore
  Future<String> _importPrivateKeyJwk({
    required PersistentWallet wallet,
    required InMemoryKeyStore keyStore,
    required String secretId,
    required Map<String, dynamic> privateKeyJwk,
  }) async {
    // Determine key type from JWK
    KeyType keyType = _getKeyTypeFromJwk(privateKeyJwk);

    // Extract private key bytes based on key type
    final privateKeyBytes = _extractPrivateKeyBytes(privateKeyJwk, keyType);

    // Generate a stable keyId from the secret ID
    // Remove the DID prefix to get just the fragment (e.g., "key-1")
    final keyId = secretId.contains('#')
        ? secretId.split('#').last
        : 'imported-key-${DateTime.now().millisecondsSinceEpoch}';

    // Store the key in the keystore
    await keyStore.set(
      keyId,
      StoredKey(
        keyType: keyType,
        privateKeyBytes: Uint8List.fromList(privateKeyBytes),
      ),
    );

    // Ensure the wallet can access it
    await wallet.getKeyPair(keyId);

    return keyId;
  }

  /// Determine key type from JWK
  KeyType _getKeyTypeFromJwk(Map<String, dynamic> jwk) {
    final kty = jwk['kty'] as String?;
    final crv = jwk['crv'] as String?;

    if (kty == null) {
      throw Exception('Missing "kty" in JWK');
    }

    if (kty == 'EC') {
      // Elliptic Curve keys
      if (crv == 'secp256k1') {
        return KeyType.secp256k1;
      } else if (crv == 'P-256' || crv == 'prime256v1') {
        return KeyType.p256;
      } else if (crv == 'P-384') {
        return KeyType.p384;
      } else if (crv == 'P-521') {
        return KeyType.p521;
      } else {
        throw Exception('Unsupported EC curve: $crv');
      }
    } else if (kty == 'OKP') {
      // Edwards Curve keys
      if (crv == 'Ed25519') {
        return KeyType.ed25519;
      } else if (crv == 'X25519') {
        return KeyType.x25519;
      } else {
        throw Exception('Unsupported OKP curve: $crv');
      }
    } else {
      throw Exception('Unsupported key type: $kty');
    }
  }

  /// Extract private key bytes from JWK based on key type
  List<int> _extractPrivateKeyBytes(
    Map<String, dynamic> jwk,
    KeyType keyType,
  ) {
    switch (keyType) {
      case KeyType.ed25519:
      case KeyType.x25519:
        // OKP keys: private key is in "d" parameter
        final d = jwk['d'] as String?;
        if (d == null) {
          throw Exception('Missing "d" parameter in OKP private key');
        }
        return _base64UrlDecode(d);

      case KeyType.secp256k1:
      case KeyType.p256:
      case KeyType.p384:
      case KeyType.p521:
        // EC keys: private key is in "d" parameter
        final d = jwk['d'] as String?;
        if (d == null) {
          throw Exception('Missing "d" parameter in EC private key');
        }
        return _base64UrlDecode(d);

      default:
        throw Exception('Unsupported key type for import: $keyType');
    }
  }

  /// Decode base64url string to Uint8List
  Uint8List _base64UrlDecode(String input) {
    // Add padding if needed
    var output = input.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Invalid base64url string');
    }
    return Uint8List.fromList(base64.decode(output));
  }
}

/// Result of loading DID Manager from configuration
class DidManagerLoadResult {
  final DidManager didManager;
  final String did;
  final String alias;
  final List<String> keyIds;

  DidManagerLoadResult({
    required this.didManager,
    required this.did,
    required this.alias,
    required this.keyIds,
  });
}
