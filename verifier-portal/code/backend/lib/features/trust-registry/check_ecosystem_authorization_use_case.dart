import 'package:vdsp_verifier_server/features/trust-registry/resolve_trust_registry_url_use_case.dart';
import 'package:vdsp_verifier_server/features/trust-registry/trust_registry_api_client.dart';
import 'package:vdsp_verifier_server/features/trust-registry/validate_credentials_trust_registry_use_case.dart';

/// Checks if an entity is authorized by an ecosystem authority
class CheckEcosystemAuthorizationUseCase {
  Future<CheckResult> call({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
    required Function onProgress,
  }) async {
    final trUrl = await ResolveTrustRegistryUrlUseCase()(entityId);

    if (trUrl == null || trUrl.isEmpty) {
      final message = 'TRQP: Trust registry URL not found for entity.';
      onProgress({'messageType': 'info', 'message': message});
      return CheckResult(valid: false, message: message);
    }
    print('CheckEcosystemAuthorizationUseCase: Calling Trust Registry API');
    print('  URL: $trUrl/authorization');
    print('  entity_id: $entityId');
    print('  authority_id: $authorityId');
    print('  action: $action');
    print('  resource: $resource');

    final response = await TrustRegistryApiClient()(
      '$trUrl/authorization',
      body: {
        "entity_id": entityId,
        "authority_id": authorityId,
        "action": action,
        "resource": resource,
      },
    );

    final verified = response?['authorized'] as bool? ?? false;
    final message =
        'Issuer ${entityId.split(':').last} is ${verified ? '' : 'not '}authorized for $action:$resource in the ${authorityId.split(':').last}.';

    onProgress({
      'messageType': verified ? 'success' : 'failure',
      'message': message,
    });

    return CheckResult(
      valid: verified,
      message: verified
          ? 'Issuer is authorized to $action $resource.'
          : 'Issuer is not authorized to $action $resource.',
    );
  }
}
