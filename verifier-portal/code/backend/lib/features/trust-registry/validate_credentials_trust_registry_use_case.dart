import 'package:ssi/ssi.dart';
import 'package:vdsp_verifier_server/features/trust-registry/check_ecosystem_authorization_use_case.dart';
import 'package:vdsp_verifier_server/features/trust-registry/check_recognition_use_case.dart';

class CheckResult {
  final bool valid;
  final String message;

  CheckResult({required this.valid, required this.message});
}

class PerVCTrustRegistryResult {
  final VerifiableCredential vc;
  final CheckResult governanceRecognitionCheck;
  final CheckResult issuerAuthorizationCheck;

  PerVCTrustRegistryResult({
    required this.vc,
    required this.governanceRecognitionCheck,
    required this.issuerAuthorizationCheck,
  });

  bool get isValid =>
      governanceRecognitionCheck.valid && issuerAuthorizationCheck.valid;
}

/// Performs trust registry checks on all VCs in a verifiable presentation
class ValidateCredentialsTrustRegistryUseCase {
  static const _allowedTypes = ['AnyTNexigenPOCEdCert', 'EducationCredential'];

  Future<List<PerVCTrustRegistryResult>> call(
    VerifiablePresentation verifiablePresentation, {
    required Function onProgress,
  }) async {
    try {
      final results = <PerVCTrustRegistryResult>[];
      final vcs = verifiablePresentation.verifiableCredential;

      if (vcs.isEmpty) {
        print('No verifiable credentials found in the presentation');
        return results;
      }

      for (var vc in vcs) {
        final vcResult = await _checkSingleCredential(vc, onProgress);
        results.add(vcResult);
      }

      return results;
    } catch (e, stackTrace) {
      print('Error performing trust registry checks: $e');
      print('Stack trace: $stackTrace');
      onProgress({
        'messageType': 'failure',
        'message': 'TRQP: Error occurred while checking Trust Registry: $e}',
      });
      return [];
    }
  }

  Future<PerVCTrustRegistryResult> _checkSingleCredential(
    VerifiableCredential vc,
    Function onProgress,
  ) async {
    final vcType = vc.type.toList()[1]; // Get VC Type

    if (!_allowedTypes.contains(vcType)) {
      print('TRQP: Skipping checks as VC type $vcType is not allowed.');
      return _createSkippedResult(vc, vcType);
    }

    final issuerId = vc.issuer.id.toString();
    final authorityId = vc.credentialSubject[0]['accreditation']['ecosystemId'];

    final issuerAuthorizationCheck = await _checkIssuerAuthorization(
      issuerId: issuerId,
      authorityId: authorityId,
      vcType: vcType,
      onProgress: onProgress,
    );

    final governanceRecognitionCheck = await CheckRecognitionUseCase()(
      entityId: authorityId ?? '',
      action: 'recognize',
      resource: "listed-registry",
      onProgress: onProgress,
    );

    return PerVCTrustRegistryResult(
      vc: vc,
      governanceRecognitionCheck: governanceRecognitionCheck,
      issuerAuthorizationCheck: issuerAuthorizationCheck,
    );
  }

  Future<CheckResult> _checkIssuerAuthorization({
    required String issuerId,
    required String? authorityId,
    required String vcType,
    required Function onProgress,
  }) async {
    if (authorityId == null) {
      final message =
          'TRQP: Skipping checks as VC does not have ecosystem in credentialSubject.';
      onProgress({'messageType': 'info', 'message': message});
      return CheckResult(
        valid: false,
        message: 'VC does not have ecosystem in credentialSubject',
      );
    }

    final resource = vcType;
    // .toLowerCase();
    print(
      'TRQP: Checking authorization of issuer $issuerId for action issue on resource $resource under authority $authorityId.',
    );

    return await CheckEcosystemAuthorizationUseCase()(
      entityId: issuerId,
      authorityId: authorityId,
      action: 'issue',
      resource: resource,
      onProgress: onProgress,
    );
  }

  PerVCTrustRegistryResult _createSkippedResult(
    VerifiableCredential vc,
    String vcType,
  ) {
    return PerVCTrustRegistryResult(
      vc: vc,
      governanceRecognitionCheck: CheckResult(
        valid: true,
        message: 'Skipped: VC type $vcType not configured for checking',
      ),
      issuerAuthorizationCheck: CheckResult(
        valid: true,
        message: 'Skipped: VC type $vcType not configured for checking',
      ),
    );
  }
}
