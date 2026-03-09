import 'dart:convert';
import 'package:dcql/dcql.dart';
import 'package:shelf/shelf.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/constants/global_vars.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/usecases/send_vdsp_request_use_case.dart';
import '../helper.dart';

Future<Response> dcqlRequestHandler(Request req) async {
  final body = await req.readAsString();
  Map<String, dynamic> data = {};

  if (body.isNotEmpty) {
    try {
      data = jsonDecode(body);
    } catch (_) {
      return jsonResponse({
        'error': 'Invalid JSON in request body',
      }, status: 400);
    }
  }
  print('DCQL Request data: $data');

  if (data['clientId'] == null ||
      data['holder_channel_did'] == null ||
      data['payloadId'] == null ||
      data['dcql_query'] == null) {
    return jsonResponse({
      'error':
          'Missing required parameters: clientId, payloadId, holder_channel_did, dcql_query',
    }, status: 400);
  }

  final dcql = DcqlCredentialQuery.fromJson(data['dcql_query']);

  // Get required services

  await SendVdspRequestUseCase(vdspClients, requestIds)(
    data['clientId'],
    data['holder_channel_did'],
    'Credulon card payload dcql request',
    dcql,
    // data['payloadId'],
  );

  return jsonResponse({
    'status': 'ok',
    'message': 'VDSP request sent successfully',
  });
}
