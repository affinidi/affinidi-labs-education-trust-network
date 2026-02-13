// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_database.dart';

// ignore_for_file: type=lint
class $DriftUserProfileTable extends DriftUserProfile
    with TableInfo<$DriftUserProfileTable, DriftUserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftUserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profilePicPathMeta = const VerificationMeta(
    'profilePicPath',
  );
  @override
  late final GeneratedColumn<String> profilePicPath = GeneratedColumn<String>(
    'profile_pic_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentCompanyMeta = const VerificationMeta(
    'currentCompany',
  );
  @override
  late final GeneratedColumn<String> currentCompany = GeneratedColumn<String>(
    'current_company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentJobTitleMeta = const VerificationMeta(
    'currentJobTitle',
  );
  @override
  late final GeneratedColumn<String> currentJobTitle = GeneratedColumn<String>(
    'current_job_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalExperienceMonthsMeta =
      const VerificationMeta('totalExperienceMonths');
  @override
  late final GeneratedColumn<int> totalExperienceMonths = GeneratedColumn<int>(
    'total_experience_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    profilePicPath,
    currentCompany,
    currentJobTitle,
    totalExperienceMonths,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftUserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('profile_pic_path')) {
      context.handle(
        _profilePicPathMeta,
        profilePicPath.isAcceptableOrUnknown(
          data['profile_pic_path']!,
          _profilePicPathMeta,
        ),
      );
    }
    if (data.containsKey('current_company')) {
      context.handle(
        _currentCompanyMeta,
        currentCompany.isAcceptableOrUnknown(
          data['current_company']!,
          _currentCompanyMeta,
        ),
      );
    }
    if (data.containsKey('current_job_title')) {
      context.handle(
        _currentJobTitleMeta,
        currentJobTitle.isAcceptableOrUnknown(
          data['current_job_title']!,
          _currentJobTitleMeta,
        ),
      );
    }
    if (data.containsKey('total_experience_months')) {
      context.handle(
        _totalExperienceMonthsMeta,
        totalExperienceMonths.isAcceptableOrUnknown(
          data['total_experience_months']!,
          _totalExperienceMonthsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftUserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftUserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      profilePicPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_pic_path'],
      ),
      currentCompany: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_company'],
      ),
      currentJobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_job_title'],
      ),
      totalExperienceMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_experience_months'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriftUserProfileTable createAlias(String alias) {
    return $DriftUserProfileTable(attachedDatabase, alias);
  }
}

