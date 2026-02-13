import 'package:ssi/ssi.dart';

/// Resolves trust registry URL from DID document
class ResolveTrustRegistryUrlUseCase {
  Future<String?> call(String didWeb) async {
    final resolver = UniversalDIDResolver();
    final didWebDocument = await resolver.resolveDid(didWeb);

    final trEndpoint = didWebDocument.service
        .where((end) => end.type == 'TRQP')
        .firstOrNull;

    if (trEndpoint == null) {
      return null;
    }

    final trUrl = (trEndpoint.serviceEndpoint as StringEndpoint).url;
    return trUrl;
  }
}
