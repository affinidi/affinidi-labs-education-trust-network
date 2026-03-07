import 'dart:js' as js;
import 'dart:js_util' as js_util;

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
      final config = js_util.getProperty(js_util.globalThis, '__runtimeConfig');
      if (config == null) return;
      final keys = js_util
          .callMethod<List<dynamic>>(js.context['Object']!, 'keys', [config]);
      for (final key in keys) {
        final value = js_util.getProperty(config, key);
        if (value != null && value is String && value.isNotEmpty) {
          _cache[key.toString()] = value;
        }
      }
    } catch (_) {
      // No runtime config available (local dev without Docker)
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
