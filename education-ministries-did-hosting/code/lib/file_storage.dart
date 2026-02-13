import 'dart:io';
import 'dart:convert';
import 'storage_interface.dart';
import 'env.dart';

/// Simple file-based JSON storage
class FileStorage implements IStorage {
  final String _dataPath;
  final File _file;
  Map<String, dynamic> _data = {};

  FileStorage._(this._dataPath, this._file);

  static Future<FileStorage> create() async {
    final dataPath = Env.get('DATA_PATH', './data');
    final dir = Directory(dataPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final file = File('$dataPath/db.json');
    final storage = FileStorage._(dataPath, file);
    await storage._load();
    return storage;
  }

  Future<void> _load() async {
    if (_file.existsSync()) {
      try {
        final contents = await _file.readAsString();
        _data = json.decode(contents) as Map<String, dynamic>;
        print('[FileStorage] Loaded ${_data.length} keys from ${_file.path}');
      } catch (e) {
        print('[FileStorage] Error loading data: $e');
        _data = {};
      }
    } else {
      print('[FileStorage] No existing data file at ${_file.path}');
      _data = {};
    }
  }

  Future<void> _save() async {
    try {
      await _file.writeAsString(json.encode(_data));
    } catch (e) {
      print('[FileStorage] Error saving data: $e');
    }
  }

  @override
  Future<dynamic> get(String key) async {
    return _data[key];
  }

  @override
  Future<void> put(String key, dynamic value) async {
    _data[key] = value;
    await _save();
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
    await _save();
  }

  @override
  Future<bool> exists(String key) async {
    return _data.containsKey(key);
  }
}
