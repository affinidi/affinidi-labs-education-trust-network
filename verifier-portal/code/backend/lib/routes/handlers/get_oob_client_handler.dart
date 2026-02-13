import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:vdsp_verifier_server/features/vdsp/data/verifier_client/verifier_client_service.service.dart';

Future<Response> getOobClientHandler(Request req) async {
  final verifierClient = VerifierClientService.instance.client;
  return Response.ok(
    jsonEncode(verifierClient),
    headers: {'Content-Type': 'application/json'},
  );
}
