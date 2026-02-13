import 'dart:convert';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:ssi/ssi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/broadcast_message_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/build_vc_response_data_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/send_data_processing_result_use_case.dart';
import 'package:vdsp_verifier_server/features/trust-registry/validate_credentials_trust_registry_use_case.dart';

/// Handles VDSP data response message processing
class HandleVdspDataResponseUseCase {
  final List<WebSocketChannel> activeSockets;

  HandleVdspDataResponseUseCase(this.activeSockets);

  Future<void> call({
    required VdspVerifier vdspClient,
    required String clientId,
    required VdspDataResponseMessage message,
    required bool presentationAndCredentialsAreValid,
    required VerifiablePresentation verifiablePresentation,
  }) async {
    try {
      _logReceivedMessage(message, verifiablePresentation);

      print('VP and VCs are valid: $presentationAndCredentialsAreValid');

      // Run trust registry checks
      final perVCResults = await ValidateCredentialsTrustRegistryUseCase()(
        verifiablePresentation,
        onProgress: (result) async {
          prettyPrint('TRQP Progress', object: result);
          BroadcastMessageUseCase(activeSockets)(clientId, {
            'completed': false,
            'status': result['messageType'],
            'message': result['message'],
          });
        },
      );

      // Determine overall validity
      final allTrustRegistryValid = perVCResults.every((r) => r.isValid);
      final overallStatus =
          presentationAndCredentialsAreValid && allTrustRegistryValid;

      // Build VC response data
      final verifiableCredentials = BuildVcResponseDataUseCase()(perVCResults);

      // Broadcast completion to frontend
      await _broadcastCompletionMessage(
        clientId: clientId,
        status: overallStatus,
        presentationAndCredentialsAreValid: presentationAndCredentialsAreValid,
        verifiableCredentials: verifiableCredentials,
      );

      // Send result back to holder
      await SendDataProcessingResultUseCase()(
        vdspClient,
        message.from!,
        presentationAndCredentialsAreValid,
        'Credentials Shared',
      );
    } catch (e, stackTrace) {
      print('Error handling data response: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _logReceivedMessage(
    VdspDataResponseMessage message,
    VerifiablePresentation verifiablePresentation,
  ) {
    prettyPrint('Verifier received Data Response Message');
    prettyPrint(message.toString(), object: jsonEncode(message.toJson()));
    print(
      "Verifiable presentation: ${jsonEncode(verifiablePresentation.toJson())}",
    );
  }

  Future<void> _broadcastCompletionMessage({
    required String clientId,
    required bool status,
    required bool presentationAndCredentialsAreValid,
    required List<Map<String, dynamic>> verifiableCredentials,
  }) async {
    const resultMessage = 'Credentials Shared';

    print('Broadcast message structure:');
    print('  - completed: true');
    print('  - status: ${status ? 'success' : 'failure'}');
    print('  - message: $resultMessage');
    print(
      '  - presentationAndCredentialsAreValid: $presentationAndCredentialsAreValid',
    );
    print('  - verifiableCredentials count: ${verifiableCredentials.length}');

    try {
      final broadcastMessage = {
        'completed': true,
        'status': status ? 'success' : 'failure',
        'message': resultMessage,
        'presentationAndCredentialsAreValid':
            presentationAndCredentialsAreValid,
        'verifiableCredentials': verifiableCredentials,
      };

      print('Broadcasting completion message...');
      BroadcastMessageUseCase(activeSockets)(clientId, broadcastMessage);
      print('Broadcast completed successfully');
    } catch (e, stackTrace) {
      print('ERROR: Failed to broadcast message: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
