import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Application configuration loaded from environment variables
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

  // static Future<bool> loadEnvironment() async {
  //   bool envLoaded = false;

  //   for (final envFile in ['.env.ngrok']) {
  //     try {
  //       // Check if file exists first
  //       if (await File(envFile).exists()) {
  //         _dotenv.load([envFile]);
  //         print('✅ Loaded configuration from $envFile');
  //         envLoaded = true;
  //         break;
  //       }
  //     } catch (e) {
  //       // Try next file
  //       continue;
  //     }
  //   }

  //   if (!envLoaded) {
  //     print('⚠️  No .env file found, using default configuration');
  //   }

  //   return envLoaded;
  // }

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

  static String get mediatorDid =>
      const String.fromEnvironment('MEDIATOR_DID', defaultValue: '') != ''
          ? const String.fromEnvironment('MEDIATOR_DID')
          : _getEnv('MEDIATOR_DID',
              defaultValue: 'did:web:apse1.mediator.affinidi.io:.well-known');

  static String get trustRegistryDid =>
      const String.fromEnvironment('TRUST_REGISTRY_DID', defaultValue: '') != ''
          ? const String.fromEnvironment('TRUST_REGISTRY_DID')
          : _getEnv('TRUST_REGISTRY_DID');

  static String get serviceDid =>
      const String.fromEnvironment('SERVICE_DID', defaultValue: '') != ''
          ? const String.fromEnvironment('SERVICE_DID')
          : _getEnv('SERVICE_DID');

  static String get userConfigPath =>
      const String.fromEnvironment('USER_CONFIG_PATH', defaultValue: '') != ''
          ? const String.fromEnvironment('USER_CONFIG_PATH')
          : _getEnv('USER_CONFIG_PATH',
              defaultValue: 'assets/user_config.json');

  static String get instanceId =>
      const String.fromEnvironment('INSTANCE_ID', defaultValue: '') != ''
          ? const String.fromEnvironment('INSTANCE_ID')
          : _getEnv('INSTANCE_ID');

  /// Validate required configuration
  static void validate() {
    if (trustRegistryDid.isEmpty) {
      throw Exception('TRUST_REGISTRY_DID is required');
    }
  }
}
