import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'storage_interface.dart';
import 'env.dart';

/// Generates a random Ed25519 key pair
Map<String, String> generateEd25519KeyPair() {
  final random = Random.secure();
  final privateKeyBytes = List<int>.generate(32, (_) => random.nextInt(256));

  // For a real implementation, you'd use proper Ed25519 key generation
  // This is a simplified version for demonstration
  final privateKeyHex = hex.encode(privateKeyBytes);

  // Generate a mock public key (in reality, derive from private key)
  final publicKeyBytes = List<int>.generate(32, (_) => random.nextInt(256));
  final publicKeyHex = hex.encode(publicKeyBytes);

  return {
    'privateKey': privateKeyHex,
    'publicKey': publicKeyHex,
  };
}

/// Generates a DID:web document for an education ministry
Future<Map<String, dynamic>> generateDidWeb({
  required String domain,
  String? trustRegistryUrl,
}) async {
  print('[generateDidWeb] Generating DID for domain: $domain');

  // Generate key pair
  final keyPair = generateEd25519KeyPair();
  final publicKeyHex = keyPair['publicKey']!;
  final privateKeyHex = keyPair['privateKey']!;

  // Construct DID
  final did = 'did:web:${domain.replaceAll('/', ':')}';

  // Build DID document
  final didDocument = {
    '@context': [
      'https://www.w3.org/ns/did/v1',
      'https://w3id.org/security/suites/ed25519-2020/v1',
    ],
    'id': did,
    'verificationMethod': [
      {
        'id': '$did#key-1',
        'type': 'Ed25519VerificationKey2020',
        'controller': did,
        'publicKeyMultibase': 'z$publicKeyHex',
      }
    ],
    'authentication': ['$did#key-1'],
    'assertionMethod': ['$did#key-1'],
  };

  // Add trust registry service if provided
  if (trustRegistryUrl != null && trustRegistryUrl.isNotEmpty) {
    didDocument['service'] = [
      {
        'id': '$did#trust-registry',
        'type': 'TrustRegistry',
        'serviceEndpoint': trustRegistryUrl,
      }
    ];
  }

  print('[generateDidWeb] Generated DID: $did');

  return {
    'didWeb': did,
    'domain': domain,
    'didDocument': didDocument,
    'privateKey': privateKeyHex,
    'publicKey': publicKeyHex,
  };
}

/// Generates or retrieves a DID:web for an education ministry
Future<Map<String, dynamic>> generateEducationMinistryDID(
  IStorage storage, {
  required String ministryName,
  required String domain,
  String? trustRegistryUrl,
  bool forceRegenerate = false,
}) async {
  final storageKey = '${ministryName}_generated';
  final isGenerated = await storage.get(storageKey) == true;

  print('[generateEducationMinistryDID] Ministry: $ministryName');
  print('[generateEducationMinistryDID] Already generated: $isGenerated');

  if (!isGenerated || forceRegenerate) {
    if (forceRegenerate) {
      print(
          '[generateEducationMinistryDID] Regenerating DID for $ministryName');
    } else {
      print(
          '[generateEducationMinistryDID] Generating new DID for $ministryName');
    }

    final didData = await generateDidWeb(
      domain: domain,
      trustRegistryUrl: trustRegistryUrl,
    );

    // Store metadata
    await storage.put(storageKey, true);
    await storage.put('${ministryName}_did', didData['didWeb']);
    await storage.put('${ministryName}_domain', domain);

    // Store DID document at the path that will be served
    final didDocJson = json.encode(didData['didDocument']);
    await storage.put('$ministryName/did.json', didDocJson);

    // Store private key securely
    await storage.put('${ministryName}_private_key', didData['privateKey']);

    print(
        '[generateEducationMinistryDID] ✅ DID generated: ${didData['didWeb']}');
    print(
        '[generateEducationMinistryDID] ✅ Document stored at: $ministryName/did.json');

    return didData;
  } else {
    final existingDid = await storage.get('${ministryName}_did');
    print('[generateEducationMinistryDID] ✅ Using existing DID: $existingDid');

    return {
      'didWeb': existingDid,
      'domain': domain,
      'alreadyExists': true,
    };
  }
}
