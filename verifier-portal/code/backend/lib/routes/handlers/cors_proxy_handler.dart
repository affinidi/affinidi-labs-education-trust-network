import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';

Future<Response> corsProxyHandler(Request request) async {
  final url = request.url.queryParameters['url'];
  if (url == null || url.isEmpty) {
    return Response.badRequest(body: 'Missing url parameter');
  }

  try {
    print('[CORS Proxy] Fetching: $url');
    final client = HttpClient();
    final uri = Uri.parse(url);
    final httpRequest = await client.getUrl(uri);
    final httpResponse = await httpRequest.close();

    if (httpResponse.statusCode != 200) {
      print('[CORS Proxy] Error: HTTP ${httpResponse.statusCode}');
      return Response(
        httpResponse.statusCode,
        body: 'Failed to fetch resource',
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      );
    }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    print('[CORS Proxy] Success: ${responseBody.length} bytes');

    return Response.ok(
      responseBody,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  } catch (e) {
    print('[CORS Proxy] Exception: $e');
    return Response.internalServerError(
      body: 'Failed to fetch resource: $e',
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  }
}

Future<Response> corsProxyOptionsHandler(Request request) async {
  return Response.ok(
    '',
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  );
}
