import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../datasources/local/user_profile_table.dart';

part 'user_profile_database.g.dart';

@DriftDatabase(tables: [DriftUserProfile])
class UserProfileDatabase extends _$UserProfileDatabase {
  UserProfileDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here when schema version increases
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'certizen_student_vault.sqlite'));
    return NativeDatabase(file);
  });
}

final appDatabaseProvider = Provider<UserProfileDatabase>((ref) {
  final database = UserProfileDatabase();
  ref.onDispose(database.close);
  return database;
});
