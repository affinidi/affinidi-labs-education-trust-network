import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Global state for MPX operations
final requestIds = <String, String>{};
final vdspClients = <String, VdspVerifier>{};
final activeSockets = <WebSocketChannel>[];
