import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/entity.dart';
import '../../../core/infrastructure/config/app_config.dart';

class EntitiesStorage {
  static const String _baseKeyEntities = 'entities';

  final SharedPreferences _prefs;
  late final String _keyEntities;

  EntitiesStorage._(this._prefs) {
    // Get instance ID from environment and prefix the storage key
    final instanceId = AppConfig.instanceId;
    _keyEntities = instanceId.isNotEmpty
        ? '${instanceId}_$_baseKeyEntities'
        : _baseKeyEntities;
  }

  /// Initialize entities storage
  static Future<EntitiesStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return EntitiesStorage._(prefs);
  }

  /// Get list of all entities
  List<Entity> getEntities() {
    final String? jsonString = _prefs.getString(_keyEntities);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((json) => Entity.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new entity
  Future<void> addEntity(Entity entity) async {
    final entities = getEntities();

    // Add ID and timestamp if not present
    final newEntity = entity.copyWith(
      id: entity.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : entity.id,
      createdAt: entity.createdAt,
    );

    entities.add(newEntity);
    await _prefs.setString(
        _keyEntities, jsonEncode(entities.map((e) => e.toJson()).toList()));
  }

  /// Update an existing entity
  Future<void> updateEntity(String id, Entity updatedEntity) async {
    final entities = getEntities();
    final index = entities.indexWhere((e) => e.id == id);

    if (index != -1) {
      entities[index] = updatedEntity.copyWith(
        id: id,
        updatedAt: DateTime.now(),
      );
      await _prefs.setString(
          _keyEntities, jsonEncode(entities.map((e) => e.toJson()).toList()));
    }
  }

  /// Delete an entity
  Future<void> deleteEntity(String id) async {
    final entities = getEntities();
    entities.removeWhere((e) => e.id == id);
    await _prefs.setString(
        _keyEntities, jsonEncode(entities.map((e) => e.toJson()).toList()));
  }

  /// Clear all entities
  Future<void> clearEntities() async {
    await _prefs.remove(_keyEntities);
  }
}
