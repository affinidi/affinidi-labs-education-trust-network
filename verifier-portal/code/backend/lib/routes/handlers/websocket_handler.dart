// import 'dart:convert';
// import 'package:riverpod/riverpod.dart';
// import 'package:shelf/shelf.dart';
// import '../../features/mpx/data/mpx_client/mpx_client.service.dart';

// Future<Response> Function(Request) webSocketHandler(
//   webSocket,
//   Request? shelfRequest,
//   ProviderContainer container,
// ) async {
//   // Extract clientId from query parameters
//   final clientId = shelfRequest?.url.queryParameters['clientId'];

//   if (clientId == null || clientId.isEmpty) {
//     print('WebSocket connection rejected: missing clientId parameter');
//     webSocket.sink.close(1008, 'Missing clientId parameter');
//     return Response.badRequest(
//       body: jsonEncode({
//         'error': 'WebSocket connection rejected: missing clientId parameter',
//         'message': 'Missing clientId parameter',
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );
//   }

//   // Get MpxClient from provider
//   final mpxClient = await container.read(mpxClientProvider.future);

//   // Initialize the list if it doesn't exist
//   if (!mpxClient.activeSockets.containsKey(clientId)) {
//     mpxClient.activeSockets[clientId] = [];
//   }

//   // Add this socket to the list
//   mpxClient.activeSockets[clientId]!.add(webSocket);
//   final totalConnections = mpxClient.activeSockets[clientId]!.length;

//   print('WebSocket connected for $clientId (total: $totalConnections)');

//   webSocket.stream.listen(
//     (message) {
//       // Handle ping messages
//       if (message is String) {
//         try {
//           final parsed = jsonDecode(message);
//           if (parsed['type'] == 'ping') {
//             // Respond with pong
//             webSocket.sink.add(
//               jsonEncode({
//                 'type': 'pong',
//                 'timestamp': DateTime.now().millisecondsSinceEpoch,
//               }),
//             );
//             return;
//           }
//         } catch (_) {
//           // Not JSON or not a ping, process normally
//         }
//       }
//       print('[$clientId] Message received: $message');
//     },
//     onDone: () {
//       print('WebSocket closed for $clientId');
//       // Remove this specific socket from the list
//       mpxClient.activeSockets[clientId]?.remove(webSocket);

//       // Clean up empty list
//       if (mpxClient.activeSockets[clientId]?.isEmpty ?? false) {
//         mpxClient.activeSockets.remove(clientId);
//         print('All WebSocket connections closed for $clientId');
//       } else {
//         print(
//           'Remaining connections for $clientId: ${mpxClient.activeSockets[clientId]?.length ?? 0}',
//         );
//       }
//     },
//     onError: (err) {
//       print('WebSocket error for $clientId: $err');
//       // Remove this specific socket from the list
//       mpxClient.activeSockets[clientId]?.remove(webSocket);

//       // Clean up empty list
//       if (mpxClient.activeSockets[clientId]?.isEmpty ?? false) {
//         mpxClient.activeSockets.remove(clientId);
//       }
//     },
//   );
//   return Response.ok(
//     jsonEncode({}),
//     headers: {'Content-Type': 'application/json'},
//   );
// }
