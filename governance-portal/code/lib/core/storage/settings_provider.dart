import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/core/storage/settings_storage.dart';
import 'package:governance_portal/core/storage/settings_constants.dart';

/// Provider for settings storage
final settingsStorageProvider = FutureProvider<SettingsStorage>((ref) async {
  return await SettingsStorage.init();
});

/// Provider for app name
final appNameProvider = StateProvider<String>((ref) {
  final storage = ref.watch(settingsStorageProvider).valueOrNull;
  return storage?.getAppName() ?? SettingsConstants.defaultAppName;
});

/// Provider for mediator DID
final mediatorDidProvider = StateProvider<String>((ref) {
  final storage = ref.watch(settingsStorageProvider).valueOrNull;
  return storage?.getMediatorDid() ?? SettingsConstants.defaultMediatorDid;
});

/// Provider for registry name (null if not created)
final registryNameProvider = StateProvider<String?>((ref) {
  final storage = ref.watch(settingsStorageProvider).valueOrNull;
  return storage?.getRegistryName();
});

/// Provider for framework ID (null if not selected)
final frameworkIdProvider = StateProvider<String?>((ref) {
  final storage = ref.watch(settingsStorageProvider).valueOrNull;
  return storage?.getFrameworkId();
});
