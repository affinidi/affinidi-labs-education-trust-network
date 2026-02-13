import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'Nova Corp Careers';
  static const String companyName = 'Nova Corporation';

  /// Load environment variables from .env files
  /// Tries loading in order: .env.ngrok, .env.local-network, .env
  /// Returns true if any file was loaded successfully
  static Future<bool> loadEnvironment() async {
    bool envLoaded = false;

    for (final envFile in ['.env.ngrok', '.env.local-network', '.env']) {
      try {
        await dotenv.load(fileName: envFile);
        debugPrint('✅ Loaded configuration from $envFile');
        envLoaded = true;
        break;
      } catch (e) {
        // Try next file
        continue;
      }
    }

    if (!envLoaded) {
      debugPrint('⚠️  No .env file found, using default configuration');
    }

    return envLoaded;
  }

  // Helper to get env value from either dart-define or dotenv
  static String _getEnv(String key, String defaultValue) {
    // Try dotenv first (loaded from .env or --dart-define-from-file)
    final dotenvValue = dotenv.env[key];
    if (dotenvValue != null && dotenvValue.isNotEmpty) {
      return dotenvValue;
    }
    return defaultValue;
  }

  // Environment variables

  // Verifier DID configuration
  static String get verifierDid =>
      _getEnv('VERIFIER_DID', 'did:web:example.com:nova-corp');

  static String get verifierDomain =>
      _getEnv('VERIFIER_DOMAIN', 'example.com/nova-corp');

  static bool get useSsl => _getEnv('USE_SSL', 'false').toLowerCase() == 'true';

  static String get port => _getEnv('PORT', '4000');

  // Backend API configuration
  static String get backendApi =>
      _getEnv('BACKEND_API', 'http://localhost:4001/');

  // Debug mode
  static bool get isDebugMode => kDebugMode;
}
