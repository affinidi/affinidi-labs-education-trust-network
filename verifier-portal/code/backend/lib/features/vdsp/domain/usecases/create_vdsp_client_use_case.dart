import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:ssi/ssi.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/get_mediator_did_document_use_case.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/entities/verifier_client.dart';

class CreateVdspClientUseCase {
  final MeetingPlaceCoreSDK sdk;

  CreateVdspClientUseCase(this.sdk);

  Future<VdspVerifier> call(VerifierClient client) async {
    DidManager manager = await sdk.getDidManager(client.permanentDid!);

    final mediatorDidDocument = await GetMediatorDidDocumentUseCase()();
    final vdspClient = await VdspVerifier.init(
      mediatorDidDocument: mediatorDidDocument,
      clientOptions: const AffinidiClientOptions(),
      didManager: manager,
      authorizationProvider: await AffinidiAuthorizationProvider.init(
        mediatorDidDocument: mediatorDidDocument,
        didManager: manager,
      ),
    );

    return vdspClient;
  }
}
