import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'runtime_config.dart';

/// Application configuration loaded from environment variables
/// Priority: RuntimeConfig (Docker JS injection) > dart-define > dotenv
class AppConfig {
  static bool _envLoaded = false;

  /// Load environment variables from .env file
  /// Returns true if file was loaded successfully
  static Future<bool> loadEnvironment() async {
    const envFileName =
        String.fromEnvironment('ENV_FILE', defaultValue: '.env');

    print('🔧 [AppConfig] Attempting to load $envFileName...');
    try {
      await dotenv.load(fileName: envFileName);
      print('✅ [AppConfig] Loaded configuration from $envFileName');
      _envLoaded = true;
      return true;
    } catch (e) {
      print(
          '⚠️  [AppConfig] $envFileName file not found, using default configuration: $e');
      _envLoaded = false;
      return false;
    }
  }

  /// Safely get value from dotenv, returning empty string if dotenv not initialized
  static String _getEnv(String key, {String defaultValue = ''}) {
    if (!_envLoaded) {
      return defaultValue;
    }
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      // dotenv not initialized
      return defaultValue;
    }
  }

  /// Resolve a config value: runtime JS > compile-time dart-define > dotenv > default
  static String _resolve(String key, String compileTime,
      {String defaultValue = ''}) {
    final runtime = RuntimeConfig.get(key);
    if (runtime != null && runtime.isNotEmpty) return runtime;
    if (compileTime.isNotEmpty) return compileTime;
    return _getEnv(key, defaultValue: defaultValue);
  }

  static String get mediatorDid => _resolve(
        'MEDIATOR_DID',
        const String.fromEnvironment('MEDIATOR_DID', defaultValue: ''),
        defaultValue: 'did:web:apse1.mediator.affinidi.io:.well-known',
      );

  static String get trustRegistryDid => _resolve(
        'TRUST_REGISTRY_DID',
        const String.fromEnvironment('TRUST_REGISTRY_DID', defaultValue: ''),
      );

  static String get serviceDid => _resolve(
        'SERVICE_DID',
        const String.fromEnvironment('SERVICE_DID', defaultValue: ''),
      );

  static String get userConfigPath => _resolve(
        'USER_CONFIG_PATH',
        const String.fromEnvironment('USER_CONFIG_PATH', defaultValue: ''),
        defaultValue: 'assets/user_config.json',
      );

  static String get instanceId => _resolve(
        'INSTANCE_ID',
        const String.fromEnvironment('INSTANCE_ID', defaultValue: ''),
      );

  /// Validate required configuration
  static void validate() {
    if (trustRegistryDid.isEmpty) {
      throw Exception('TRUST_REGISTRY_DID is required');
    }
  }
}
