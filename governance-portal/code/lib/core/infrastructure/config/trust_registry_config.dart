/// Trust Registry configuration from environment variables
class TrustRegistryConfig {
  /// Ministry name (HK, Macau, SG)
  static String get ministryName =>
      const String.fromEnvironment('MINISTRY_NAME', defaultValue: 'HK');

  /// Admin DID for this ministry instance
  static String get adminDid => const String.fromEnvironment(
        'ADMIN_DID',
        defaultValue: '',
      );

  /// Trust Registry DID (cloud-hosted)
  static String get trustRegistryDid => const String.fromEnvironment(
        'TRUST_REGISTRY_DID',
        defaultValue: '',
      );

  /// Mediator DID for DIDComm routing
  static String get mediatorDid => const String.fromEnvironment(
        'MEDIATOR_DID',
        defaultValue: '',
      );

  /// Mediator URL endpoint
  static String get mediatorUrl => const String.fromEnvironment(
        'MEDIATOR_URL',
        defaultValue: '',
      );

  /// Key store path for persistent storage
  static String get keyStorePath => String.fromEnvironment(
        'KEY_STORE_PATH',
        defaultValue:
            './data/${String.fromEnvironment('MINISTRY_NAME', defaultValue: 'HK').toLowerCase()}-ministry/key-store.json',
      );

  /// Data directory path
  static String get dataPath => String.fromEnvironment(
        'DATA_PATH',
        defaultValue:
            './data/${String.fromEnvironment('MINISTRY_NAME', defaultValue: 'HK').toLowerCase()}-ministry',
      );

  /// Response timeout in seconds
  static int get responseTimeoutSeconds => const int.fromEnvironment(
        'RESPONSE_TIMEOUT_SECONDS',
        defaultValue: 30,
      );

  /// Validate configuration
  static void validate() {
    if (adminDid.isEmpty) {
      throw Exception('ADMIN_DID environment variable is required');
    }
    if (trustRegistryDid.isEmpty) {
      throw Exception('TRUST_REGISTRY_DID environment variable is required');
    }
    if (mediatorDid.isEmpty) {
      throw Exception('MEDIATOR_DID environment variable is required');
    }
    if (mediatorUrl.isEmpty) {
      throw Exception('MEDIATOR_URL environment variable is required');
    }
  }

  /// Get full configuration map
  static Map<String, String> toMap() {
    return {
      'ministryName': ministryName,
      'adminDid': adminDid,
      'trustRegistryDid': trustRegistryDid,
      'mediatorDid': mediatorDid,
      'mediatorUrl': mediatorUrl,
      'keyStorePath': keyStorePath,
      'dataPath': dataPath,
      'responseTimeoutSeconds': responseTimeoutSeconds.toString(),
    };
  }
}
