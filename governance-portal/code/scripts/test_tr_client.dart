import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';

import '../lib/core/infrastructure/didcomm/message_types.dart';

void main(List<String> args) async {
  print('🚀 Simple DIDComm Sender and Receiver Example');
  print('━' * 50);

  try {
    final configPath = args.isNotEmpty ? args[0] : 'assets/user_config.hk.json';

    print('Loading config from: $configPath');

    final configFile = File(configPath);
    final configJson =
        jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;

    final didEntry = configJson.entries.first;
    final did = didEntry.key;

    print('Loaded DID: ${did.substring(0, 16)}...');

    // Load DID manager from config
    final didManager = await loadDidManagerFromConfig(configJson);
    final myDidDoc = await didManager.getDidDocument();
    print('DID from DID Manager: ${myDidDoc.id.substring(0, 16)}...');
    print('Are both same ? : ${did == myDidDoc.id}');

    final recipientDid =
        'did:peer:2.VzDnaexBhbZF9a77fiag7Wn3ieEDLV76z87PTeZah3SRWvSTUg.EzQ3shuyiu4TnxLkbYLhntGaL39yT88LUsYopJWwaNnzu5RHQ3.SeyJ0IjoiZG0iLCJzIjoiZGlkOndlYjp0cmlwLWJhdHRlcnkubWVkaWF0b3IuYWZmaW5pZGkuaW8ifQ';
    final mediatorDid = 'did:web:apse1.mediator.affinidi.io:.well-known';

    final mediatorClient = await initMediatorClient(didManager, mediatorDid);

    // Start listening
    final subscription = await startMessageListener(mediatorClient, didManager);

    // Send list-records message
    await sendListRecordsMessage(mediatorClient, recipientDid);

    // Wait for Ctrl+C
    print('Listening for messages... (Press Ctrl+C to exit)');

    final messages = await mediatorClient.fetchMessages();
    for (final message in messages) {
      final unpacked = await DidcommMessage.unpackToPlainTextMessage(
        message: message,
        recipientDidManager: didManager,
        expectedMessageWrappingTypes: [
          MessageWrappingType.authcryptPlaintext,
          MessageWrappingType.anoncryptSignPlaintext,
          MessageWrappingType.authcryptSignPlaintext,
        ],
      );

      print('Message unpacked successfully');
      print('  Type: ${unpacked.type}');
      print('  ID: ${unpacked.id}');
      print('  Thread ID: ${unpacked.threadId}');
      print('  From: ${unpacked.from}');
      print('  Body: ${unpacked.body}');
    }

    ProcessSignal.sigint.watch().listen((_) async {
      print('\nReceived interrupt signal, shutting down...');
      await subscription.cancel();
      exit(0);
    });
  } catch (e, stackTrace) {
    print('Error in example: $e');
    print(stackTrace);
    exit(1);
  }
}

Future<DidManager> loadDidManagerFromConfig(
    Map<String, dynamic> configJson) async {
  final didEntry = configJson.entries.first;
  final profile = didEntry.value as Map<String, dynamic>;
  final secrets = (profile['secrets'] as List).cast<Map<String, dynamic>>();

  print('Profile alias: ${profile['alias']}');
  print('Secrets count: ${secrets.length}');

  final keyStore = InMemoryKeyStore();
  final wallet = PersistentWallet(keyStore);
  final didManager = DidPeerManager(
    store: InMemoryDidStore(),
    wallet: wallet,
  );

  for (final secret in secrets) {
    final privateKeyJwk = secret['privateKeyJwk'] as Map<String, dynamic>;
    final secretId = secret['id'] as String;
    final keyType = _getKeyTypeFromJwk(privateKeyJwk);

    final keyId = await importPrivateKeyJwk(
      wallet: wallet,
      keyStore: keyStore,
      secretId: secretId,
      privateKeyJwk: privateKeyJwk,
    );

    final relationships = <VerificationRelationship>{};
    if (keyType == KeyType.secp256k1) {
      // secp256k1 is used for encryption (key agreement)
      relationships.add(VerificationRelationship.keyAgreement);
    } else if (keyType == KeyType.p256 || keyType == KeyType.ed25519) {
      // P256 and Ed25519 are used for authentication and assertion
      relationships.add(VerificationRelationship.authentication);
    } else {
      relationships.add(VerificationRelationship.authentication);
      relationships.add(VerificationRelationship.assertionMethod);
    }

    await didManager.addVerificationMethod(keyId, relationships: relationships);
  }

  return didManager;
}

/// Import a private key JWK into the wallet/keystore
Future<String> importPrivateKeyJwk({
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

Future<DidcommMediatorClient> initMediatorClient(
  DidManager didManager,
  String mediatorDid,
) async {
  print('Resolving mediator: $mediatorDid');

  final mediatorDidDoc =
      await UniversalDIDResolver.defaultResolver.resolveDid(mediatorDid);

  final authorizationProvider = await AffinidiAuthorizationProvider.init(
    mediatorDidDocument: mediatorDidDoc,
    didManager: didManager,
  );

  final mediatorClient = await DidcommMediatorClient.init(
    didManager: didManager,
    mediatorDidDocument: mediatorDidDoc,
    authorizationProvider: authorizationProvider,
    clientOptions: const ClientOptions(),
  );
  print('Mediator client initialized');

  return mediatorClient;
}

Future<StreamSubscription> startMessageListener(
  DidcommMediatorClient mediatorClient,
  DidManager didManager,
) async {
  print('Starting message listener...');

  final subscription = await mediatorClient.listenForIncomingMessages(
    (message) async {
      print('📨 Received message!');
      try {
        final unpacked = await DidcommMessage.unpackToPlainTextMessage(
          message: message,
          recipientDidManager: didManager,
          expectedMessageWrappingTypes: [
            MessageWrappingType.authcryptPlaintext,
            MessageWrappingType.anoncryptSignPlaintext,
            MessageWrappingType.authcryptSignPlaintext,
          ],
        );

        print('Message unpacked successfully');
        print('  Type: ${unpacked.type}');
        print('  ID: ${unpacked.id}');
        print('  Thread ID: ${unpacked.threadId}');
        print('  From: ${unpacked.from}');
        print('  Body: ${unpacked.body}');
      } catch (e, stackTrace) {
        print('Error unpacking message: $e');
        print(stackTrace);
      }
    },
    onError: (error) {
      print('Error in message listener: $error');
    },
  );

  return subscription;
}

Future<void> sendListRecordsMessage(
  DidcommMediatorClient mediatorClient,
  String recipientDid,
) async {
  print('Sending list-records message to TR...');
  print(' Recipient: ${recipientDid.substring(0, 60)}...');

  final messageId = const Uuid().v4();
  final message = PlainTextMessage(
    id: messageId,
    type: Uri.parse(TrAdminMessageTypes.listRecords),
    from: null,
    to: [recipientDid],
    body: <String, dynamic>{},
    createdTime: DateTime.now(),
    expiresTime: DateTime.now().add(const Duration(minutes: 5)),
  );

  print(' Message type: ${TrAdminMessageTypes.listRecords}');
  print(' Message ID: $messageId');

  await mediatorClient.packAndSendMessage(message);
  print('Message sent');
}
