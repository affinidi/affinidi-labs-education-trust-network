// import 'dart:convert';
// import 'dart:io';
// import 'package:ssi/ssi.dart';
// import '../../../core/infrastructure/config/app_config.dart';
// import '../../../core/infrastructure/storage/file_key_store.dart';
// import 'did_web_manager.dart';

// /// Generates and manages did:web DID documents for the verifier
// class DidDocumentGenerator {
//   static const String keysDir = 'keys';
//   static const String didDocFile = 'did-document.json';
//   static const String secretsFile = 'secrets.json';

//   /// Generates or retrieves existing did:web DID document
//   ///
//   /// Checks if DID document exists on disk and loads it.
//   /// If not found, generates a new one with cryptographic keys and service endpoints.
//   ///
//   /// Returns the DID document as Map<String, dynamic>
//   static Future<Map<String, dynamic>> generateOrGetDidDocument() async {
//     final domain = AppConfig.verifierDomain;
//     if (domain.isEmpty) {
//       throw Exception('VERIFIER_DOMAIN is missing in environment');
//     }

//     final verifierDid = AppConfig.verifierDid;
//     print('[DidDocumentGenerator] Domain: $domain');
//     print('[DidDocumentGenerator] DID: $verifierDid');

//     // Check if DID document already exists
//     final didDocPath = '$keysDir/$didDocFile';
//     final didDocFileObj = File(didDocPath);

//     if (await didDocFileObj.exists()) {
//       print('[DidDocumentGenerator] Loading existing DID document from file');
//       final content = await didDocFileObj.readAsString();
//       return jsonDecode(content) as Map<String, dynamic>;
//     }

//     print('[DidDocumentGenerator] Generating new DID document');

//     // Create keys directory if it doesn't exist
//     final keysDirectory = Directory(keysDir);
//     if (!await keysDirectory.exists()) {
//       await keysDirectory.create(recursive: true);
//       print('[DidDocumentGenerator] Created keys directory');
//     }

//     // Generate DID document with keys
//     final didDocument = await _generateDidDocument(domain, verifierDid);

//     // Save DID document to file
//     await didDocFileObj.writeAsString(
//       const JsonEncoder.withIndent('  ').convert(didDocument),
//     );
//     print('[DidDocumentGenerator] DID document saved to $didDocPath');

//     return didDocument;
//   }

//   /// Internal method to generate DID document with cryptographic keys and service endpoints
//   static Future<Map<String, dynamic>> _generateDidDocument(
//     String domain,
//     String verifierDid,
//   ) async {
//     // Create key store and wallet
//     final keyStorePath = '$keysDir/$secretsFile';
//     final keyStore = FileKeyStore(filePath: keyStorePath);
//     final wallet = PersistentWallet(keyStore);
//     final store = InMemoryDidStore();

//     // Create DID manager
//     final manager = DidWebManager(store: store, wallet: wallet, domain: domain);

//     // Generate three keys with different cryptographic algorithms
//     const keyId1 = "key-1";
//     const keyId2 = "key-2";
//     const keyId3 = "key-3";

//     await wallet.generateKey(keyId: keyId1, keyType: KeyType.secp256k1);
//     await wallet.generateKey(keyId: keyId2, keyType: KeyType.ed25519);
//     await wallet.generateKey(keyId: keyId3, keyType: KeyType.p256);

//     // Add verification methods with relationships
//     await manager.addVerificationMethod(
//       keyId1,
//       relationships: {
//         VerificationRelationship.authentication,
//         VerificationRelationship.assertionMethod,
//         VerificationRelationship.keyAgreement,
//       },
//     );

//     await manager.addVerificationMethod(
//       keyId2,
//       relationships: {
//         VerificationRelationship.authentication,
//         VerificationRelationship.assertionMethod,
//       },
//     );

//     await manager.addVerificationMethod(
//       keyId3,
//       relationships: {
//         VerificationRelationship.authentication,
//         VerificationRelationship.assertionMethod,
//         VerificationRelationship.keyAgreement,
//       },
//     );

//     // Add DIDComm service endpoint for mediator
//     final mediatorDid = AppConfig.mediatorDid;
//     if (mediatorDid.isNotEmpty) {
//       final mediatorUrl = AppConfig.mediatorUrl;
//       final mediatorDomain = Uri.parse(mediatorUrl).host;

//       await manager.addServiceEndpoint(
//         ServiceEndpoint(
//           id: '$verifierDid#service-1',
//           type: StringServiceType('DIDCommMessaging'),
//           serviceEndpoint: ServiceEndpointValueParser.fromJson([
//             {
//               "accept": ["didcomm/v2"],
//               "routingKeys": [],
//               "uri": "https://$mediatorDomain",
//             },
//             {
//               "accept": ["didcomm/v2"],
//               "routingKeys": [],
//               "uri": "wss://$mediatorDomain/ws",
//             },
//           ]),
//         ),
//       );
//       print('[DidDocumentGenerator] Added DIDComm service endpoint');
//     }

//     // Add UserAuthenticationService endpoint
//     final domainParts = domain.split('/');
//     final hostPort = domainParts[0];

//     final useSsl = AppConfig.useSsl;
//     final protocol = useSsl ? 'https' : 'http';
//     final loginEndpoint = '$protocol://$hostPort/api/auth';

//     print('[DidDocumentGenerator] USE_SSL: $useSsl');
//     print('[DidDocumentGenerator] Protocol: $protocol');
//     print('[DidDocumentGenerator] Login endpoint: $loginEndpoint');

//     await manager.addServiceEndpoint(
//       ServiceEndpoint(
//         id: '$verifierDid#auth',
//         type: StringServiceType('UserAuthenticationService'),
//         serviceEndpoint: StringEndpoint(loginEndpoint),
//       ),
//     );
//     print('[DidDocumentGenerator] Added UserAuthenticationService endpoint');

//     // Get the final DID document
//     final didDocument = await manager.getDidDocument();

//     print('[DidDocumentGenerator] DID document generated successfully');
//     print('[DidDocumentGenerator] Services in document:');
//     for (var service in didDocument.service) {
//       print('  - ${service.type}: ${service.serviceEndpoint}');
//     }

//     return jsonDecode(didDocument.toString()) as Map<String, dynamic>;
//   }
// }
