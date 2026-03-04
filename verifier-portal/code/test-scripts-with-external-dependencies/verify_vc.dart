import 'dart:convert';
import 'package:ssi/ssi.dart';

Future<void> main() async {
  // Read VC directly from file or API response without modification
  // var vcString =
  //     '{"@context":["https://www.w3.org/ns/credentials/v2","https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0V1R0.jsonld"],"issuer":{"id":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university"},"type":["VerifiableCredential","AnyTNexigenPOCEdCert"],"id":"claimid:d6800dea-7d9a-40e2-b2bb-aae5f1975777","credentialSchema":{"id":"https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0V1R0.json","type":"JsonSchemaValidator2018"},"validFrom":"2026-01-29T15:01:02.355368Z","validUntil":"2027-01-28T15:01:02.355368Z","credentialSubject":{"id":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university","student":{"givenName":"Sample","familyName":"Student","email":"student@example.com"},"institute":{"legalName":"Hong Kong University"},"accreditation":{"ecosystemId":"did:web:8b30a21f5a77.ngrok-free.app:hongkong-education-ministry"},"programNCourse":{"program":"Bachelor of Science"}},"proof":{"type":"EcdsaSecp256k1Signature2019","created":"2026-01-29T15:01:02.355402","verificationMethod":"did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university#key-1","proofPurpose":"assertionMethod","jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ..ilgd49tre2pUTgw3Mf5XJAffV3bHrN2_6qWY2af9OOUZ5ivLtQkKC7HbW4WRc5B7cGDmX2BfQKB51U694IYo0A"}}';
  var vcString =
      '{"@context":["https://www.w3.org/ns/credentials/v2","https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0V1R0.jsonld"],"issuer":{"id":"did:web:1a49c38ec23a.ngrok-free.app:hongkong-university"},"type":["VerifiableCredential","AnyTNexigenPOCEdCert"],"id":"claimid:d5283876-aa84-4b0d-8579-8dace83fee6c","credentialSchema":{"id":"https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0V1R0.json","type":"JsonSchemaValidator2018"},"validFrom":"2026-01-30T03:35:02.330639Z","validUntil":"2027-01-29T03:35:02.330639Z","credentialSubject":{"id":"did:key:zQ3shmPwYZERJfVabm4GFbNCaDUe9ASkV94KgnJyJzKtvyYy6","student":{"givenName":"Sample","familyName":"Student","email":"student@example.com"},"institute":{"legalName":"Hong Kong University"},"accreditation":{"ecosystemId":"did:web:a421508a51a5.ngrok-free.app:hongkong-education-ministry"},"programNCourse":{"program":"Bachelor of Science"}},"proof":{"type":"EcdsaSecp256k1Signature2019","created":"2026-01-30T03:35:02.330692","verificationMethod":"did:web:1a49c38ec23a.ngrok-free.app:hongkong-university#key-1","proofPurpose":"assertionMethod","jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ..-jk3cTuWg0pRFCqGHOs0r9Mhsd_29gAx4PJloyP77TlXtJdyJ-Vit440MXYMS_THhNML5e9wkeYzRqPGfEGJKg"}}';
  final verifiableCredential = UniversalParser.parse(vcString);
  print('verifiableCredential: $verifiableCredential');

  final universalCredentialVerifier = UniversalVerifier();
  final result = await universalCredentialVerifier.verify(verifiableCredential);
  print('VC result : ${result.isValid}');
  if (!result.isValid) {
    print('Errors: ${result.errors}');
  }
}