class DriftUserProfileData extends DataClass
    implements Insertable<DriftUserProfileData> {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicPath;
  final String? currentCompany;
  final String? currentJobTitle;
  final int? totalExperienceMonths;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DriftUserProfileData({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicPath,
    this.currentCompany,
    this.currentJobTitle,
    this.totalExperienceMonths,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || profilePicPath != null) {
      map['profile_pic_path'] = Variable<String>(profilePicPath);
    }
    if (!nullToAbsent || currentCompany != null) {
      map['current_company'] = Variable<String>(currentCompany);
    }
    if (!nullToAbsent || currentJobTitle != null) {
      map['current_job_title'] = Variable<String>(currentJobTitle);
    }
    if (!nullToAbsent || totalExperienceMonths != null) {
      map['total_experience_months'] = Variable<int>(totalExperienceMonths);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriftUserProfileCompanion toCompanion(bool nullToAbsent) {
    return DriftUserProfileCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      profilePicPath: profilePicPath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicPath),
      currentCompany: currentCompany == null && nullToAbsent
          ? const Value.absent()
          : Value(currentCompany),
      currentJobTitle: currentJobTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(currentJobTitle),
      totalExperienceMonths: totalExperienceMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(totalExperienceMonths),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriftUserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftUserProfileData(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      profilePicPath: serializer.fromJson<String?>(json['profilePicPath']),
      currentCompany: serializer.fromJson<String?>(json['currentCompany']),
      currentJobTitle: serializer.fromJson<String?>(json['currentJobTitle']),
      totalExperienceMonths: serializer.fromJson<int?>(
        json['totalExperienceMonths'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'profilePicPath': serializer.toJson<String?>(profilePicPath),
      'currentCompany': serializer.toJson<String?>(currentCompany),
      'currentJobTitle': serializer.toJson<String?>(currentJobTitle),
      'totalExperienceMonths': serializer.toJson<int?>(totalExperienceMonths),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriftUserProfileData copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Value<String?> profilePicPath = const Value.absent(),
    Value<String?> currentCompany = const Value.absent(),
    Value<String?> currentJobTitle = const Value.absent(),
    Value<int?> totalExperienceMonths = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DriftUserProfileData(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profilePicPath: profilePicPath.present
        ? profilePicPath.value
        : this.profilePicPath,
    currentCompany: currentCompany.present
        ? currentCompany.value
        : this.currentCompany,
    currentJobTitle: currentJobTitle.present
        ? currentJobTitle.value
        : this.currentJobTitle,
    totalExperienceMonths: totalExperienceMonths.present
        ? totalExperienceMonths.value
        : this.totalExperienceMonths,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriftUserProfileData copyWithCompanion(DriftUserProfileCompanion data) {
    return DriftUserProfileData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      profilePicPath: data.profilePicPath.present
          ? data.profilePicPath.value
          : this.profilePicPath,
      currentCompany: data.currentCompany.present
          ? data.currentCompany.value
          : this.currentCompany,
      currentJobTitle: data.currentJobTitle.present
          ? data.currentJobTitle.value
          : this.currentJobTitle,
      totalExperienceMonths: data.totalExperienceMonths.present
          ? data.totalExperienceMonths.value
          : this.totalExperienceMonths,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftUserProfileData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('profilePicPath: $profilePicPath, ')
          ..write('currentCompany: $currentCompany, ')
          ..write('currentJobTitle: $currentJobTitle, ')
          ..write('totalExperienceMonths: $totalExperienceMonths, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    profilePicPath,
    currentCompany,
    currentJobTitle,
    totalExperienceMonths,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftUserProfileData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.profilePicPath == this.profilePicPath &&
          other.currentCompany == this.currentCompany &&
          other.currentJobTitle == this.currentJobTitle &&
          other.totalExperienceMonths == this.totalExperienceMonths &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DriftUserProfileCompanion extends UpdateCompanion<DriftUserProfileData> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> profilePicPath;
  final Value<String?> currentCompany;
  final Value<String?> currentJobTitle;
  final Value<int?> totalExperienceMonths;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriftUserProfileCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.profilePicPath = const Value.absent(),
    this.currentCompany = const Value.absent(),
    this.currentJobTitle = const Value.absent(),
    this.totalExperienceMonths = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriftUserProfileCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.profilePicPath = const Value.absent(),
    this.currentCompany = const Value.absent(),
    this.currentJobTitle = const Value.absent(),
    this.totalExperienceMonths = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DriftUserProfileData> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? profilePicPath,
    Expression<String>? currentCompany,
    Expression<String>? currentJobTitle,
    Expression<int>? totalExperienceMonths,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (profilePicPath != null) 'profile_pic_path': profilePicPath,
      if (currentCompany != null) 'current_company': currentCompany,
      if (currentJobTitle != null) 'current_job_title': currentJobTitle,
      if (totalExperienceMonths != null)
        'total_experience_months': totalExperienceMonths,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriftUserProfileCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? profilePicPath,
    Value<String?>? currentCompany,
    Value<String?>? currentJobTitle,
    Value<int?>? totalExperienceMonths,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DriftUserProfileCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicPath: profilePicPath ?? this.profilePicPath,
      currentCompany: currentCompany ?? this.currentCompany,
      currentJobTitle: currentJobTitle ?? this.currentJobTitle,
      totalExperienceMonths:
          totalExperienceMonths ?? this.totalExperienceMonths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (profilePicPath.present) {
      map['profile_pic_path'] = Variable<String>(profilePicPath.value);
    }
    if (currentCompany.present) {
      map['current_company'] = Variable<String>(currentCompany.value);
    }
    if (currentJobTitle.present) {
      map['current_job_title'] = Variable<String>(currentJobTitle.value);
    }
    if (totalExperienceMonths.present) {
      map['total_experience_months'] = Variable<int>(
        totalExperienceMonths.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftUserProfileCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('profilePicPath: $profilePicPath, ')
          ..write('currentCompany: $currentCompany, ')
          ..write('currentJobTitle: $currentJobTitle, ')
          ..write('totalExperienceMonths: $totalExperienceMonths, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserProfileDatabase extends GeneratedDatabase {
  _$UserProfileDatabase(QueryExecutor e) : super(e);
  $UserProfileDatabaseManager get managers => $UserProfileDatabaseManager(this);
  late final $DriftUserProfileTable driftUserProfile = $DriftUserProfileTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftUserProfile];
}

typedef $$DriftUserProfileTableCreateCompanionBuilder =
    DriftUserProfileCompanion Function({
      required String id,
      required String firstName,
      required String lastName,
      Value<String?> profilePicPath,
      Value<String?> currentCompany,
      Value<String?> currentJobTitle,
      Value<int?> totalExperienceMonths,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DriftUserProfileTableUpdateCompanionBuilder =
    DriftUserProfileCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> profilePicPath,
      Value<String?> currentCompany,
      Value<String?> currentJobTitle,
      Value<int?> totalExperienceMonths,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DriftUserProfileTableFilterComposer
    extends Composer<_$UserProfileDatabase, $DriftUserProfileTable> {
  $$DriftUserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicPath => $composableBuilder(
    column: $table.profilePicPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentCompany => $composableBuilder(
    column: $table.currentCompany,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentJobTitle => $composableBuilder(
    column: $table.currentJobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalExperienceMonths => $composableBuilder(
    column: $table.totalExperienceMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriftUserProfileTableOrderingComposer
    extends Composer<_$UserProfileDatabase, $DriftUserProfileTable> {
  $$DriftUserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicPath => $composableBuilder(
    column: $table.profilePicPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentCompany => $composableBuilder(
    column: $table.currentCompany,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentJobTitle => $composableBuilder(
    column: $table.currentJobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalExperienceMonths => $composableBuilder(
    column: $table.totalExperienceMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftUserProfileTableAnnotationComposer
    extends Composer<_$UserProfileDatabase, $DriftUserProfileTable> {
  $$DriftUserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get profilePicPath => $composableBuilder(
    column: $table.profilePicPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentCompany => $composableBuilder(
    column: $table.currentCompany,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentJobTitle => $composableBuilder(
    column: $table.currentJobTitle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalExperienceMonths => $composableBuilder(
    column: $table.totalExperienceMonths,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriftUserProfileTableTableManager
    extends
        RootTableManager<
          _$UserProfileDatabase,
          $DriftUserProfileTable,
          DriftUserProfileData,
          $$DriftUserProfileTableFilterComposer,
          $$DriftUserProfileTableOrderingComposer,
          $$DriftUserProfileTableAnnotationComposer,
          $$DriftUserProfileTableCreateCompanionBuilder,
          $$DriftUserProfileTableUpdateCompanionBuilder,
          (
            DriftUserProfileData,
            BaseReferences<
              _$UserProfileDatabase,
              $DriftUserProfileTable,
              DriftUserProfileData
            >,
          ),
          DriftUserProfileData,
          PrefetchHooks Function()
        > {
  $$DriftUserProfileTableTableManager(
    _$UserProfileDatabase db,
    $DriftUserProfileTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftUserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftUserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftUserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> profilePicPath = const Value.absent(),
                Value<String?> currentCompany = const Value.absent(),
                Value<String?> currentJobTitle = const Value.absent(),
                Value<int?> totalExperienceMonths = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriftUserProfileCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                profilePicPath: profilePicPath,
                currentCompany: currentCompany,
                currentJobTitle: currentJobTitle,
                totalExperienceMonths: totalExperienceMonths,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                required String lastName,
                Value<String?> profilePicPath = const Value.absent(),
                Value<String?> currentCompany = const Value.absent(),
                Value<String?> currentJobTitle = const Value.absent(),
                Value<int?> totalExperienceMonths = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DriftUserProfileCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                profilePicPath: profilePicPath,
                currentCompany: currentCompany,
                currentJobTitle: currentJobTitle,
                totalExperienceMonths: totalExperienceMonths,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftUserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$UserProfileDatabase,
      $DriftUserProfileTable,
      DriftUserProfileData,
      $$DriftUserProfileTableFilterComposer,
      $$DriftUserProfileTableOrderingComposer,
      $$DriftUserProfileTableAnnotationComposer,
      $$DriftUserProfileTableCreateCompanionBuilder,
      $$DriftUserProfileTableUpdateCompanionBuilder,
      (
        DriftUserProfileData,
        BaseReferences<
          _$UserProfileDatabase,
          $DriftUserProfileTable,
          DriftUserProfileData
        >,
      ),
      DriftUserProfileData,
      PrefetchHooks Function()
    >;

class $UserProfileDatabaseManager {
  final _$UserProfileDatabase _db;
  $UserProfileDatabaseManager(this._db);
  $$DriftUserProfileTableTableManager get driftUserProfile =>
      $$DriftUserProfileTableTableManager(_db, _db.driftUserProfile);
}
