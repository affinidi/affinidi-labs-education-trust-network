import 'dart:io';
import 'package:ssi/ssi.dart';

import 'storage_interface.dart';
import 'file_storage.dart';
import 'file_key_store.dart';

class StorageFactory {
  static String clientName = 'ver1';
  static Future<IStorage> createDataStorage() async {
    return createStorage("./data/db.json");
  }

  static Future<IStorage> createStorage(String fileName) async {
    final file = File(fileName);
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print('Created directory: ${dir.path}');
    }
    print('[StorageFactory] Using FileStorage at $fileName');
    return FileStorage(fileName);
  }

  static Future<KeyStore> createKeyStore(String filePath) async {
    final file = File(filePath);
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print('Created directory: ${dir.path}');
    }
    print('[StorageFactory] Using FileKeyStore at $filePath');
    return FileKeyStore(filePath: filePath);
  }
}
