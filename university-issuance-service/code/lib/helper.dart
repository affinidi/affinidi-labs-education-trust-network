import 'dart:math';

import 'package:university_issuance_service/env.dart';
import 'package:university_issuance_service/storage/storage_factory.dart';
import 'package:ssi/ssi.dart';
// ignore: implementation_imports
import 'package:ssi/src/json_ld/context.dart';
// import 'package:ssi/src/credentials/models/field_types/context.dart';
// ignore: implementation_imports
import 'package:university_issuance_service/storage/storage_interface.dart';

import 'ssi/did_web_manager.dart';

Future<Map<String, dynamic>> generateDidWeb({
  required String domain,
  String? trustRegistryUrl,
}) async {
  if (!isValidDomainPath(domain)) {
    throw ArgumentError('Invalid domain');
  }
  final storage = await StorageFactory.createDataStorage();

  final didWeb = urlToDidWeb(domain);
  final didWebPath = didWebToPath(didWeb);
  print('did web domain $domain');
  print('did web url $didWeb');
  print('did web path $didWebPath');
  final didManager = await createDidWeb(domain);
  final didDocument = await didManager.getDidDocument();

  if (trustRegistryUrl != null) {
    didDocument.service.add(
      ServiceEndpoint.fromJson({
        'id': '$didWeb#trust-registry',
        'type': 'TRQP',
        'serviceEndpoint': trustRegistryUrl,
      }),
    );
  }

  //storing did doc in did:web path e.g. /certizen/did.json - used for resolving
  await storage.put(didWebPath, didDocument.toString());

  print('[generateDidWeb] DID document generated and stored');
  print('[generateDidWeb] Storage path: $didWebPath');
  print('[generateDidWeb] Services in document:');
  for (var service in didDocument.service) {
    print('  - ${service.type}: ${service.serviceEndpoint}');
  }

  return {
    'domain': domain,
    'didWeb': didWeb,
    'didWebPath': didWebPath,
    "didDocument": didDocument,
  };
}

Future<DidWebManager> createDidWeb(String domain) async {
  // Convert domain to DID format before getting path
  final didWeb = urlToDidWeb(domain);
  final keyStorePath = didWebToPath(
    didWeb,
  ).replaceFirst('did.json', 'secrets.json');
  final keyStore = await StorageFactory.createKeyStore(keyStorePath);
  // final keyStore = InMemoryKeyStore();
  final wallet = PersistentWallet(keyStore);
  final store = InMemoryDidStore();
  final manager = DidWebManager(store: store, wallet: wallet, domain: domain);

  final mediatorDomain = Env.get('ISSUER_MEDIATOR');

  final keyId1 = "key-1";
  final keyId2 = "key-2";
  final keyId3 = "key-3";

  await wallet.generateKey(keyId: keyId1, keyType: KeyType.secp256k1);
  await wallet.generateKey(keyId: keyId2, keyType: KeyType.ed25519);
  await wallet.generateKey(keyId: keyId3, keyType: KeyType.p256);
  await manager.addVerificationMethod(
    keyId1,
    relationships: {
      VerificationRelationship
          .authentication, //No needed, but its throwing error in VDSP
      VerificationRelationship
          .assertionMethod, //No needed, but its throwing error in VDSP
      VerificationRelationship.keyAgreement,
    },
  );

  await manager.addVerificationMethod(
    keyId2,
    relationships: {
      VerificationRelationship.authentication,
      VerificationRelationship.assertionMethod,
    },
  );
  await manager.addVerificationMethod(
    keyId3,
    relationships: {
      VerificationRelationship.authentication,
      VerificationRelationship.assertionMethod,
      VerificationRelationship.keyAgreement,
    },
  );

  final did = urlToDidWeb(domain);
  print('DID: $did');
  if (mediatorDomain.isNotEmpty) {
    await manager.addServiceEndpoint(
      ServiceEndpoint(
        id: '$did#service-1',
        type: 'DIDCommMessaging',
        // type: const StringServiceType('DIDCommMessaging'),
        serviceEndpoint: ServiceEndpointValueParser.fromJson([
          {
            "accept": ["didcomm/v2"],
            "routingKeys": [],
            "uri": "https://$mediatorDomain",
          },
          {
            "accept": ["didcomm/v2"],
            "routingKeys": [],
            "uri": "wss://$mediatorDomain/ws",
          },
        ]),
      ),
    );
  }

  // Construct full URL for login endpoint
  // Extract host:port from domain (remove path if present)
  final domainParts = domain.split('/');
  final hostPort = domainParts[0];

  // Determine protocol based on USE_SSL environment variable
  final useSsl = Env.get('USE_SSL', 'true').toLowerCase() != 'false';
  final protocol = useSsl ? 'https' : 'http';
  final loginEndpoint = '$protocol://$hostPort/api/login';

  print('[DID Generation] USE_SSL env var: ${Env.get('USE_SSL', 'true')}');
  print('[DID Generation] Parsed useSsl: $useSsl');
  print('[DID Generation] Protocol: $protocol');
  print('[DID Generation] Login endpoint: $loginEndpoint');

  await manager.addServiceEndpoint(
    ServiceEndpoint(
      id: '$did#login',
      type: 'UserAuthenticationService',
      // type: const StringServiceType('UserAuthenticationService'),
      serviceEndpoint: StringEndpoint(loginEndpoint),
    ),
  );

  print('[DID Generation] UserAuthenticationService endpoint added');

  //final didDoc = await manager.getDidDocument();
  //print(didDoc);

  return manager;
}

