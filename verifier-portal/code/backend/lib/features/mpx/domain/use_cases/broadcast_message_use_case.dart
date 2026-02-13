import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class BroadcastMessageUseCase {
  final List<WebSocketChannel> activeSockets;

  BroadcastMessageUseCase(this.activeSockets);

  void call(String clientId, Map<String, dynamic> message) {
    try {
      if (activeSockets.isEmpty) {
        print(
          'Cannot broadcast, as there are no active activeSockets for $clientId',
        );
        return;
      }

      final jsonMessage = jsonEncode(message);
      print(
        'Broadcasting to $clientId (${activeSockets.length} connection${activeSockets.length > 1 ? 's' : ''}): ${message['message']}',
      );

      // Send to all connected activeSockets and remove any that fail
      final socketsToRemove = <WebSocketChannel>[];

      for (final socket in activeSockets) {
        try {
          socket.sink.add(jsonMessage);
        } catch (e) {
          print('Failed to send to a socket for $clientId: $e');
          socketsToRemove.add(socket);
        }
      }

      // Clean up failed activeSockets
      if (socketsToRemove.isNotEmpty) {
        activeSockets.removeWhere((s) => socketsToRemove.contains(s));
        print('Removed ${socketsToRemove.length} dead socket(s) for $clientId');
      }

      // Remove the list if empty
      if (activeSockets.isEmpty) {
        activeSockets.clear();
      }
    } catch (e) {
      print('Broadcast error for $clientId: $e');
    }
  }
}
