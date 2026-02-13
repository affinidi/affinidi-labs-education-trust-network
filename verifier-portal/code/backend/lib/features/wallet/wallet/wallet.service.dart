import '../../../core/infrastructure/config/app_config.dart';
import '../../../core/infrastructure/storage/storage_factory.dart';
import 'package:ssi/ssi.dart';

class WalletService {
  static WalletService? _instance;
  static Future<WalletService>? _initializationFuture;
  late Wallet _wallet;

  WalletService._();

  static Future<WalletService> init() async {
    if (_instance != null) return _instance!;
    if (_initializationFuture != null) return _initializationFuture!;

    _initializationFuture = _initialize();
    _instance = await _initializationFuture!;
    _initializationFuture = null;
    return _instance!;
  }

  static Future<WalletService> _initialize() async {
    final service = WalletService._();
    final keyStore = await StorageFactory.createKeyStore(
      AppConfig.keyStorePath,
    );
    service._wallet = PersistentWallet(keyStore);
    return service;
  }

  static WalletService get instance {
    if (_instance == null) {
      throw StateError(
        'WalletService not initialized. Call await WalletService.init() first.',
      );
    }
    return _instance!;
  }

  Wallet get wallet => _wallet;
}
