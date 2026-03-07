import 'dart:convert';
import 'package:ssi/ssi.dart';

Future<void> main() async {
  // VC without proof
  final vcWithoutProof = {
    "@context": [
      "https://www.w3.org/ns/credentials/v2",
      "https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0.jsonld",
    ],
    "issuer": {"id": "did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university"},
    "type": ["VerifiableCredential", "AnyTNexigenPOCEdCert"],
    "id": "claimid:d6800dea-7d9a-40e2-b2bb-aae5f1975777",
    "credentialSchema": {
      "id": "https://schema.affinidi.io/AnyTNexigenPOCEdCertV1R0.json",
      "type": "JsonSchemaValidator2018",
    },
    "validFrom": "2026-01-29T15:01:02.355368Z",
    "validUntil": "2027-01-28T15:01:02.355368Z",
    "credentialSubject": {
      "id": "did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university",
      "student": {
        "givenName": "Sample",
        "familyName": "Student",
        "email": "student@example.com",
      },
      "institute": {"legalName": "Hong Kong University"},
      "accreditation": {
        "ecosystemId":
            "did:web:8b30a21f5a77.ngrok-free.app:hongkong-education-ministry",
      },
      "programNCourse": {"program": "Bachelor of Science"},
    },
  };

  // Public key from DID document
  final publicKeyJwk = {
    "kty": "EC",
    "crv": "secp256k1",
    "x": "7qGHiaRD4vqAfNW9iv-U0qDh9E-FzE79PNioOBjaQtM",
    "y": "ARMjJpfTXTmA2cn5ppg_AUvMauA-jwQBd8sQPqY3EIA",
  };

  // JWS from proof
  final jws =
      "eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ..ilgd49tre2pUTgw3Mf5XJAffV3bHrN2_6qWY2af9OOUZ5ivLtQkKC7HbW4WRc5B7cGDmX2BfQKB51U694IYo0A";

  print('JWS Validation Test');
  print('=' * 50);

  // Decode JWS parts
  final parts = jws.split('.');
  print(
    'JWS Header: ${utf8.decode(base64Url.decode(base64Url.normalize(parts[0])))}',
  );
  print('JWS Payload: ${parts[1]} (empty for b64:false)');
  print('JWS Signature length: ${parts[2].length} chars');
  print('');

  // Check if public key matches signature algorithm
  print('Public Key Info:');
  print('  Type: ${publicKeyJwk['kty']}');
  print('  Curve: ${publicKeyJwk['crv']}');
  print('  Expected algorithm: ES256K (ECDSA secp256k1)');
  print('');

  // Try full verification
  print('Full VC Verification Test:');
  print('-' * 50);

  final fullVc = Map<String, dynamic>.from(vcWithoutProof);
  fullVc['proof'] = {
    "type": "EcdsaSecp256k1Signature2019",
    "created": "2026-01-29T15:01:02.355402",
    "verificationMethod":
        "did:web:d1d3c0d01e8f.ngrok-free.app:hongkong-university#key-1",
    "proofPurpose": "assertionMethod",
    "jws": jws,
  };

  try {
    final vcString = jsonEncode(fullVc);
    final verifiableCredential = UniversalParser.parse(vcString);
    print('✅ VC parsed successfully');

    final universalCredentialVerifier = UniversalVerifier();
    final result = await universalCredentialVerifier.verify(
      verifiableCredential,
    );

    if (result.isValid) {
      print('✅ SIGNATURE IS VALID!');
    } else {
      print('❌ SIGNATURE VERIFICATION FAILED');
      print('Errors: ${result.errors}');
    }
  } catch (e, stackTrace) {
    print('❌ Error during verification: $e');
    print('Stack trace: $stackTrace');
  }
}
