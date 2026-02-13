import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/features/authorities/data/authorities_storage.dart';
import '../domain/entities/authority.dart';

/// Provider for authorities storage
final authoritiesStorageProvider =
    FutureProvider<AuthoritiesStorage>((ref) async {
  print('🟣 [authoritiesStorageProvider] Initializing storage...');
  final storage = await AuthoritiesStorage.init();
  print('🟣 [authoritiesStorageProvider] Storage initialized');
  return storage;
});

/// Provider for authorities list
final authoritiesListProvider = StateProvider<List<Authority>>((ref) {
  print('🟣 [authoritiesListProvider] Getting authorities list');
  final storageAsync = ref.watch(authoritiesStorageProvider);
  final result = storageAsync.when<List<Authority>>(
    data: (storage) {
      final authorities = storage.getAuthorities();
      print(
          '🟣 [authoritiesListProvider] Loaded ${authorities.length} authorities');
      return authorities;
    },
    loading: () {
      print('🟣 [authoritiesListProvider] Storage loading...');
      return <Authority>[];
    },
    error: (err, stack) {
      print('🔴 [authoritiesListProvider] Error: $err');
      return <Authority>[];
    },
  );
  return result;
});
