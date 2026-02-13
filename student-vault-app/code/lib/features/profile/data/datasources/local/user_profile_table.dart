import 'package:drift/drift.dart';

// User profile table definition
class DriftUserProfile extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get profilePicPath => text().nullable()();
  TextColumn get currentCompany => text().nullable()();
  TextColumn get currentJobTitle => text().nullable()();
  IntColumn get totalExperienceMonths => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
