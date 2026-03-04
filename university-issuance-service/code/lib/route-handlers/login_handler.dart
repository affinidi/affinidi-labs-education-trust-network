import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../app_context.dart';
import '../env.dart';

Future<Response> loginHandler(Request req) async {
  print('[LoginHandler] ========== LOGIN REQUEST START ==========');

  final payload = await req.readAsString();
  print('[LoginHandler] Received payload: $payload');

  if (payload.isEmpty) {
    print('[LoginHandler] ERROR: Empty body received');
    return Response(
      400,
      body: jsonEncode({'error': 'Empty body'}),
      headers: {'content-type': 'application/json'},
    );
  }

  final data = jsonDecode(payload) as Map<String, dynamic>;
  final email = (data['email'] ?? '') as String;
  print('[LoginHandler] Extracted email: $email');

  if (email.isEmpty || !email.contains('@')) {
    print('[LoginHandler] ERROR: Invalid email format');
    return Response(
      400,
      body: jsonEncode({'error': 'Invalid email'}),
      headers: {'content-type': 'application/json'},
    );
  }

  // Get allowed domains from environment variable (comma-separated)
  final allowedDomainsStr = Env.get(
    'ALLOWED_EMAIL_DOMAIN',
    'nexigen,affinidi',
  );
  print('[LoginHandler] ALLOWED_EMAIL_DOMAIN from env: $allowedDomainsStr');

  final allowedDomains = allowedDomainsStr
      .split(',')
      .map((d) => d.trim())
      .toList();
  print('[LoginHandler] Parsed allowed domains: $allowedDomains');

  // Create regex pattern: ^[^@]+@([^@]+\.)*(domain1\.com|domain2\.com)$
  final domainPattern = allowedDomains
      .map((d) => RegExp.escape(d) + r'\.com')
      .join('|');
  final emailRegex = RegExp(r'^[^@]+@([^@]+\.)*(' + domainPattern + r')$');
  print('[LoginHandler] Generated regex pattern: ${emailRegex.pattern}');
  print('[LoginHandler] Testing email "$email" against regex...');
  print('[LoginHandler] Regex match result: ${emailRegex.hasMatch(email)}');

  if (emailRegex.hasMatch(email)) {
    print('[LoginHandler] ✓ Email authorized, creating OOB invite...');
    try {
      final context = req.context['appContext'] as AppContext;
      final mpxClient = context.mpxClient;

      print('[LoginHandler] Got mpxClient, calling createOobInvite...');
      final oobUrl = await mpxClient.createOobInvite();

      print('[LoginHandler] OOB URL created: $oobUrl');
      print('[LoginHandler] Permanent DID: ${mpxClient.permanentDid}');

      final resp = {
        'ok': true,
        'email': email,
        'oobUrl': oobUrl,
        "did": mpxClient.permanentDid,
      };
      print('[LoginHandler] ✓ Sending success response');
      return Response.ok(
        jsonEncode(resp),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('[LoginHandler] ❌ EXCEPTION creating OOB invite: $e');
      print('[LoginHandler] Exception type: ${e.runtimeType}');
      print('[LoginHandler] Stack trace: $stackTrace');

      // Try to extract more details from the exception
      if (e.toString().contains('DidWeb.resolve')) {
        print('[LoginHandler] ⚠️  This appears to be a DID resolution error');
        print(
          '[LoginHandler] Check that SERVICE_DID and MEDIATOR_DID are correct and accessible',
        );
      }

      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Failed to create OOB invite',
          'details': e.toString(),
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  } else {
    print('[LoginHandler] ✗ Email NOT authorized');
    print('[LoginHandler] Email domain does not match allowed domains');
    print('[LoginHandler] Sending 403 Forbidden response');
    return Response.forbidden(
      jsonEncode({'error': 'Unauthorized user'}),
      headers: {'content-type': 'application/json'},
    );
  }
}
