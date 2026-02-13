import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:dcql/dcql.dart';
import 'package:uuid/uuid.dart';

class SendVdspRequestUseCase {
  final Map<String, VdspVerifier> vdspClients;
  final Map<String, String> requestIds;

  SendVdspRequestUseCase(this.vdspClients, this.requestIds);

  Future<void> call(
    String clientId,
    String holderDid,
    String purpose,
    DcqlCredentialQuery dcql,
  ) async {
    final vdspClient = vdspClients[clientId];
    if (vdspClient == null) {
      print('VDSP Client not found for $clientId');
      return;
    }
    print('VDSP: Sending Request to holder $holderDid from client $clientId');

    final verifierChallenge = Uuid().v4();

    await vdspClient.queryHolderData(
      holderDid: holderDid,
      dcqlQuery: dcql,
      operation: purpose,
      proofContext: VdspQueryDataProofContext(
        challenge: verifierChallenge,
        domain: holderDid,
      ),
    );
    print('VDSP: Request sent with challenge $verifierChallenge');

    requestIds[verifierChallenge] = clientId;
  }
}
