import 'runtime_config.dart';

/// Trust Registry configuration from environment variables
/// Priority: RuntimeConfig (Docker JS injection) > dart-define > default
class TrustRegistryConfig {
  /// Resolve: runtime JS > compile-time dart-define > default
  static String _resolve(String key, String compileTime,
      {String defaultValue = ''}) {
    final runtime = RuntimeConfig.get(key);
    if (runtime != null && runtime.isNotEmpty) return runtime;
    if (compileTime.isNotEmpty) return compileTime;
    return defaultValue;
  }

  /// Ministry name (HK, Macau, SG)
  static String get ministryName => _resolve(
        'MINISTRY_NAME',
        const String.fromEnvironment('MINISTRY_NAME', defaultValue: ''),
        defaultValue: 'HK',
      );

  /// Admin DID for this ministry instance
  static String get adminDid => _resolve(
        'ADMIN_DID',
        const String.fromEnvironment('ADMIN_DID', defaultValue: ''),
      );

  /// Trust Registry DID (cloud-hosted)
  static String get trustRegistryDid => _resolve(
        'TRUST_REGISTRY_DID',
        const String.fromEnvironment('TRUST_REGISTRY_DID', defaultValue: ''),
      );

  /// Mediator DID for DIDComm routing
  static String get mediatorDid => _resolve(
        'MEDIATOR_DID',
        const String.fromEnvironment('MEDIATOR_DID', defaultValue: ''),
      );

  /// Mediator URL endpoint
  static String get mediatorUrl => _resolve(
        'MEDIATOR_URL',
        const String.fromEnvironment('MEDIATOR_URL', defaultValue: ''),
      );

  /// Trust Registry URL
  static String get trustRegistryUrl => _resolve(
        'TRUST_REGISTRY_URL',
        const String.fromEnvironment('TRUST_REGISTRY_URL', defaultValue: ''),
      );

  /// Key store path for persistent storage
  static String get keyStorePath {
    final runtime = RuntimeConfig.get('KEY_STORE_PATH');
    if (runtime != null && runtime.isNotEmpty) return runtime;
    return String.fromEnvironment(
      'KEY_STORE_PATH',
      defaultValue:
          './data/${ministryName.toLowerCase()}-ministry/key-store.json',
    );
  }

  /// Data directory path
  static String get dataPath {
    final runtime = RuntimeConfig.get('DATA_PATH');
    if (runtime != null && runtime.isNotEmpty) return runtime;
    return String.fromEnvironment(
      'DATA_PATH',
      defaultValue: './data/${ministryName.toLowerCase()}-ministry',
    );
  }

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
      'trustRegistryUrl': trustRegistryUrl,
      'keyStorePath': keyStorePath,
      'dataPath': dataPath,
      'responseTimeoutSeconds': responseTimeoutSeconds.toString(),
    };
  }
}
