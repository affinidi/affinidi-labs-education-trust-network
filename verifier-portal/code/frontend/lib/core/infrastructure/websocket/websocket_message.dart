import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_message.freezed.dart';
part 'websocket_message.g.dart';

/// Base WebSocket message model
@freezed
class WebSocketMessage with _$WebSocketMessage {
  const factory WebSocketMessage({
    required String type,
    String? message,
    int? timestamp,
    Map<String, dynamic>? data,
  }) = _WebSocketMessage;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
}

/// Specific message types for better type safety

/// OOB URL refreshed message
@freezed
class OobUrlRefreshedMessage with _$OobUrlRefreshedMessage {
  const factory OobUrlRefreshedMessage({
    required String type,
    required String oobUrl,
    required String message,
  }) = _OobUrlRefreshedMessage;

  factory OobUrlRefreshedMessage.fromJson(Map<String, dynamic> json) =>
      _$OobUrlRefreshedMessageFromJson(json);
}

/// VDSP Response message
@freezed
class VdspResponseMessage with _$VdspResponseMessage {
  const factory VdspResponseMessage({
    required String status, // 'success' or 'failure'
    required bool completed,
    required String channelDid,
    required String message,
    required bool presentationAndCredentialsAreValid,
  }) = _VdspResponseMessage;

  factory VdspResponseMessage.fromJson(Map<String, dynamic> json) =>
      _$VdspResponseMessageFromJson(json);
}

/// Connection state enum
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}
