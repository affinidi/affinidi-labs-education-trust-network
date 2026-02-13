import 'package:meeting_place_core/meeting_place_core.dart';
import '../../../core/infrastructure/config/app_config.dart';
import 'key_repository_impl.dart';
import '../../../core/infrastructure/storage/storage_factory.dart';

class KeyRepositoryService {
  static KeyRepositoryService? _instance;
  static Future<KeyRepositoryService>? _initializationFuture;
  late KeyRepository _keyRepository;

  KeyRepositoryService._();

  static Future<KeyRepositoryService> init() async {
    if (_instance != null) return _instance!;
    if (_initializationFuture != null) return _initializationFuture!;

    _initializationFuture = _initialize();
    _instance = await _initializationFuture!;
    _initializationFuture = null;
    return _instance!;
  }

  static Future<KeyRepositoryService> _initialize() async {
    final service = KeyRepositoryService._();
    final keyRepStorage = await StorageFactory.createStorage(
      "./${AppConfig.dataPath}/keys-storage.json",
    );
    service._keyRepository = KeyRepositoryImpl(storage: keyRepStorage);
    return service;
  }

  static KeyRepositoryService get instance {
    if (_instance == null) {
      throw StateError(
        'KeyRepositoryService not initialized. Call await KeyRepositoryService.init() first.',
      );
    }
    return _instance!;
  }

  KeyRepository get keyRepository => _keyRepository;
}
