import 'dart:async';
import 'dart:convert';

import 'package:vdsp_verifier_server/core/infrastructure/storage/storage_factory.dart';
import 'package:vdsp_verifier_server/core/infrastructure/storage/storage_interface.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/constants/global_vars.dart';
import 'package:vdsp_verifier_server/features/mpx/data/mpx_sdk/mpx_sdk.service.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/broadcast_message_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/create_oob_invite_use_case.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/get_contact_card_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/setup_client_use_case.dart';

import '../../domain/constants/vdsp.dart';
import '../../domain/entities/verifier_client.dart';

class VerifierClientService {
  static VerifierClientService? _instance;
  static Future<VerifierClientService>? _initializationFuture;
  late VerifierClient _client;
  Timer? _oobRefreshTimer;

  VerifierClientService._();

  static Future<VerifierClientService> init() async {
    if (_instance != null) return _instance!;
    if (_initializationFuture != null) return _initializationFuture!;

    _initializationFuture = _initialize();
    _instance = await _initializationFuture!;
    _initializationFuture = null;
    return _instance!;
  }

  static Future<VerifierClientService> _initialize() async {
    final service = VerifierClientService._();
    final storage = await StorageFactory.createDataStorage();
    final registeredClientString = await storage.get(defaultVerifierClient.id);

    if (registeredClientString != null) {
      final existingClient = VerifierClient.fromJson(
        jsonDecode(registeredClientString),
      );

      print('${existingClient.id}::Loaded existing VerifierClient from file');
      print(
        '${existingClient.id}::Permanent DID: ${existingClient.permanentDid}',
      );

      service._client = await SetupClientUseCase(
        sdk: MpxSdkService.instance.mpxSdk,
        storage: storage,
        vdspClients: vdspClients,
        requestIds: requestIds,
      )(existingClient);
    } else {
      final client = defaultVerifierClient;

      service._client = await SetupClientUseCase(
        sdk: MpxSdkService.instance.mpxSdk,
        storage: storage,
        vdspClients: vdspClients,
        requestIds: requestIds,
      )(client);
    }

    return service;
  }

  static VerifierClientService get instance {
    if (_instance == null) {
      throw StateError(
        'VerifierClientService not initialized. Call await VerifierClientService.init() first.',
      );
    }
    return _instance!;
  }

  VerifierClient get client => _client;

  void refreshOobUrl({required IStorage storage}) async {
    try {
      final getContactCardUseCase = GetContactCardUseCase();
      final contactCard = getContactCardUseCase(_client.name);

      final createOobInviteUseCase = CreateOobInviteUseCase(
        MpxSdkService.instance.mpxSdk,
      );
      final newOobUrl = await createOobInviteUseCase(
        contactCard,
        client.permanentDid,
      );

      // Update the client fields
      _client.oobUrl = newOobUrl;
      _client.oobUrlGeneratedAt = DateTime.now();

      // Save updated client to storage
      await storage.put(_client.id, jsonEncode(_client.toJson()));

      print(
        '${_client.id}::OOB URL refreshed: ${newOobUrl.substring(0, 50)}...',
      );

      // Broadcast the new OOB URL to connected clients if any
      if (activeSockets.isNotEmpty) {
        final broadcastUseCase = BroadcastMessageUseCase(activeSockets);
        broadcastUseCase(_client.id, {
          'type': 'oob-url-refreshed',
          'oobUrl': newOobUrl,
          'message': 'OOB URL has been refreshed for ${_client.name}',
        });
      }
    } catch (e) {
      print('${_client.id}::Failed to refresh OOB URL: $e');
    }
  }

  // void stopOobRefreshTimer() {
  //   oobRefreshTimer?.cancel();
  //   oobRefreshTimer = null;
  //   print('OOB URL refresh timer stopped');
  // }
}
