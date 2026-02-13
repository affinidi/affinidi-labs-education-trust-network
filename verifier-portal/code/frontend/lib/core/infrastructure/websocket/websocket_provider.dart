import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'websocket_message.dart';
import 'websocket_service.dart';

/// Provider for WebSocket service instance
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService.instance;

  // Auto-connect when provider is first accessed
  service.connect();

  // Cleanup on dispose
  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});

/// Provider for WebSocket connection state
// final webSocketConnectionStateProvider =
//     StreamProvider<WebSocketConnectionState>((ref) {
//       final service = ref.watch(webSocketServiceProvider);
//       return service.connectionStateStream;
//     });

/// Provider for all WebSocket messages
final webSocketMessageStreamProvider = StreamProvider<String>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.messageStream;
});

/// Provider for OOB URL refresh messages
// final oobUrlRefreshStreamProvider = StreamProvider<OobUrlRefreshedMessage>((
//   ref,
// ) {
//   final service = ref.watch(webSocketServiceProvider);
//   return service.oobUrlStream;
// });

// /// Provider for VDSP response messages
// final vdspResponseStreamProvider = StreamProvider<VdspResponseMessage>((ref) {
//   final service = ref.watch(webSocketServiceProvider);
//   return service.vdspResponseStream;
// });

// /// Provider to check if WebSocket is connected
// final isWebSocketConnectedProvider = Provider<bool>((ref) {
//   final connectionState = ref.watch(webSocketConnectionStateProvider);
//   return connectionState.valueOrNull == WebSocketConnectionState.connected;
// });
