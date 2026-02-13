import 'dart:convert';
import 'package:shelf/shelf.dart';

Future<Response> healthHandler(Request req) async {
  final body = jsonEncode({'status': 'ok', 'message': 'healthy'});
  return Response.ok(body, headers: {'content-type': 'application/json'});
}
