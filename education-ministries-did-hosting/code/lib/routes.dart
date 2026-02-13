import 'package:shelf_router/shelf_router.dart';
import 'handlers.dart';

Router createRouter() {
  final router = Router();

  // Health check
  router.get('/', homeHandler);
  router.get('/health', homeHandler);

  // DID document routes
  // For root domain: did:web:example.com -> /.well-known/did.json
  router.get('/.well-known/did.json', (req) => didDocumentHandler(req, ''));

  // For paths: did:web:example.com:path -> /path/did.json
  router.get(r'/<didPath|.*>/did.json',
      (req, String didPath) => didDocumentHandler(req, didPath));

  return router;
}
