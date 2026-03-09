import 'package:shared_preferences/shared_preferences.dart';
import 'package:governance_portal/core/storage/settings_constants.dart';

/// Settings storage using SharedPreferences
/// Provides persistent storage for application settings
class SettingsStorage {
  static const String _keyAppName = 'app_name';
  static const String _keyMediatorDid = 'mediator_did';
  static const String _keyRegistryName = 'registry_name';
  static const String _keyFrameworkId = 'framework_id';

  final SharedPreferences _prefs;

  SettingsStorage(this._prefs);

  /// Initialize settings storage
  static Future<SettingsStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsStorage(prefs);
  }

  /// Get app name (defaults to 'Credulon')
  String getAppName() =>
      _prefs.getString(_keyAppName) ?? SettingsConstants.defaultAppName;

  /// Set app name
  Future<bool> setAppName(String name) => _prefs.setString(_keyAppName, name);

  /// Reset app name to default
  Future<bool> resetAppName() => _prefs.remove(_keyAppName);

  /// Get mediator DID
  String getMediatorDid() =>
      _prefs.getString(_keyMediatorDid) ?? SettingsConstants.defaultMediatorDid;

  /// Set mediator DID
  Future<bool> setMediatorDid(String did) =>
      _prefs.setString(_keyMediatorDid, did);

  /// Reset mediator DID to default
  Future<bool> resetMediatorDid() => _prefs.remove(_keyMediatorDid);

  /// Get registry name (null if not set)
  String? getRegistryName() => _prefs.getString(_keyRegistryName);

  /// Set registry name
  Future<bool> setRegistryName(String name) =>
      _prefs.setString(_keyRegistryName, name);

  /// Reset registry name
  Future<bool> resetRegistryName() => _prefs.remove(_keyRegistryName);

  /// Get framework ID (null if not set)
  String? getFrameworkId() => _prefs.getString(_keyFrameworkId);

  /// Set framework ID
  Future<bool> setFrameworkId(String id) =>
      _prefs.setString(_keyFrameworkId, id);

  /// Reset framework ID
  Future<bool> resetFrameworkId() => _prefs.remove(_keyFrameworkId);

  /// Clear all stored settings and data
  Future<bool> clearAll() => _prefs.clear();
}
