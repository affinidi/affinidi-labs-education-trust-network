import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/repositories/user_profile_repository_impl.dart';

// Profile state notifier
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }
  final IUserProfileRepository _repository;

  Future<void> _loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _repository.saveProfile(profile);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _repository.deleteProfile();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<bool> hasProfile() async {
    try {
      return await _repository.hasProfile();
    } catch (error) {
      return false;
    }
  }

  void refresh() {
    _loadProfile();
  }
}

// Profile provider - waits for repository to be ready
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      final repository = ref.watch(userProfileRepositoryImplProvider).value;
      return UserProfileNotifier(repository!);
    });

// Convenience providers
final hasUserProfileProvider = FutureProvider<bool>((ref) async {
  return ref.watch(userProfileProvider.notifier).hasProfile();
});