String _getIssuerStoragePath() {
  // Use UNIVERSITY_DOMAIN to create unique data directory for each issuer
  final universityDomain = Env.get('UNIVERSITY_DOMAIN', '');
  if (universityDomain.isNotEmpty) {
    // Convert domain like "localhost:3000/hongkong-university" to "hongkong-university"
    final parts = universityDomain.split('/');
    final issuerName = parts.length > 1
        ? parts.last
        : parts.first.replaceAll(':', '_');
    final dirPath = Env.get('DATA_DIR', 'data/issuer-$issuerName');
    return '$dirPath/issuer-data.json';
  }
  final dirPath = Env.get('DATA_DIR', 'data/issuer');
  return '$dirPath/issuer-data.json';
}

Future<String> getDidWebFor(String key) async {
  // Use issuer-specific storage where DID web values are stored
  final storage = await StorageFactory.createStorage(_getIssuerStoragePath());
  final didWeb = await storage.get("${key}_did_web");

  if (didWeb == null) {
    throw Exception(
      'DID Web not found for key: $key. Make sure the DID has been generated.',
    );
  }

  return didWeb;
}

Future<DidWebManager> getDidWebManager(String key) async {
  // Use issuer-specific storage where DID web values are stored
  final storage = await StorageFactory.createStorage(_getIssuerStoragePath());
  final domain = await storage.get("${key}_did_web_domain");

  final didManager = await createDidWeb(domain);
  return didManager;
}

Future<DidSigner> getDidWebSignerFor(String key) async {
  final keyId = "key-1"; // secp256k1
  final didManager = await getDidWebManager(key);
  final doc = await didManager.getDidDocument();

  final signer = DidSigner(
    did: doc.id,
    didKeyId: doc.verificationMethod.first.id,
    keyPair: await didManager.getKeyPair(keyId),
    signatureScheme: SignatureScheme.ecdsa_secp256k1_sha256,
  );
  return signer;
}

String didWebToPath(String didWeb) {
  // Example: did:web:localhost%3A3000:hongkong-university
  var did = didWeb.replaceFirst('did:web:', '');
  // Result: localhost%3A3000:hongkong-university

  did = did.replaceAll(':', '/');
  // Result: localhost%3A3000/hongkong-university

  did = did.replaceAll('%3A', ':');
  // Result: localhost:3000/hongkong-university

  did = did.replaceAll('%2B', '/');
  did = 'https://$did';
  // Result: https://localhost:3000/hongkong-university

  final asUri = Uri.parse(did);

  // Get the path from the URI
  var path = asUri.path;
  // Result: /hongkong-university

  // Remove leading slash to make it a relative path
  if (path.startsWith('/')) {
    path = path.substring(1);
  }
  // Result: hongkong-university

  // If path is empty, use root (.well-known)
  // If path exists, append did.json directly (NO .well-known)
  if (path.isEmpty) {
    path = '.well-known/did.json';
  } else {
    // Path exists, append did.json (not .well-known/did.json)
    if (!path.endsWith('/')) {
      path = '$path/';
    }
    path = '${path}did.json';
  }
  // Result: hongkong-university/did.json

  return path;
}

