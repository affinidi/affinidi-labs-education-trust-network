import 'package:university_issuance_service/route-handlers/did_web_document_handler.dart';
import 'package:university_issuance_service/route-handlers/home_handler.dart';
import 'package:university_issuance_service/route-handlers/login_handler.dart';
// import 'package:university_issuance_service/route-handlers/redis_handler.dart';
import 'package:shelf_router/shelf_router.dart';

Router createRouter() {
  final router = Router();
  router.get('/', homeHandler);
  router.get('/health', healthHandler);

  // DID:web resolution routes
  // For root domain: did:web:example.com -> /.well-known/did.json
  router.get('/.well-known/did.json', didWebDocumentHandler);
  // For paths: did:web:example.com:path -> /path/did.json
  router.get(r'/<didPath|.*>/did.json', didWebDocumentHandler);

  // Admin Redis management routes (root level)
  // router.get('/admin/redis/keys', listKeysHandler);
  // router.post('/admin/redis/delete', clearKeysHandler);
  // router.get('/admin/redis/info', redisInfoHandler);
  // router.get('/admin/redis/key/<key>', getKeyHandler);

  // All routes under /api
  final apiRouter = Router();

  apiRouter.post('/login', loginHandler);
  // apiRouter.post('/generate-did-web', didWebGeneraterHandler);

  // Mount apiRouter under /api prefix
  router.mount('/api/', apiRouter);

  return router;
}
