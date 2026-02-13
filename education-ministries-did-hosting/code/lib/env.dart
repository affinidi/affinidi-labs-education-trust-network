import 'dart:io';

class Env {
  static final Map<String, String> _env = {};

  static void load({String filename = '.env'}) {
    try {
      final file = File(filename);
      if (!file.existsSync()) {
        print(
            'Warning: $filename not found. Using environment variables only.');
        return;
      }

      final lines = file.readAsLinesSync();
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          _env[key] = value;
        }
      }
      print('Loaded ${_env.length} environment variables from $filename');
    } catch (e) {
      print('Error loading $filename: $e');
    }
  }

  static String get(String key, [String defaultValue = '']) {
    return _env[key] ?? Platform.environment[key] ?? defaultValue;
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    final value = get(key).toLowerCase();
    if (value == 'true' || value == '1') return true;
    if (value == 'false' || value == '0') return false;
    return defaultValue;
  }

  static int getInt(String key, [int defaultValue = 0]) {
    final value = get(key);
    return int.tryParse(value) ?? defaultValue;
  }
}