/// Converts a domain (with optional path/port) to did:web
String urlToDidWeb(String urlString) {
  // If the string does not contain a scheme, add dummy scheme for Uri.parse
  final uri = Uri.parse(
    urlString.contains('://') ? urlString : 'https://$urlString',
  );

  // Host with port if present
  final host = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;

  // URL-encode host (required if it has ':', e.g., localhost:3000)
  final encodedHost = Uri.encodeComponent(host);

  // Copy path segments
  var segments = List<String>.from(uri.pathSegments);

  // Remove ".well-known/did.json" if present at the end
  if (segments.length >= 2 &&
      segments[segments.length - 2] == '.well-known' &&
      segments.last == 'did.json') {
    segments = segments.sublist(0, segments.length - 2);
  }

  // Combine host and path segments using ":" as separator
  final didWeb = ([encodedHost] + segments).join(':');

  return 'did:web:$didWeb';
}

bool isValidDomainPath(String input) {
  if (input.isEmpty) return false;

  try {
    if (input.startsWith("http://") || input.startsWith("https://")) {
      return false;
    }
    Uri.parse('https://$input');
    return true;
  } catch (e) {
    return false;
  }
}

DidDocument generateDidWebDocument({
  required String did,
  required List<String> verificationMethodIds,
  required List<PublicKey> publicKeys,
  required Map<VerificationRelationship, List<String>> relationships,
  required List<ServiceEndpoint> serviceEndpoints,
}) {
  final context = [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/jws-2020/v1",
  ];

  final vms = <EmbeddedVerificationMethod>[];
  for (var i = 0; i < verificationMethodIds.length; i++) {
    final vmId = verificationMethodIds[i];
    final pubKey = publicKeys[i];
    vms.add(
      EmbeddedVerificationMethod.fromJson({
        "id": vmId,
        "controller": did,
        "type": "JsonWebKey2020",
        "publicKeyJwk": keyToJwk(pubKey),
      }),
    );
  }

  return DidDocument.create(
    context: Context.fromJson(context),
    // context: JsonLdContext.fromJson(context),
    id: did,
    verificationMethod: vms,
    authentication:
        relationships[VerificationRelationship.authentication] ?? [],
    keyAgreement: relationships[VerificationRelationship.keyAgreement] ?? [],
    assertionMethod:
        relationships[VerificationRelationship.assertionMethod] ?? [],
    capabilityInvocation:
        relationships[VerificationRelationship.capabilityInvocation] ?? [],
    capabilityDelegation:
        relationships[VerificationRelationship.capabilityDelegation] ?? [],
    service: serviceEndpoints,
  );
}

