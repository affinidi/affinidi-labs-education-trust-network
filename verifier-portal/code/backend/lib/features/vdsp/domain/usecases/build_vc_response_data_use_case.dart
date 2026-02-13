import 'package:vdsp_verifier_server/features/trust-registry/validate_credentials_trust_registry_use_case.dart';

/// Builds verifiable credentials response data with trust registry results
class BuildVcResponseDataUseCase {
  BuildVcResponseDataUseCase();

  List<Map<String, dynamic>> call(List<PerVCTrustRegistryResult> perVCResults) {
    print(
      'Building verifiableCredentials array from ${perVCResults.length} VC results',
    );

    final verifiableCredentials = perVCResults.asMap().entries.map((entry) {
      final index = entry.key;
      final vcResult = entry.value;

      return _buildSingleVcData(index, vcResult);
    }).toList();

    print('Successfully built ${verifiableCredentials.length} VC entries');
    return verifiableCredentials;
  }

  Map<String, dynamic> _buildSingleVcData(
    int index,
    PerVCTrustRegistryResult vcResult,
  ) {
    print('Processing VC #$index');
    print(
      'Governance check - valid: ${vcResult.governanceRecognitionCheck.valid}, message: ${vcResult.governanceRecognitionCheck.message}',
    );
    print(
      'Issuer check - valid: ${vcResult.issuerAuthorizationCheck.valid}, message: ${vcResult.issuerAuthorizationCheck.message}',
    );

    try {
      final vcJson = vcResult.vc.toJson();
      print(
        'VC #$index serialized successfully, keys: ${vcJson.keys.join(", ")}',
      );

      final vcData = {
        'vc': vcJson,
        'trustRegistryResult': {
          'governanceRecognitionCheck': {
            'valid': vcResult.governanceRecognitionCheck.valid,
            'message': vcResult.governanceRecognitionCheck.message,
          },
          'issuerAuthorizationCheck': {
            'valid': vcResult.issuerAuthorizationCheck.valid,
            'message': vcResult.issuerAuthorizationCheck.message,
          },
        },
      };

      print('VC #$index data structure built successfully');
      return vcData;
    } catch (e, stackTrace) {
      print('ERROR: Failed to process VC #$index: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
