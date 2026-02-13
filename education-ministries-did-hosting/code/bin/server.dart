import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import '../lib/env.dart';
import '../lib/file_storage.dart';
import '../lib/did_generator.dart';
import '../lib/routes.dart';

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

  // Load environment
  if (envFile != null) {
    print('Loading environment from: $envFile');
    Env.load(filename: envFile);
  } else {
    Env.load();
  }

  // Initialize storage
  final storage = await FileStorage.create();

  // Generate DIDs for all configured ministries
  await initializeMinistries(storage);

  // Create middleware to inject storage into request context
  Handler storageMiddleware(Handler innerHandler) {
    return (Request req) {
      final updated = req.change(context: {'storage': storage});
      return innerHandler(updated);
    };
  }

  // Create router
  final router = createRouter();

  // Build middleware pipeline
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(storageMiddleware)
      .addHandler(router.call);

  // Start server
  final port = Env.getInt('PORT', 3100);
  final server = await shelf_io.serve(handler, '0.0.0.0', port);

  print('');
  print('========================================');
  print('Education Ministries DID Hosting Service');
  print('========================================');
  print('Server listening on http://${server.address.host}:${server.port}');
  print('========================================');
  print('');
}

/// Initialize all education ministries from environment configuration
Future<void> initializeMinistries(storage) async {
  print('');
  print('========================================');
  print('Initializing Education Ministries');
  print('========================================');

  // Get list of ministries from environment (comma-separated)
  final ministriesStr = Env.get('MINISTRIES', '');
  if (ministriesStr.isEmpty) {
    print('⚠️  No MINISTRIES configured in environment');
    return;
  }

  final ministries = ministriesStr.split(',').map((s) => s.trim()).toList();
  print(
      'Found ${ministries.length} ministries to initialize: ${ministries.join(', ')}');
  print('');

  for (final ministry in ministries) {
    if (ministry.isEmpty) continue;

    print('----------------------------------------');
    print('Ministry: $ministry');
    print('----------------------------------------');

    // Get configuration for this ministry
    final domain = Env.get('${ministry}_DOMAIN');
    final trustRegistryUrl = Env.get('${ministry}_TRUST_REGISTRY_URL');

    if (domain.isEmpty) {
      print('⚠️  Skipping $ministry: ${ministry}_DOMAIN not configured');
      continue;
    }

    print('Domain: $domain');
    print(
        'Trust Registry: ${trustRegistryUrl.isEmpty ? 'none' : trustRegistryUrl}');

    // Generate DID
    await generateEducationMinistryDID(
      storage,
      ministryName: ministry,
      domain: domain,
      trustRegistryUrl: trustRegistryUrl.isEmpty ? null : trustRegistryUrl,
    );

    print('');
  }

  print('========================================');
  print('✅ All ministries initialized');
  print('========================================');
  print('');
}
