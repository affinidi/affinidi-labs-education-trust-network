import 'package:ssi/ssi.dart';
import 'package:vdsp_verifier_server/core/infrastructure/config/app_config.dart';

class GetMediatorDidDocumentUseCase {
  Future<DidDocument> call() async {
    final mediatorDid = AppConfig.mediatorDid;
    final mediatorDidDocument = await UniversalDIDResolver.defaultResolver
        .resolveDid(mediatorDid);
    return mediatorDidDocument;
  }
}
