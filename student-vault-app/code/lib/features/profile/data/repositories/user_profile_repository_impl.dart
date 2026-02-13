import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../database/user_profile_database.dart';

part 'user_profile_repository_impl.g.dart';

/// Provides a [UserProfileRepositoryImpl] instance backed by Drift database.
@Riverpod(keepAlive: true)
Future<UserProfileRepositoryImpl> userProfileRepositoryImpl(Ref ref) async {
  final database = ref.read(appDatabaseProvider);
  return UserProfileRepositoryImpl(database: database);
}

/// Drift implementation of [IUserProfileRepository].
///
/// Manages user profile data persistence using a Drift database.
/// Provides methods to create, read, update, and delete user profile records.
class UserProfileRepositoryImpl implements IUserProfileRepository {
  UserProfileRepositoryImpl({required UserProfileDatabase database})
    : _database = database;

  final UserProfileDatabase _database;

  /// Retrieves the user profile from the database.
  ///
  /// Returns `null` if no profile exists.
  @override
  Future<UserProfile?> getProfile() async {
    final result = await _database
        .select(_database.driftUserProfile)
        .getSingleOrNull();

    if (result == null) return null;

    return _UserProfileMapper.fromDatabaseRecord(result);
  }

  /// Saves or updates the user profile in the database.
  ///
  /// If a profile already exists, it will be replaced.
  /// Uses [InsertMode.insertOrReplace] to handle both create and update operations.
  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _database
        .into(_database.driftUserProfile)
        .insert(
          DriftUserProfileCompanion.insert(
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            profilePicPath: Value(profile.profilePicPath),
            currentCompany: Value(profile.currentCompany),
            currentJobTitle: Value(profile.currentJobTitle),
            totalExperienceMonths: Value(profile.totalExperienceMonths),
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Deletes the user profile from the database.
  ///
  /// Removes all profile records. Since the table should only contain
  /// one profile record, this effectively clears the user's profile data.
  @override
  Future<void> deleteProfile() async {
    await _database.delete(_database.driftUserProfile).go();
  }

  /// Checks if a user profile exists in the database.
  ///
  /// Returns `true` if at least one profile record exists, `false` otherwise.
  @override
  Future<bool> hasProfile() async {
    final result = await _database
        .select(_database.driftUserProfile)
        .getSingleOrNull();
    return result != null;
  }
}

/// Maps Drift database records to [UserProfile] domain objects.
class _UserProfileMapper {
  static UserProfile fromDatabaseRecord(DriftUserProfileData record) {
    return UserProfile(
      id: record.id,
      firstName: record.firstName,
      lastName: record.lastName,
      profilePicPath: record.profilePicPath,
      currentCompany: record.currentCompany,
      currentJobTitle: record.currentJobTitle,
      totalExperienceMonths: record.totalExperienceMonths,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }
}
