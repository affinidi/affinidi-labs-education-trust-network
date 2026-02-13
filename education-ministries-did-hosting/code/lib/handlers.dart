import 'package:shelf/shelf.dart';
import 'storage_interface.dart';

/// Handler for serving DID documents
Future<Response> didDocumentHandler(Request req, String didPath) async {
  final storage = req.context['storage'] as IStorage;

  print('[DID Handler] Request for path: $didPath');

  // Construct storage key for the DID document
  final storageKey =
      didPath.isEmpty ? '.well-known/did.json' : '$didPath/did.json';

  print('[DID Handler] Looking up storage key: $storageKey');

  final didDocument = await storage.get(storageKey);

  if (didDocument != null) {
    print('[DID Handler] ✅ Found DID document');
    return Response.ok(
      didDocument,
      headers: {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    );
  }

  print('[DID Handler] ❌ DID document not found for key: $storageKey');
  return Response.notFound(
    '{"error": "DID document not found", "path": "$storageKey"}',
    headers: {'content-type': 'application/json'},
  );
}

/// Home/health handler
Response homeHandler(Request req) {
  return Response.ok(
    '{"status": "ok", "service": "Education Ministries DID Hosting"}',
    headers: {'content-type': 'application/json'},
  );
}
