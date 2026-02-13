import '../entities/user_profile.dart';

// Repository interface for user profile operations
abstract class IUserProfileRepository {
  /// Get the current user profile
  Future<UserProfile?> getProfile();

  /// Create or update user profile
  Future<void> saveProfile(UserProfile profile);

  /// Delete user profile
  Future<void> deleteProfile();

  /// Check if profile exists
  Future<bool> hasProfile();
}
