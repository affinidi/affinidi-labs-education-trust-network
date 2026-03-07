import 'package:ssi/ssi.dart';

Future<void> main() async {
  // Read VC directly from file or API response without modification
  // var vcString =
  //     '{"@context":["https://www.w3.org/ns/credentials/v2","https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0.jsonld"],"issuer":{"id":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university"},"type":["VerifiableCredential","AnyTNexigenPOCEdCert"],"id":"claimid:d6800dea-7d9a-40e2-b2bb-aae5f1975777","credentialSchema":{"id":"https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0.json","type":"JsonSchemaValidator2018"},"validFrom":"2026-01-29T15:01:02.355368Z","validUntil":"2027-01-28T15:01:02.355368Z","credentialSubject":{"id":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university","student":{"givenName":"Sample","familyName":"Student","email":"student@example.com"},"institute":{"legalName":"Hong Kong University"},"accreditation":{"ecosystemId":"did:web:8b30a21f5a77.ngrok-free.app:hongkong-education-ministry"},"programNCourse":{"program":"Bachelor of Science"}},"proof":{"type":"EcdsaSecp256k1Signature2019","created":"2026-01-29T15:01:02.355402","verificationMethod":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university#key-1","proofPurpose":"assertionMethod","jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ..ilgd49tre2pUTgw3Mf5XJAffV3bHrN2_6qWY2af9OOUZ5ivLtQkKC7HbW4WRc5B7cGDmX2BfQKB51U694IYo0A"}}';
  var vcString =
      '{ "@context": [ "https://www.w3.org/ns/credentials/v2", "https://schema.affinidi.io/EmploymentV1R0.jsonld" ], "issuer": { "id": "did:web:issuers.sa.affinidi.io:sweetlane-bank" }, "type": [ "VerifiableCredential", "Employment" ], "id": "claimid:5269ee5b-eb00-4c26-a7b3-7f527711284e", "credentialSchema": { "id": "https://schema.affinidi.io/EmploymentV1R0.json", "type": "JsonSchemaValidator2018" }, "validFrom": "2025-11-23T09:19:14.366461Z", "validUntil": "2026-11-23T09:19:14.366461Z", "credentialSubject": { "id": "did:key:zQ3shsew5aobruVWDrQsuH1BK7tjLgHRTQmPP7hZ3D9hbspCH", "recipient": { "type": "PersonName", "givenName": "Alex", "familyName": "Sample" }, "role": "Advisor", "description": "Your role is Advisor", "place": "Bangalore", "legalEmployer": { "type": "Organization", "name": "Sweetlane Bank", "identifier": "did:web:issuers.sa.affinidi.io:sweetlane-bank", "place": "Bangalore" }, "employmentType": "permanent", "startDate": "2022-01" }, "proof": { "type": "EcdsaSecp256k1Signature2019", "created": "2025-11-23T09:19:14.366491", "verificationMethod": "did:web:issuers.sa.affinidi.io:sweetlane-bank#key-1", "proofPurpose": "assertionMethod", "jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ..HM7GgFEnqQPvzkQEp2BWFndQD_1wAUdmFyjK-ng1D9M9iYpL4IQF0YHk38-YVw7yFhT74yeXdrgHHE7jHcNuCg" } }';
  final verifiableCredential = UniversalParser.parse(vcString);
  print('verifiableCredential: $verifiableCredential');

  final universalCredentialVerifier = UniversalVerifier();
  final result = await universalCredentialVerifier.verify(verifiableCredential);
  print('VC result : ${result.isValid}');
  if (!result.isValid) {
    print('Errors: ${result.errors}');
  }
}
