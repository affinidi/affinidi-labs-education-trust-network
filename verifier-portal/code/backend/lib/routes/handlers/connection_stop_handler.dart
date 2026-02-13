import 'dart:convert';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:shelf/shelf.dart';

Future<Response> connectionStopHandler(Request req) async {
  try {
    ConnectionPool.instance.stopConnections();

    return Response.ok(
      jsonEncode({
        'status': 'ok',
        'message': 'Connection pool stopped successfully',
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, stackTrace) {
    print('Error in /api/connection-stop: $e');
    print('Stack trace: $stackTrace');
    return Response.internalServerError(
      body: jsonEncode({
        'error': 'Failed to stop connection pool',
        'message': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
