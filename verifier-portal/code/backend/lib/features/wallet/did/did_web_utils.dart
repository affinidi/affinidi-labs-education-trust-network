// import 'package:ssi/ssi.dart';
// // ignore: implementation_imports
// import 'package:ssi/src/did/public_key_utils.dart';
// // ignore: implementation_imports

// /// Convert URL to did:web format
// /// Example: "example.com/nova-corp" -> "did:web:example.com:nova-corp"
// String urlToDidWeb(String url) {
//   // Remove protocol if present
//   var domain = url.replaceAll(RegExp(r'^https?://'), '');

//   // Replace : with %3A and / with :
//   domain = domain.replaceAll(':', '%3A').replaceAll('/', ':');

//   return 'did:web:$domain';
// }

// /// Generate DID Web document with verification methods and service endpoints
// DidDocument generateDidWebDocument({
//   required String did,
//   required List<String> verificationMethodIds,
//   required List<PublicKey> publicKeys,
//   required Map<VerificationRelationship, List<String>> relationships,
//   required List<ServiceEndpoint> serviceEndpoints,
// }) {
//   final context = [
//     "https://www.w3.org/ns/did/v1",
//     "https://w3id.org/security/suites/jws-2020/v1",
//   ];

//   final vms = <EmbeddedVerificationMethod>[];
//   for (var i = 0; i < verificationMethodIds.length; i++) {
//     final vmId = verificationMethodIds[i];
//     final pubKey = publicKeys[i];
//     vms.add(
//       EmbeddedVerificationMethod.fromJson({
//         "id": vmId,
//         "controller": did,
//         "type": "JsonWebKey2020",
//         "publicKeyJwk": keyToJwk(pubKey),
//       }),
//     );
//   }

//   return DidDocument.create(
//     context: JsonLdContext.fromJson(context),
//     id: did,
//     verificationMethod: vms,
//     authentication:
//         relationships[VerificationRelationship.authentication] ?? [],
//     keyAgreement: relationships[VerificationRelationship.keyAgreement] ?? [],
//     assertionMethod:
//         relationships[VerificationRelationship.assertionMethod] ?? [],
//     capabilityInvocation:
//         relationships[VerificationRelationship.capabilityInvocation] ?? [],
//     capabilityDelegation:
//         relationships[VerificationRelationship.capabilityDelegation] ?? [],
//     service: serviceEndpoints,
//   );
// }

// /// Gets the path where DID document should be served
// /// Example: did:web:example.com:nova-corp -> "/nova-corp/did.json"
// String getDidDocumentPath(String verifierDid) {
//   final parts = verifierDid.split(':');
//   if (parts.length >= 4) {
//     // Extract path segments after domain
//     final pathSegments = parts.sublist(3);
//     return '/${pathSegments.join('/')}/did.json';
//   }
//   // Fallback for root domain
//   return '/.well-known/did.json';
// }
