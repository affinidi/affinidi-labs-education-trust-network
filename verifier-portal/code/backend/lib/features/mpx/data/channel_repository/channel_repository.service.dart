import 'package:meeting_place_core/meeting_place_core.dart';
import '../../../../core/infrastructure/config/app_config.dart';
import 'channel_repository_impl.dart';
import '../../../../core/infrastructure/storage/storage_factory.dart';

class ChannelRepositoryService {
  static ChannelRepositoryService? _instance;
  static Future<ChannelRepositoryService>? _initializationFuture;
  late ChannelRepository _channelRepository;

  ChannelRepositoryService._();

  static Future<ChannelRepositoryService> init() async {
    if (_instance != null) return _instance!;
    if (_initializationFuture != null) return _initializationFuture!;

    _initializationFuture = _initialize();
    _instance = await _initializationFuture!;
    _initializationFuture = null;
    return _instance!;
  }

  static Future<ChannelRepositoryService> _initialize() async {
    final service = ChannelRepositoryService._();
    final channelRepoStorage = await StorageFactory.createStorage(
      "./${AppConfig.dataPath}/channels.json",
    );
    service._channelRepository = ChannelRepositoryImpl(
      storage: channelRepoStorage,
    );
    return service;
  }

  static ChannelRepositoryService get instance {
    if (_instance == null) {
      throw StateError(
        'ChannelRepositoryService not initialized. Call await ChannelRepositoryService.init() first.',
      );
    }
    return _instance!;
  }

  ChannelRepository get channelRepository => _channelRepository;
}
