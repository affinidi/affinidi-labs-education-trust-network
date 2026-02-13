import 'package:meeting_place_core/meeting_place_core.dart';
import '../../../../core/infrastructure/config/app_config.dart';
import '../channel_repository/channel_repository.service.dart';
import '../../../wallet/key_repository/key_repository.service.dart';
import '../../../wallet/wallet/wallet.service.dart';
import '../../../../core/infrastructure/repository/connection_offer_repository_impl.dart';
import '../../../../core/infrastructure/storage/storage_factory.dart';

class MpxSdkService {
  static MpxSdkService? _instance;
  static Future<MpxSdkService>? _initializationFuture;
  late MeetingPlaceCoreSDK _mpxSdk;

  MpxSdkService._();

  static Future<MpxSdkService> init() async {
    if (_instance != null) return _instance!;
    if (_initializationFuture != null) return _initializationFuture!;

    _initializationFuture = _initialize();
    _instance = await _initializationFuture!;
    _initializationFuture = null;
    return _instance!;
  }

  static Future<MpxSdkService> _initialize() async {
    final service = MpxSdkService._();
    final _dirPath = AppConfig.dataPath;

    final connectionRepoStorage = await StorageFactory.createStorage(
      "./$_dirPath/connections.json",
    );

    final serviceDid = AppConfig.serviceDid;
    final mediatorDid = AppConfig.mediatorDid;

    final repositoryConfig = RepositoryConfig(
      connectionOfferRepository: ConnectionOfferRepositoryImpl(
        storage: connectionRepoStorage,
      ),
      channelRepository: ChannelRepositoryService.instance.channelRepository,
      keyRepository: KeyRepositoryService.instance.keyRepository,
    );

    service._mpxSdk = await MeetingPlaceCoreSDK.create(
      wallet: WalletService.instance.wallet,
      repositoryConfig: repositoryConfig,
      controlPlaneDid: serviceDid,
      mediatorDid: mediatorDid,
    );

    return service;
  }

  static MpxSdkService get instance {
    if (_instance == null) {
      throw StateError(
        'MpxSdkService not initialized. Call await MpxSdkService.init() first.',
      );
    }
    return _instance!;
  }

  MeetingPlaceCoreSDK get mpxSdk => _mpxSdk;
}
