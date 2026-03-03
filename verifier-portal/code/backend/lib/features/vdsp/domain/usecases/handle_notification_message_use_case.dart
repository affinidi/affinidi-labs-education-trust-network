import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/send_vdsp_request_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/constants/vdsp.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/entities/vdsp_trigger_request.dart';

/// Handles DIDComm notification messages for a verifier client
class HandleNotificationMessageUseCase {
  final MeetingPlaceCoreSDK sdk;
  final Map<String, VdspVerifier> vdspClients;
  final Map<String, String> requestIds;

  HandleNotificationMessageUseCase({
    required this.sdk,
    required this.vdspClients,
    required this.requestIds,
  });

  Future<void> call(
    String clientId,
    String purpose,
    PlainTextMessage message,
  ) async {
    try {
      print('$clientId::Message received: ${message.type}');

      if (message.type != VpspTriggerRequestMessage.messageType) {
        print('$clientId::Ignoring non-VPSP message type: ${message.type}');
        return;
      }

      final channel = await _getChannelForMessage(clientId, message);
      if (channel == null) {
        return;
      }

      print('$clientId::Message body ${message.body}');

      // Send VDSP Request
      await SendVdspRequestUseCase(vdspClients, requestIds)(
        clientId,
        message.from!,
        purpose,
        dcqlCertizen,
      );
    } catch (e, stackTrace) {
      print('$clientId::Error processing message: $e');
      print('$clientId::Stack trace: $stackTrace');
    }
  }

  Future<Channel?> _getChannelForMessage(
    String clientId,
    PlainTextMessage message,
  ) async {
    final channel = await sdk.getChannelByOtherPartyPermanentDid(message.from!);

    if (channel == null) {
      print('$clientId::Unknown holder, No channel found for ${message.from}');
    }

    return channel;
  }
}
