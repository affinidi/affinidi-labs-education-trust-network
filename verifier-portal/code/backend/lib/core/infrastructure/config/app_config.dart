import 'dart:io';
import 'package:dotenv/dotenv.dart';

class AppConfig {
  static const String appName = 'Nova Corp Careers';
  static const String companyName = 'Nova Corporation';

  static final DotEnv _dotenv = DotEnv();

  /// Load environment variables from .env files
  /// Tries loading in order: .env.ngrok, .env.local-network, .env
  /// Returns true if any file was loaded successfully
  static Future<bool> loadEnvironment() async {
    bool envLoaded = false;

    for (final envFile in ['.env.ngrok']) {
      try {
        // Check if file exists first
        if (await File(envFile).exists()) {
          _dotenv.load([envFile]);
          print('✅ Loaded configuration from $envFile');
          envLoaded = true;
          break;
        }
      } catch (e) {
        // Try next file
        continue;
      }
    }

    if (!envLoaded) {
      print('⚠️  No .env file found, using default configuration');
    }

    return envLoaded;
  }

  // Helper to get env value from either dart-define or dotenv
  static String _getEnv(String key, String defaultValue) {
    // Try dotenv first (loaded from .env or --dart-define-from-file)
    final dotenvValue = _dotenv[key];
    if (dotenvValue != null && dotenvValue.isNotEmpty) {
      return dotenvValue;
    }
    return defaultValue;
  }

  // Environment variables
  static String get serviceDid =>
      _getEnv('SERVICE_DID', 'did:web:voice-quality.meetingplace.affinidi.io');

  static String get mediatorDid =>
      _getEnv('MEDIATOR_DID', 'did:web:apse1.mediator.affinidi.io:.well-known');

  static String get mediatorUrl =>
      _getEnv('MEDIATOR_URL', 'https://apse1.mediator.affinidi.io/.well-known');

  // Verifier DID configuration
  static String get verifierDid =>
      _getEnv('VERIFIER_DID', 'did:web:example.com:nova-corp');

  static String get verifierDomain =>
      _getEnv('VERIFIER_DOMAIN', 'example.com/nova-corp');

  static bool get useSsl => _getEnv('USE_SSL', 'false').toLowerCase() == 'true';

  static String get port => _getEnv('PORT', '4001');

  // Trust Registry URLs
  static String get hkTrustRegistryUrl =>
      _getEnv('HK_TRUST_REGISTRY_URL', 'http://localhost:3232');

  static String get macauTrustRegistryUrl =>
      _getEnv('MACAU_TRUST_REGISTRY_URL', 'http://localhost:3233');

  static String get sgTrustRegistryUrl =>
      _getEnv('SG_TRUST_REGISTRY_URL', 'http://localhost:3234');
  static String get sgEducationMinistryDID =>
      _getEnv('SG_EDUCATION_MINISTRY_DID', 'did:example:sg-education-ministry');

  // Data storage path
  static const String dataPath = 'data/verifier';
  static const String keyStorePath = '$dataPath/key-store.json';
  static const String keysStoragePath = '$dataPath/keys-storage.json';
  static const String channelsPath = '$dataPath/channels.json';
  static const String connectionsPath = '$dataPath/connections.json';
}
