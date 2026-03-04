import 'package:vdsp_verifier_server/core/infrastructure/config/app_config.dart';
import 'package:vdsp_verifier_server/features/trust-registry/trust_registry_api_client.dart';
import 'package:vdsp_verifier_server/features/trust-registry/validate_credentials_trust_registry_use_case.dart';

/// Checks if an entity is recognized by an authority
class CheckRecognitionUseCase {
  Future<CheckResult> call({
    required String entityId,
    required String action,
    required String resource,
    required Function onProgress,
  }) async {
    final trUrl = AppConfig.sgTrustRegistryUrl;
    final authorityId = AppConfig.sgEducationMinistryDID;

    if (trUrl.isEmpty) {
      final message =
          'TRQP: SG_EDUCATION_MINISTRY_TRUST_REGISTRY_URL not configured.';
      onProgress({'messageType': 'info', 'message': message});
      return CheckResult(valid: false, message: message);
    }

    print('CheckRecognitionUseCase: Calling Trust Registry API');
    print('  URL: $trUrl/recognition');
    print('  entity_id: $entityId');
    print('  authority_id: $authorityId');
    print('  action: $action');
    print('  resource: $resource');

    final response = await TrustRegistryApiClient()(
      '$trUrl/recognition',
      body: {
        "entity_id": entityId,
        "authority_id": authorityId,
        "action": action,
        "resource": resource,
      },
    );

    final recognized = response?['recognized'] as bool? ?? false;
    final message =
        'Ecosystem ${entityId.split(':').last} is ${recognized ? '' : 'not '}recognized by Nexigen.';

    onProgress({
      'messageType': recognized ? 'success' : 'failure',
      'message': message,
    });

    return CheckResult(
      valid: recognized,
      message: recognized
          ? 'Ecosystem is recognized by Singapore Education Ministry.'
          : 'Ecosystem is not recognized by Singapore Education Ministry.',
    );
  }
}
