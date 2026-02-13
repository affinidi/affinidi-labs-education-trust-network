import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/create_oob_invite_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/create_vdsp_client_use_case.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/get_contact_card_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/handle_notification_message_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/register_for_notifications_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/subscribe_for_vdsp_response_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/entities/verifier_client.dart';
import 'package:vdsp_verifier_server/core/infrastructure/storage/storage_interface.dart';

/// Sets up a verifier client with DID, OOB invite, VDSP client, and notifications
class SetupClientUseCase {
  final MeetingPlaceCoreSDK sdk;
  final IStorage storage;
  final Map<String, VdspVerifier> vdspClients;
  final Map<String, String> requestIds;

  SetupClientUseCase({
    required this.sdk,
    required this.storage,
    required this.vdspClients,
    required this.requestIds,
  });

  Future<VerifierClient> call(VerifierClient client) async {
    try {
      print('${client.id}::Setting up Client');

      await _setupPermanentDid(client);
      await _setupOobInvite(client);
      await _setupVdspClient(client);
      await _setupNotifications(client);
      await _subscribeToVdspResponses(client);

      print(
        '${client.id}::Client setup completed: ${client.id}-${client.name}',
      );
      return client;
    } catch (e, stackTrace) {
      print('${client.id}::Error setting up client: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _setupPermanentDid(VerifierClient client) async {
    if (client.permanentDid == null) {
      print('${client.id}::Generating Permanent DID...');
      final didManager = await sdk.generateDid();
      final didDoc = await didManager.getDidDocument();
      client.permanentDid = didDoc.id;
    } else {
      print('${client.id}::Using Existing Permanent DID...');
    }
    print('${client.id}::Permanent DID: ${client.permanentDid}');
  }

  Future<void> _setupOobInvite(VerifierClient client) async {
    final contactCard = GetContactCardUseCase()(client.name);
    client.oobUrl = await CreateOobInviteUseCase(sdk)(
      contactCard,
      client.permanentDid,
    );
    print('${client.id}::OOB Url: ${client.oobUrl}');
  }

  Future<void> _setupVdspClient(VerifierClient client) async {
    print('${client.id}::Creating VDSP Client');
    vdspClients[client.id] = await CreateVdspClientUseCase(sdk)(client);
  }

  Future<void> _setupNotifications(VerifierClient client) async {
    print('${client.id}::Register for Notifications...');

    final notificationHandler = HandleNotificationMessageUseCase(
      sdk: sdk,
      vdspClients: vdspClients,
      requestIds: requestIds,
    );

    await RegisterForNotificationsUseCase(sdk)(
      client.permanentDid!,
      (message) => notificationHandler(client.id, client.purpose, message),
    );
  }

  Future<void> _subscribeToVdspResponses(VerifierClient client) async {
    await SubscribeForVdspResponseUseCase()(vdspClients[client.id]!, client);
  }
}
