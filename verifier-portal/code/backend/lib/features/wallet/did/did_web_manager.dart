// import 'package:ssi/ssi.dart';
// import 'did_web_utils.dart';

// /// Manages did:web DID documents including verification methods and service endpoints
// class DidWebManager extends DidManager {
//   final String domain;

//   DidWebManager({
//     required super.store,
//     required super.wallet,
//     required this.domain,
//   });

//   @override
//   Future<AddVerificationMethodResult> addVerificationMethod(
//     String walletKeyId, {
//     Set<VerificationRelationship>? relationships,
//   }) async {
//     final result = await super.addVerificationMethod(
//       walletKeyId,
//       relationships: relationships,
//     );
//     return result;
//   }

//   @override
//   Future<DidDocument> getDidDocument() async {
//     final verificationMethods = await store.verificationMethodIds;
//     final did = urlToDidWeb(domain);

//     final uniqueVmIds = await store.verificationMethodIds;
//     final verificationMethodsPubKeys = <PublicKey>[];
//     for (final vmId in verificationMethods) {
//       final walletKeyId = await getWalletKeyId(vmId);
//       if (walletKeyId == null) continue;
//       var publicKey = await wallet.getPublicKey(walletKeyId);
//       verificationMethodsPubKeys.add(publicKey);
//     }

//     final relationships = {
//       VerificationRelationship.authentication: authentication.toList(),
//       VerificationRelationship.keyAgreement: keyAgreement.toList(),
//       VerificationRelationship.assertionMethod: assertionMethod.toList(),
//     };

//     return generateDidWebDocument(
//       did: did,
//       verificationMethodIds: uniqueVmIds,
//       publicKeys: verificationMethodsPubKeys,
//       relationships: relationships,
//       serviceEndpoints: service.toList(),
//     );
//   }

//   @override
//   Future<String> buildVerificationMethodId(PublicKey publicKey) async {
//     final did = urlToDidWeb(domain);
//     final verificationMethods = await store.verificationMethodIds;
//     final fragment = 'key-${verificationMethods.length + 1}';
//     return '$did#$fragment';
//   }
// }
