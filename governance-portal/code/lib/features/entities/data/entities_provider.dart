import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'entities_storage.dart';
import '../domain/entities/entity.dart';

/// Provider for EntitiesStorage instance
final entitiesStorageProvider = FutureProvider<EntitiesStorage>((ref) async {
  return await EntitiesStorage.init();
});

/// Provider for the list of entities
final entitiesListProvider = StateProvider<List<Entity>>((ref) {
  final storageAsync = ref.watch(entitiesStorageProvider);
  return storageAsync.when(
    data: (storage) => storage.getEntities(),
    loading: () => [],
    error: (_, __) => [],
  );
});
