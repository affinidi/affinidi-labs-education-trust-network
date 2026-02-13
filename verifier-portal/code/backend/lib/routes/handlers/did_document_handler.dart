import 'dart:convert';
import 'package:shelf/shelf.dart';

Future<Response> didDocumentHandler(
  Request request,
  Map<String, dynamic>? didDocument,
) async {
  if (didDocument == null) {
    return Response.internalServerError(body: 'DID document not available');
  }

  return Response.ok(
    jsonEncode(didDocument),
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  );
}

Future<Response> didDocumentOptionsHandler(Request request) async {
  return Response.ok(
    '',
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  );
}
