// CustomDidResolver is commented out - using standard resolver from package:ssi
// which already implements DID:web spec correctly

/*
/// Custom DID resolver that supports HTTP for localhost development
class CustomDidResolver {
  static bool get useSsl {
    // Read from dart-define environment variable
    const useSslEnv = String.fromEnvironment('USE_SSL', defaultValue: 'true');
    return useSslEnv.toLowerCase() != 'false';
  }

  /// Resolves a did:web DID, using HTTP for localhost when USE_SSL=false
  static Future<DidDocument> resolveDidWeb(String did) async {
    print('[CustomDidResolver] Resolving DID: $did');
    print('[CustomDidResolver] USE_SSL: $useSsl');̦

    // Parse the DID to extract domain and path
    final didParts = did.replaceFirst('did:web:', '');
    print('[CustomDidResolver] DID parts: $didParts');

    // Convert DID format to URL
    var urlPath = didParts.replaceAll(':', '/');
    urlPath = urlPath.replaceAll('%3A', ':');̦̦
    urlPath = urlPath.replaceAll('%2F', '/');

    print('[CustomDidResolver] URL path after conversion: $urlPath');

    // Determine if this is a localhost DID (0.0.0.0 is treated as localhost)
    final isLocalhost = urlPath.startsWith('0.0.0.0');
    print('[CustomDidResolver] Is localhost: $isLocalhost');

    // Choose protocol based on USE_SSL and whether it's localhost (0.0.0.0)
    String protocol;
    if (!useSsl && isLocalhost) {
      protocol = 'http';
      print('[CustomDidResolver] Using HTTP for localhost (USE_SSL=false)');
    } else {
      protocol = 'https';
      print('[CustomDidResolver] Using HTTPS');
    }

    // Build the DID document URL according to DID:web spec
    // did:web:domain -> /.well-known/did.json
    // did:web:domain:path -> /path/did.json (NO .well-known)
    final pathSegments = urlPath.split('/');
    String docUrl;
    if (pathSegments.length == 1) {
      // Root domain only, use .well-known
      docUrl = '$protocol://$urlPath/.well-known/did.json';
    } else {
      // Has path component, don't use .well-known
      docUrl = '$protocol://$urlPath/did.json';
    }
    print('[CustomDidResolver] Fetching DID document from: $docUrl');

    try {
      final response = await http.get(Uri.parse(docUrl));
      print('[CustomDidResolver] HTTP status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('[CustomDidResolver] Successfully fetched DID document');
        print(
          '[CustomDidResolver] Response body length: ${response.body.length}',
        );

        final jsonDoc = jsonDecode(response.body) as Map<String, dynamic>;
        final didDoc = DidDocument.fromJson(jsonDoc);

        print('[CustomDidResolver] DID document parsed successfully');
        print('[CustomDidResolver] DID: ${didDoc.id}');
        print('[CustomDidResolver] Services count: ${didDoc.service.length}');

        return didDoc;
      } else {
        print('[CustomDidResolver] Error: HTTP ${response.statusCode}');
        print('[CustomDidResolver] Response body: ${response.body}');
        throw Exception('Failed to resolve DID: HTTP ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[CustomDidResolver] Exception occurred: $e');
      print('[CustomDidResolver] Stack trace: $stackTrace');
      rethrow;
    }
  }
}
*/
