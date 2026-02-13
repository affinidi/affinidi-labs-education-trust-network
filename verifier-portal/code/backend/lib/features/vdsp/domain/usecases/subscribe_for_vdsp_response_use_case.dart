import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:ssi/ssi.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/constants/global_vars.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/handle_vdsp_data_response_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/handle_problem_report_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/entities/verifier_client.dart';

/// Subscribes to VDSP response messages and delegates handling to specialized use cases
class SubscribeForVdspResponseUseCase {
  SubscribeForVdspResponseUseCase();

  Future<void> call(VdspVerifier vdspClient, VerifierClient client) async {
    print('${client.id}::Subscribed for VDSP Responses');

    vdspClient.listenForIncomingMessages(
      onDiscloseMessage: (message) async {
        prettyPrint('Verifier received Disclose Message', object: message);
      },
      onDataResponse:
          ({
            required VdspDataResponseMessage message,
            required bool presentationAndCredentialsAreValid,
            VerifiablePresentation? verifiablePresentation,
            required VerificationResult presentationVerificationResult,
            required List<VerificationResult> credentialVerificationResults,
          }) async {
            await HandleVdspDataResponseUseCase(activeSockets)(
              vdspClient: vdspClient,
              clientId: client.id,
              message: message,
              presentationAndCredentialsAreValid:
                  presentationAndCredentialsAreValid,
              verifiablePresentation: verifiablePresentation!,
            );
          },
      onProblemReport: (msg) async {
        await HandleProblemReportUseCase()(vdspClient, msg);
      },
    );

    await ConnectionPool.instance.startConnections();
  }
}
