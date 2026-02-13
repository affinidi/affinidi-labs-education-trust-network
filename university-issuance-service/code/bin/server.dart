import 'package:university_issuance_service/app_context.dart';
import 'package:university_issuance_service/helper.dart';
import 'package:university_issuance_service/mpx_client.dart';
import 'package:university_issuance_service/storage/storage_factory.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import 'package:university_issuance_service/env.dart' as env_loader;
import 'package:university_issuance_service/middleware/logging.dart';
import 'package:university_issuance_service/middleware/error_handler.dart';
import 'package:university_issuance_service/middleware/auth.dart';
import 'package:university_issuance_service/routes.dart';

void main(List<String> args) async {
  // Parse command line arguments for --env-file
  String? envFile;
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--env-file' && i + 1 < args.length) {
      envFile = args[i + 1];
      break;
    } else if (args[i].startsWith('--env-file=')) {
      envFile = args[i].substring('--env-file='.length);
      break;
    }
  }

  // Load .env with optional custom filename
  if (envFile != null) {
    print('Loading environment from: $envFile');
    env_loader.Env.load(filename: envFile);
  } else {
    env_loader.Env.load();
  }

  //Initialize SDK + DID + Notifications once
  final mpxClient = await MpxClient.init();
  final appContext = AppContext(mpxClient: mpxClient);

  Handler contextMiddleware(Handler innerHandler) {
    return (Request req) {
      //print('MPX Context set');
      final updated = req.change(context: {'appContext': appContext});
      return innerHandler(updated);
    };
  }

  final port = int.tryParse(env_loader.Env.get('PORT', '8080')) ?? 8080;

  // static handler serves files from `public/` and maps URL path straight to files
  final staticHandler = createStaticHandler('public');

  final storage = await StorageFactory.createDataStorage();

  //Generate did:web for issuer
  await generateDIDWebForEntity(storage);

  // create router with API routes
  final router = createRouter();

  // Combine: try router first, if it returns 404 then static handler will be used
  final cascadeHandler = Cascade().add(router.call).add(staticHandler).handler;

  // build middleware pipeline: error -> logging -> auth -> cascade
  final handler = const Pipeline()
      .addMiddleware(errorHandlerMiddleware())
      .addMiddleware(loggingMiddleware())
      .addMiddleware(contextMiddleware)
      .addMiddleware(authMiddleware(publicPaths: ['/', 'login']))
      .addHandler(cascadeHandler);

  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  print('Server listening on http://${server.address.host}:${server.port}');
}
