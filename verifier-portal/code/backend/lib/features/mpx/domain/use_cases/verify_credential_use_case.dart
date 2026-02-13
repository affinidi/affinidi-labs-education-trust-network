import 'package:ssi/ssi.dart';

class VerifyCredentialUseCase {
  Future<VerificationResult> call(String vcString) async {
    final verifiableCredential = UniversalParser.parse(vcString);
    final universalCredentialVerifier = UniversalVerifier();
    final result = await universalCredentialVerifier.verify(
      verifiableCredential,
    );
    return result;
  }
}
