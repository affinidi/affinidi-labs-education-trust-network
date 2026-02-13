import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/use_cases/verify_credential_use_case.dart';

Future<Response> verifyHandler(Request req) async {
  try {
    // Parse the request body
    final body = await req.readAsString();
    final Map<String, dynamic> requestData = jsonDecode(body);

    // Extract credential from the request
    final credential = requestData['data'] as String?;

    if (credential == null || credential.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Missing or empty credential parameter',
          'message': 'credential is required in the request body',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    // Call the verifyCredential method
    final verificationResult = await VerifyCredentialUseCase()(credential);

    // Return the verification result
    return Response.ok(
      jsonEncode({
        'isValid': verificationResult.isValid,
        'errors': verificationResult.errors,
        'warnings': verificationResult.warnings,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, stackTrace) {
    print('Error in /api/verify: $e');
    print('Stack trace: $stackTrace');
    return Response.internalServerError(
      body: jsonEncode({
        'error': 'Internal server error',
        'message': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
