import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:vdsp_verifier_server/features/mpx/domain/constants/global_vars.dart';
import 'package:vdsp_verifier_server/features/vdsp/data/verifier_client/verifier_client_service.service.dart';
import 'core/infrastructure/config/app_config.dart';
import 'features/wallet/wallet/wallet.service.dart';
import 'features/wallet/key_repository/key_repository.service.dart';
import 'features/mpx/data/channel_repository/channel_repository.service.dart';
import 'features/mpx/data/mpx_sdk/mpx_sdk.service.dart';
import 'routes/handlers/health_handler.dart';
import 'routes/handlers/verify_handler.dart';
import 'routes/handlers/get_oob_client_handler.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

/// Standalone HTTP server to serve the DID document and API endpoints
/// This runs on port 4001 as a pure Dart backend server
void main(List<String> args) async {
  // Load environment variables
  print('[DID Server] Loading environment variables...');
  await AppConfig.loadEnvironment();

  // Initialize all services eagerly in the correct order
  print('[DID Server] Initializing services...');

  // 1. Initialize base services
  await WalletService.init();
  print('[DID Server] ✅ WalletService initialized');

  await KeyRepositoryService.init();
  print('[DID Server] ✅ KeyRepositoryService initialized');

  await ChannelRepositoryService.init();
  print('[DID Server] ✅ ChannelRepositoryService initialized');

  // 2. Initialize MPX SDK (depends on wallet, keyRepo, channelRepo)
  await MpxSdkService.init();
  print('[DID Server] ✅ MpxSdkService initialized');

  // 4. Initialize Verifier Client Service (this will call setupClient to create connections)
  await VerifierClientService.init();
  print('[DID Server] ✅ VerifierClientService initialized');

  print('[DID Server] All services initialized successfully');
  // Create router
  final router = Router();

  // Health check endpoint
  router.get('/health', healthHandler);

  // CORS proxy endpoint for external DID resolution
  // router.get('/api/cors-proxy', corsProxyHandler);
  // router.options('/api/cors-proxy', corsProxyOptionsHandler);

  // Credential verification endpoint
  router.post('/api/verify', verifyHandler);

  // DCQL request
  // router.post('/api/dcql/request', dcqlRequestHandler);

  // OOB clients list
  router.get('/api/oob/client', getOobClientHandler);

  // Connection management
  // router.post('/api/connection-stop', connectionStopHandler);

  router.get(
    '/ws',
    webSocketHandler((webSocket, shelfRequest) {
      // Initialize the list if it doesn't exist

      // Add this socket to the list
      activeSockets.add(webSocket);
      final totalConnections = activeSockets.length;

      print('WebSocket connected (total: $totalConnections)');

      webSocket.stream.listen(
        (message) {
          // Handle ping messages
          if (message is String) {
            try {
              final parsed = jsonDecode(message);
              if (parsed['type'] == 'ping') {
                // Respond with pong
                webSocket.sink.add(
                  jsonEncode({
                    'type': 'pong',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  }),
                );
                return;
              }
            } catch (_) {
              // Not JSON or not a ping, process normally
            }
          }
          print('Message received: $message');
        },
        onDone: () {
          print('WebSocket closed');
          // Remove this specific socket from the list
          activeSockets.remove(webSocket);

          // Clean up empty list
          // if (activeSockets?.isEmpty ?? false) {
          //   MpxClient.activeSockets.remove(clientId);
          //   print('All WebSocket connections closed');
          // } else {
          //   print(
          //     'Remaining connections: ${MpxClient.activeSockets?.length ?? 0}',
          //   );
          // }
        },
        onError: (err) {
          print('WebSocket error: $err');
          // Remove this specific socket from the list
          activeSockets.remove(webSocket);

          // Clean up empty list
          // if (activeSockets?.isEmpty ?? false) {
          //   MpxClient.activeSockets.remove(clientId);
          // }
        },
      );
    }),
  );

  // CORS middleware to handle all OPTIONS requests
  Middleware corsMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok(
            '',
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers':
                  'Origin, Content-Type, Accept, Authorization',
            },
          );
        }

        final response = await handler(request);
        return response.change(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept, Authorization',
          },
        );
      };
    };
  }

  // Build middleware pipeline
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  // Get port from environment
  final port = int.tryParse(AppConfig.port) ?? 4000;

  // Start server
  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print(
    '🚀 Backend API Server listening on http://${server.address.host}:${server.port}',
  );
  // print('📄 DID document available at: $didPath');
  // print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}
