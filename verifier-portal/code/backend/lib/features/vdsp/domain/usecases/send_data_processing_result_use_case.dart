import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';

/// Sends data processing result back to holder
class SendDataProcessingResultUseCase {
  SendDataProcessingResultUseCase();

  Future<void> call(
    VdspVerifier vdspClient,
    String holderDid,
    bool isValid,
    String message,
  ) async {
    final result = {
      'status': 'success',
      'completed': true,
      'channel_did': holderDid,
      'message': message,
      'presentationAndCredentialsAreValid': isValid,
    };

    await vdspClient.sendDataProcessingResult(
      holderDid: holderDid,
      result: result,
    );
  }
}
