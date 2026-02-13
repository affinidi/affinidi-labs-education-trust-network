import 'package:university_issuance_service/storage/storage_factory.dart';
import 'package:shelf/shelf.dart';

Future<Response> didWebDocumentHandler(Request req, String didPath) async {
  final storage = await StorageFactory.createDataStorage();

  // didPath now contains just the path prefix (e.g., "hongkong-university" or "hongkong-education-ministry")
  // Construct storage path based on whether this is root or path-based
  String storagePath;
  if (didPath.isEmpty) {
    // Root domain: /.well-known/did.json
    storagePath = '.well-known/did.json';
  } else {
    // Path-based: /path/did.json (not .well-known)
    storagePath = '$didPath/did.json';
  }

  print('[DID Document Handler] Request for: $didPath');
  print('[DID Document Handler] Storage path: $storagePath');

  final didDocument = await storage.get(storagePath);
  if (didDocument != null) {
    print('[DID Document Handler] ✅ Found DID document for: $didPath');
    return Response.ok(
      didDocument,
      headers: {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    );
  }

  // Log error with more details
  print('[DID Document Handler] ❌ DID document NOT found');
  print('[DID Document Handler] Requested path: $didPath');
  print('[DID Document Handler] Storage path: $storagePath');
  print(
    '[DID Document Handler] Available keys: ${await _listStorageKeys(storage)}',
  );

  return Response.notFound(
    '{"error": "DID document not found", "path": "$storagePath", "requestedPath": "$didPath"}',
    headers: {'content-type': 'application/json'},
  );
}

/// Helper to list storage keys for debugging
Future<String> _listStorageKeys(dynamic storage) async {
  try {
    // Try to get common keys to help debug
    final keys = <String>[];
    final commonPaths = [
      'hongkong-university/did.json',
      'macau-university/did.json',
      'issuer_did_web',
      'issuer_did_web_domain',
    ];

    for (final path in commonPaths) {
      final value = await storage.get(path);
      if (value != null) {
        keys.add(path);
      }
    }

    return keys.isEmpty ? 'none found' : keys.join(', ');
  } catch (e) {
    return 'error listing keys: $e';
  }
}
