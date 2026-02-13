class VerificationResponse {
  final bool completed;
  final String status;
  final String message;
  final bool? presentationAndCredentialsAreValid;
  final List<VerifiableCredentialWithTrustRegistry>? verifiableCredentials;

  VerificationResponse({
    required this.completed,
    required this.status,
    required this.message,
    this.presentationAndCredentialsAreValid,
    this.verifiableCredentials,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      completed: json['completed'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      presentationAndCredentialsAreValid:
          json['presentationAndCredentialsAreValid'] as bool?,
      verifiableCredentials: json['verifiableCredentials'] != null
          ? (json['verifiableCredentials'] as List)
                .map(
                  (vc) => VerifiableCredentialWithTrustRegistry.fromJson(
                    vc as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }
}

class VerifiableCredentialWithTrustRegistry {
  final Map<String, dynamic> vc;
  final TrustRegistryResult trustRegistryResult;

  VerifiableCredentialWithTrustRegistry({
    required this.vc,
    required this.trustRegistryResult,
  });

  factory VerifiableCredentialWithTrustRegistry.fromJson(
    Map<String, dynamic> json,
  ) {
    return VerifiableCredentialWithTrustRegistry(
      vc: json['vc'] as Map<String, dynamic>? ?? {},
      trustRegistryResult: TrustRegistryResult.fromJson(
        json['trustRegistryResult'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class TrustRegistryResult {
  final CheckResult governanceRecognitionCheck;
  final CheckResult issuerAuthorizationCheck;

  TrustRegistryResult({
    required this.governanceRecognitionCheck,
    required this.issuerAuthorizationCheck,
  });

  factory TrustRegistryResult.fromJson(Map<String, dynamic> json) {
    return TrustRegistryResult(
      governanceRecognitionCheck: CheckResult.fromJson(
        json['governanceRecognitionCheck'] as Map<String, dynamic>? ?? {},
      ),
      issuerAuthorizationCheck: CheckResult.fromJson(
        json['issuerAuthorizationCheck'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class CheckResult {
  final bool valid;
  final String message;

  CheckResult({required this.valid, required this.message});

  factory CheckResult.fromJson(Map<String, dynamic> json) {
    return CheckResult(
      valid: json['valid'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}
