import 'dart:js' as js;

/// Reads runtime configuration injected via window.__runtimeConfig in index.html.
/// This allows a single Flutter web build to be used with different configs
/// by having the Docker entrypoint generate runtime-config.js per instance.
class RuntimeConfig {
  static final Map<String, String> _cache = {};
  static bool _loaded = false;

  static void _load() {
    if (_loaded) return;
    _loaded = true;
    try {
      final config = js.context['__runtimeConfig'];
      if (config == null || config is! js.JsObject) return;

      final jsKeys = (js.context['Object'] as js.JsFunction)
          .callMethod('keys', [config]) as js.JsArray;

      for (final key in jsKeys) {
        final keyStr = key.toString();
        final value = config[keyStr];
        if (value != null && value is String && value.isNotEmpty) {
          _cache[keyStr] = value;
        }
      }
      print(
          '[RuntimeConfig] Loaded ${_cache.length} values: ${_cache.keys.join(', ')}');
    } catch (e) {
      print('[RuntimeConfig] Failed to load: $e');
    }
  }

  /// Get a runtime config value, or null if not set.
  static String? get(String key) {
    _load();
    return _cache[key];
  }

  /// Get a runtime config value with a fallback.
  static String getOr(String key, String fallback) {
    return get(key) ?? fallback;
  }
}
