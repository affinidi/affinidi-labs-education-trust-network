import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:uuid/uuid.dart';

/// Handles problem report messages from VDSP
class HandleProblemReportUseCase {
  HandleProblemReportUseCase();

  Future<void> call(VdspVerifier vdspClient, ProblemReportMessage msg) async {
    prettyPrint('A problem has occurred', object: msg);

    try {
      if (msg.body!['code'] != 'w.websocket.duplicate-channel') {
        await vdspClient.mediatorClient.packAndSendMessage(
          ProblemReportMessage(
            id: const Uuid().v4(),
            to: [msg.from!],
            parentThreadId: msg.threadId ?? msg.id,
            body: ProblemReportBody.fromJson(msg.body!),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error handling problem report: $e');
      print('Stack trace: $stackTrace');
    }
  }
}
