import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';
import 'websocket_message.dart';

/// Service to manage WebSocket connection with auto-reconnect
class WebSocketService {
  static WebSocketService? _instance;
  static WebSocketService get instance {
    _instance ??= WebSocketService._();
    return _instance!;
  }

  WebSocketService._();

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectDelay = 30; // Max 30 seconds between retries
  static const Duration _pingInterval = Duration(seconds: 30);

  // Stream controllers for different message types
  final _messageController = StreamController<String>.broadcast();
  // final _oobUrlController =
  //     StreamController<OobUrlRefreshedMessage>.broadcast();
  // final _vdspResponseController =
  //     StreamController<VdspResponseMessage>.broadcast();
  // final _connectionStateController =
  //     StreamController<WebSocketConnectionState>.broadcast();

  // Public streams
  Stream<String> get messageStream => _messageController.stream;
  // Stream<OobUrlRefreshedMessage> get oobUrlStream => _oobUrlController.stream;
  // Stream<VdspResponseMessage> get vdspResponseStream =>
  //     _vdspResponseController.stream;
  // Stream<WebSocketConnectionState> get connectionStateStream =>
  //     _connectionStateController.stream;

  // Current connection state
  WebSocketConnectionState _connectionState =
      WebSocketConnectionState.disconnected;
  WebSocketConnectionState get connectionState => _connectionState;

  /// Get WebSocket URL from backend API URL
  String _getWebSocketUrl() {
    final backendUrl = AppConfig.backendApi;
    // Convert http://localhost:4001/ to ws://localhost:4001/ws
    final uri = Uri.parse(backendUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return '$wsScheme://${uri.host}:${uri.port}/ws';
  }

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_connectionState == WebSocketConnectionState.connected ||
        _connectionState == WebSocketConnectionState.connecting) {
      debugPrint('[WebSocket] Already connected or connecting');
      return;
    }

    try {
      _updateConnectionState(WebSocketConnectionState.connecting);
      final wsUrl = _getWebSocketUrl();
      debugPrint('[WebSocket] Connecting to $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Wait for connection to be established
      await _channel!.ready;

      _updateConnectionState(WebSocketConnectionState.connected);
      _reconnectAttempts =
          0; // Reset reconnect attempts on successful connection
      debugPrint('[WebSocket] ✅ Connected successfully');

      // Start ping timer to keep connection alive
      _startPingTimer();

      // Listen to messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('[WebSocket] ❌ Connection failed: $e');
      _updateConnectionState(WebSocketConnectionState.error);
      _scheduleReconnect();
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      if (message is! String) {
        debugPrint('[WebSocket] Received non-string message: $message');
        return;
      }

      // final json = jsonDecode(message) as Map<String, dynamic>;
      // final wsMessage = WebSocketMessage.fromJson(json);

      // debugPrint('[WebSocket] 📨 Received: ${wsMessage.type}');

      // // Emit to general message stream
      if (message == "Pong") {
        debugPrint('[WebSocket] 🏓 Pong received');
        return; // Ignore pong messages
      } else if (message == "Ping") {
        debugPrint('[WebSocket] 🏓 Ping received');
        return; // Ignore pong messages
      } else {
        _messageController.add(message);
      }
      // // Handle specific message types
      // switch (wsMessage.type) {
      //   case 'pong':
      //     // Pong received, connection is alive
      //     break;

      //   case 'oob-url-refreshed':
      //     try {
      //       final oobMessage = OobUrlRefreshedMessage.fromJson(json);
      //       _oobUrlController.add(oobMessage);
      //       debugPrint(
      //         '[WebSocket] 🔄 OOB URL refreshed: ${oobMessage.oobUrl}',
      //       );
      //     } catch (e) {
      //       debugPrint('[WebSocket] Error parsing oob-url-refreshed: $e');
      //     }
      //     break;

      //   case 'vdsp-response':
      //     try {
      //       final vdspMessage = VdspResponseMessage.fromJson(json);
      //       _vdspResponseController.add(vdspMessage);
      //       debugPrint(
      //         '[WebSocket] ✅ VDSP Response: ${vdspMessage.status} - ${vdspMessage.message}',
      //       );
      //     } catch (e) {
      //       debugPrint('[WebSocket] Error parsing vdsp-response: $e');
      //     }
      //     break;

      //   default:
      //     debugPrint('[WebSocket] Unknown message type: ${wsMessage.type}');
      // }
    } catch (e) {
      debugPrint('[WebSocket] Error handling message: $e');
    }
  }

  // / Handle WebSocket errors
  void _handleError(error) {
    debugPrint('[WebSocket] ❌ Error: $error');
    _updateConnectionState(WebSocketConnectionState.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    debugPrint('[WebSocket] 🔌 Disconnected');
    _updateConnectionState(WebSocketConnectionState.disconnected);
    _stopPingTimer();
    _scheduleReconnect();
  }

  /// Schedule a reconnection attempt with exponential backoff
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();

    if (_connectionState == WebSocketConnectionState.connected) {
      return; // Don't reconnect if already connected
    }

    _reconnectAttempts++;
    // Exponential backoff: 1s, 2s, 4s, 8s, 16s, 30s (max)
    final delay = (_reconnectAttempts * 2).clamp(1, _maxReconnectDelay);

    debugPrint(
      '[WebSocket] 🔄 Reconnecting in $delay seconds (attempt $_reconnectAttempts)...',
    );

    _updateConnectionState(WebSocketConnectionState.reconnecting);

    _reconnectTimer = Timer(Duration(seconds: delay), () {
      connect();
    });
  }

  /// Start ping timer to keep connection alive
  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_connectionState == WebSocketConnectionState.connected) {
        _sendPing();
      }
    });
  }

  /// Stop ping timer
  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  /// Send ping message to keep connection alive
  void _sendPing() {
    try {
      final pingMessage = jsonEncode({
        'type': 'ping',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _channel?.sink.add(pingMessage);
      debugPrint('[WebSocket] 🏓 Ping sent');
    } catch (e) {
      debugPrint('[WebSocket] Error sending ping: $e');
    }
  }

  /// Send a custom message to the server
  void sendMessage(Map<String, dynamic> message) {
    if (_connectionState != WebSocketConnectionState.connected) {
      debugPrint('[WebSocket] Cannot send message - not connected');
      return;
    }

    try {
      final jsonMessage = jsonEncode(message);
      _channel?.sink.add(jsonMessage);
      debugPrint('[WebSocket] 📤 Sent: ${message['type']}');
    } catch (e) {
      debugPrint('[WebSocket] Error sending message: $e');
    }
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(WebSocketConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      // _connectionStateController.add(newState);
      debugPrint('[WebSocket] State changed: $newState');
    }
  }

  /// Disconnect and cleanup
  Future<void> disconnect() async {
    debugPrint('[WebSocket] Disconnecting...');
    _reconnectTimer?.cancel();
    _stopPingTimer();
    await _channel?.sink.close();
    _channel = null;
    _updateConnectionState(WebSocketConnectionState.disconnected);
  }

  /// Dispose and cleanup all resources
  void dispose() {
    disconnect();
    _messageController.close();
    // _oobUrlController.close();
    // _vdspResponseController.close();
    // _connectionStateController.close();
    _instance = null;
  }
}
