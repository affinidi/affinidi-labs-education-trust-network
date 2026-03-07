import 'package:ssi/ssi.dart';
import 'package:logger/logger.dart';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import '../../../../core/infrastructure/tr_admin/tr_admin_client.dart';
import '../../../../core/infrastructure/config/app_config.dart';
import '../../../../core/infrastructure/config/user_config.dart';
import '../../../../core/infrastructure/config/did_manager_loader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tr_admin_client.provider.g.dart';

@Riverpod(keepAlive: true)
Future<TrAdminClient> trAdminClient(ref) async {
  final logger = Logger();

  // Load user configuration from file (use AppConfig to read runtime-injected path)
  final configPath = AppConfig.userConfigPath;
  logger.i('Loading user configuration from: $configPath');
  try {
    final userConfig = await UserConfig.loadFromFile(configPath);
    logger.i('userConfig loaded: ${userConfig.profiles.keys.join(", ")}');
    // Load DID Manager from configuration
    final loader = DidManagerLoader(logger: logger);
    final loadResult = await loader.loadFromConfig(userConfig);

    logger.i('Loaded DID Manager for: ${loadResult.did}');
    logger.i('Alias: ${loadResult.alias}');
    logger.i('Keys: ${loadResult.keyIds.join(", ")}');

    // Get mediator DID document
    final mediatorDid = AppConfig.mediatorDid;
    final mediatorDidDocument =
        await UniversalDIDResolver.defaultResolver.resolveDid(mediatorDid);
    logger.i('Resolved mediator DID document for: $mediatorDid');

    // Create authorization provider for mediator authentication
    final authorizationProvider = await AffinidiAuthorizationProvider.init(
      mediatorDidDocument: mediatorDidDocument,
      didManager: loadResult.didManager,
    );
    logger.i('Created authorization provider');

    // Initialize TrAdminClient with loaded DID Manager
    return await TrAdminClient.init(
      mediatorDidDocument: mediatorDidDocument,
      didManager: loadResult.didManager,
      trustRegistryDid: AppConfig.trustRegistryDid,
      authorizationProvider: authorizationProvider,
      logger: logger,
    );
  } catch (e) {
    logger.e('Error loading user configuration: $e');
    rethrow;
  }
}
