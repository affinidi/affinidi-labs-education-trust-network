import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';

/// User configuration models matching Rust structure
/// Based on trust-registry-admin-rest-api-rs/conf/user_config.json

/// Secret entry containing DID verification method key material
class SecretConfig {
  final String id;
  final String type;
  final Map<String, dynamic> privateKeyJwk;

  SecretConfig({
    required this.id,
    required this.type,
    required this.privateKeyJwk,
  });

  factory SecretConfig.fromJson(Map<String, dynamic> json) {
    return SecretConfig(
      id: json['id'] as String,
      type: json['type'] as String,
      privateKeyJwk: json['privateKeyJwk'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'privateKeyJwk': privateKeyJwk,
    };
  }
}

/// DID profile configuration with alias and secrets
class DidProfileConfig {
  final String alias;
  final List<SecretConfig> secrets;

  DidProfileConfig({
    required this.alias,
    required this.secrets,
  });

  factory DidProfileConfig.fromJson(Map<String, dynamic> json) {
    return DidProfileConfig(
      alias: json['alias'] as String,
      secrets: (json['secrets'] as List)
          .map((s) => SecretConfig.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'secrets': secrets.map((s) => s.toJson()).toList(),
    };
  }
}

/// Complete user configuration with DID profiles
class UserConfig {
  final Map<String, DidProfileConfig> profiles;

  UserConfig({required this.profiles});

  factory UserConfig.fromJson(Map<String, dynamic> json) {
    final profiles = <String, DidProfileConfig>{};

    json.forEach((key, value) {
      profiles[key] = DidProfileConfig.fromJson(value as Map<String, dynamic>);
    });

    return UserConfig(profiles: profiles);
  }

  Map<String, dynamic> toJson() {
    return profiles.map((key, value) => MapEntry(key, value.toJson()));
  }

  /// Get the first (primary) DID profile
  MapEntry<String, DidProfileConfig>? get primaryProfile {
    if (profiles.isEmpty) return null;
    return profiles.entries.first;
  }

  /// Load user configuration from file
  static Future<UserConfig> loadFromFile(String filePath) async {
    final logger = Logger();

    logger.i('Loading asset from: $filePath');

    try {
      // Use rootBundle for Flutter web compatibility
      final content = await rootBundle.loadString(filePath);
      logger.i('Asset loaded successfully');

      final json = jsonDecode(content) as Map<String, dynamic>;
      logger.i('json: ${json.toString()}');
      final config = UserConfig.fromJson(json);

      // Validate configuration
      if (config.profiles.isEmpty) {
        throw Exception(
            'User configuration must contain at least one DID profile');
      }
      logger.i(
          'config first key: ${config.profiles.keys.toList()[0].toString()}');

      return config;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load or parse user configuration: $e\n'
          'Please ensure assets/user_config.json exists and is properly formatted.');
    }
  }

  /// Get default configuration file path from environment variable
  static String getDefaultPath() {
    // Check compile-time environment variable first
    const envPath =
        String.fromEnvironment('USER_CONFIG_PATH', defaultValue: '');
    if (envPath.isNotEmpty) {
      return envPath;
    }

    // Fallback to default
    return 'assets/user_config.json';
  }
}
