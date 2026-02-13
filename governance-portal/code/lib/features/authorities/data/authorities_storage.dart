import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/authority.dart';
import '../../../core/infrastructure/config/app_config.dart';

/// Storage for authorities data using SharedPreferences
class AuthoritiesStorage {
  static const String _baseKeyAuthorities = 'authorities';

  final SharedPreferences _prefs;
  late final String _keyAuthorities;

  AuthoritiesStorage._(this._prefs) {
    // Get instance ID from environment and prefix the storage key
    final instanceId = AppConfig.instanceId;
    _keyAuthorities = instanceId.isNotEmpty
        ? '${instanceId}_$_baseKeyAuthorities'
        : _baseKeyAuthorities;
    print(
        '🔧 [AuthoritiesStorage] Initialized with key: $_keyAuthorities (instanceId: $instanceId)');
  }

  /// Initialize authorities storage
  static Future<AuthoritiesStorage> init() async {
    print('🔧 [AuthoritiesStorage] Initializing storage...');
    final prefs = await SharedPreferences.getInstance();
    final storage = AuthoritiesStorage._(prefs);
    print('🔧 [AuthoritiesStorage] Storage initialized');
    return storage;
  }

  /// Get all authorities
  List<Authority> getAuthorities() {
    print(
        '🔧 [AuthoritiesStorage] Getting authorities from key: $_keyAuthorities');
    final jsonString = _prefs.getString(_keyAuthorities);
    print('🔧 [AuthoritiesStorage] Raw JSON string: ${jsonString ?? "(null)"}');

    if (jsonString == null) {
      print(
          '🔧 [AuthoritiesStorage] No authorities found, returning empty list');
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final authorities = decoded
          .map((json) => Authority.fromJson(json as Map<String, dynamic>))
          .toList();
      print('🔧 [AuthoritiesStorage] Found ${authorities.length} authorities');
      return authorities;
    } catch (e) {
      print('🔴 [AuthoritiesStorage] Error decoding authorities: $e');
      return [];
    }
  }

  /// Add a new authority
  Future<bool> addAuthority(Authority authority) async {
    print(
        '🔧 [AuthoritiesStorage] Adding authority: ${authority.name} (${authority.did})');
    final authorities = getAuthorities();
    print(
        '🔧 [AuthoritiesStorage] Current authorities count: ${authorities.length}');

    // Add timestamp if not present
    final authorityWithMeta = authority.copyWith(
      id: authority.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : authority.id,
      createdAt: authority.createdAt,
    );

    print('🔧 [AuthoritiesStorage] Authority with meta: $authorityWithMeta');
    authorities.add(authorityWithMeta);
    print(
        '🔧 [AuthoritiesStorage] New authorities count: ${authorities.length}');

    final result = await _saveAuthorities(authorities);
    print('🔧 [AuthoritiesStorage] Save result: $result');
    return result;
  }

  /// Update an existing authority
  Future<bool> updateAuthority(String id, Authority authority) async {
    final authorities = getAuthorities();
    final index = authorities.indexWhere((a) => a.id == id);

    if (index == -1) return false;

    authorities[index] = authority.copyWith(
      id: id,
      updatedAt: DateTime.now(),
    );

    return _saveAuthorities(authorities);
  }

  /// Delete an authority
  Future<bool> deleteAuthority(String id) async {
    final authorities = getAuthorities();
    authorities.removeWhere((a) => a.id == id);
    return _saveAuthorities(authorities);
  }

  /// Clear all authorities
  Future<bool> clearAuthorities() => _prefs.remove(_keyAuthorities);

  /// Save authorities list to storage
  Future<bool> _saveAuthorities(List<Authority> authorities) {
    print(
        '🔧 [AuthoritiesStorage] Saving ${authorities.length} authorities to key: $_keyAuthorities');
    final jsonString = jsonEncode(authorities.map((a) => a.toJson()).toList());
    print('🔧 [AuthoritiesStorage] JSON to save: $jsonString');
    final result = _prefs.setString(_keyAuthorities, jsonString);
    print('🔧 [AuthoritiesStorage] Save completed: $result');
    return result;
  }
}