Map<String, String> generateEmployeeData(String email) {
  final random = Random();

  const employeeSampleData = {
    'darrell': {
      'givenName': 'Darrell',
      'familyName': 'Odonnell',
      'role': 'Executive Director',
      'passport': 'FR567890',
      'dob': '1980-01-15',
      'phone': '+1 609 222 3461',
      'linkedIn': 'https://www.linkedin.com/in/darrellodonnell',
      'level': 90,
    },
    'maxwell': {
      'givenName': 'Maxwell',
      'familyName': 'Baylin',
      'role': 'Business Advisor',
      'passport': '782315880',
      'dob': '1980-12-20',
      'phone': '+44 20 3421 9567',
      'linkedIn':
          'https://www.linkedin.com/in/tryingtoleaveitbetterthenwefoundit',
      'level': 50,
    },
    'giri': {
      'givenName': 'Giriraj',
      'familyName': 'Daga',
      'role': 'Director',
      'passport': 'YY1234567',
      'dob': '1985-03-10',
      'phone': '+91 98123 45678',
      'linkedIn': 'https://www.linkedin.com/in/giriraj-daga',
      'level': 70,
    },
  };

  // Check if any key from sample data is contained in the email
  final emailLower = email.toLowerCase();

  for (var key in employeeSampleData.keys) {
    if (emailLower.contains(key)) {
      final data = employeeSampleData[key]!;
      return data.map((k, v) => MapEntry(k, v.toString()));
    }
  }

  // Generate random data if not found in sample data
  const roles = ['Advisor', 'Director', 'CEO'];
  const lastNames = ['Smith', 'Doe', 'Johnson', 'Brown', 'Davis', 'Clark'];
  String familyName;
  final username = email.split('@')[0];
  final nameParts = username.split('.');
  String givenName = _capitalize(nameParts[0]);
  if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
    familyName = _capitalize(nameParts[1]);
  } else {
    familyName = lastNames[random.nextInt(lastNames.length)];
  }

  // Determine role based on first character of family name
  String role;
  final firstChar = familyName[0].toUpperCase();
  final matchingRole = roles.firstWhere(
    (r) => r[0].toUpperCase() == firstChar,
    orElse: () => roles[0],
  );
  role = matchingRole;

  return {
    'givenName': givenName,
    'familyName': familyName,
    'role': role,
    'passport': 'P${1000 + random.nextInt(9000)}',
    'dob': '19${10 + random.nextInt(13)}-0${1 + random.nextInt(9)}-15',
  };
}

// Helper function to capitalize first letter
String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

/// Generates or regenerates a DID:web for the issuer (university)
///
/// [storage] - Storage interface for persisting data
/// [forceRegenerate] - If true, regenerates even if already exists
Future<Map<String, dynamic>> generateDIDWebForEntity(
  IStorage storage, {
  String entity = 'issuer',
  bool forceRegenerate = false,
}) async {
  // Get configuration for the entity
  final config = getEntityConfig(entity);
  final domain = config['domain']!;
  final trustRegistryUrl = config['trustRegistryUrl'];

  final storageKey = '${entity}_generated';
  final storageValue = await storage.get(storageKey);
  final isKeysGenerated = storageValue == true;

  print(
    '[generateDIDWebForEntity] Entity: $entity, Storage Key: $storageKey, Storage Value: $storageValue, IsGenerated: $isKeysGenerated',
  );

  if (!isKeysGenerated || forceRegenerate) {
    if (forceRegenerate) {
      print('Regenerating did:web for $entity with domain $domain');
    } else {
      print('Generating did:web for $entity with domain $domain');
    }

    final webData = await generateDidWeb(
      domain: domain,
      trustRegistryUrl: trustRegistryUrl,
    );

    await storage.put(storageKey, true);
    await storage.put("${entity}_did_web_domain", domain);
    await storage.put("${entity}_did_web", webData['didWeb']);

    return webData;
  } else {
    print('$entity did:web already generated for domain $domain');
    return {
      'domain': domain,
      'didWeb': await storage.get("${entity}_did_web"),
      'alreadyExists': true,
    };
  }
}

/// Gets issuer (university) configuration from environment variables
///
/// Returns a map with 'domain' and 'trustRegistryUrl'
/// Throws exception if required domain is not configured
Map<String, String?> getEntityConfig([String entity = 'issuer']) {
  String domain;
  String? trustRegistryUrl;

  // Issuer (University) configuration
  domain = Env.get('UNIVERSITY_DOMAIN');
  if (domain.isEmpty) {
    throw Exception("UNIVERSITY_DOMAIN is missing in .env file");
  }
  trustRegistryUrl = Env.get('TRUST_REGISTRY_URL');
  if (trustRegistryUrl.isEmpty) {
    throw Exception("TRUST_REGISTRY_URL is missing in .env file");
  }

  return {'domain': domain, 'trustRegistryUrl': trustRegistryUrl};
}
