# WebSocket Handler Documentation

## Overview

The WebSocket handler provides real-time communication between the Flutter frontend and Dart backend server. It includes:

- **Auto-connect on app start**
- **Automatic reconnection with exponential backoff**
- **Ping/pong keep-alive mechanism**
- **Type-safe message handling**
- **Riverpod state management integration**

## Architecture

### Files Created

```
lib/core/infrastructure/websocket/
├── websocket_message.dart          # Message models with Freezed
├── websocket_service.dart          # Core WebSocket service
├── websocket_provider.dart         # Riverpod providers
└── widgets/
    └── websocket_widgets.dart      # UI widgets for WebSocket status
```

## Message Types

### 1. OOB URL Refreshed
```dart
{
  "type": "oob-url-refreshed",
  "oobUrl": "https://...",
  "message": "OOB URL has been refreshed for Client Name"
}
```

### 2. VDSP Response
```dart
{
  "type": "vdsp-response",
  "status": "success",  // or "failure"
  "completed": true,
  "channel_did": "did:...",
  "message": "Access Granted. Welcome to...",
  "presentationAndCredentialsAreValid": true
}
```

### 3. Ping/Pong
```dart
// Sent from frontend every 30 seconds
{ "type": "ping", "timestamp": 1234567890 }

// Backend responds with
{ "type": "pong", "timestamp": 1234567890 }
```

## Usage

### 1. Basic Setup (Already Auto-connects)

The WebSocket automatically connects when the app starts. Just wrap your app with Riverpod:

```dart
void main() async {
  await AppConfig.loadEnvironment();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. Display Connection Status

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/infrastructure/websocket/widgets/websocket_widgets.dart';

class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Shows connection status with icon
          WebSocketStatusWidget(),
          
          // Your other content
        ],
      ),
    );
  }
}
```

### 3. Listen for OOB URL Updates

```dart
import 'core/infrastructure/websocket/widgets/websocket_widgets.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OobUrlListener(
      child: MaterialApp(
        // Your app content
      ),
    );
  }
}
```

### 4. Listen for VDSP Responses

```dart
class VerificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VdspResponseListener(
      onResponse: (message) {
        // Custom handling
        print('Received VDSP response: ${message.status}');
      },
      child: Scaffold(
        // Your screen content
      ),
    );
  }
}
```

### 5. Manual Connection Management

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsService = ref.watch(webSocketServiceProvider);
    final isConnected = ref.watch(isWebSocketConnectedProvider);
    
    return Column(
      children: [
        Text(isConnected ? 'Connected' : 'Disconnected'),
        
        ElevatedButton(
          onPressed: () => wsService.connect(),
          child: Text('Connect'),
        ),
        
        ElevatedButton(
          onPressed: () => wsService.disconnect(),
          child: Text('Disconnect'),
        ),
      ],
    );
  }
}
```

### 6. Listen to Raw Messages

```dart
class DebugScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesStream = ref.watch(webSocketMessageStreamProvider);
    
    return messagesStream.when(
      data: (message) => Text('Last: ${message.type}'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

### 7. Send Custom Messages

```dart
class CustomMessageSender extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsService = ref.watch(webSocketServiceProvider);
    
    return ElevatedButton(
      onPressed: () {
        wsService.sendMessage({
          'type': 'custom-action',
          'data': {'key': 'value'},
        });
      },
      child: Text('Send Message'),
    );
  }
}
```

## Features

### Auto-Reconnect
- Exponential backoff: 2s, 4s, 8s, 16s, up to 30s
- Automatically retries on connection loss
- No manual intervention needed

### Keep-Alive
- Sends ping every 30 seconds
- Backend responds with pong
- Maintains connection stability

### Connection States
- `disconnected` - Not connected
- `connecting` - Attempting connection
- `connected` - Active connection
- `reconnecting` - Attempting to reconnect
- `error` - Connection error occurred

## Configuration

WebSocket URL is derived from `BACKEND_API` in your `.env` file:
- `http://localhost:4001/` → `ws://localhost:4001/ws`
- `https://example.com/api/` → `wss://example.com/api/ws`

## Troubleshooting

### Connection Fails
1. Ensure backend is running on port 4001
2. Check `BACKEND_API` in `.env` file
3. Verify WebSocket endpoint is `/ws`

### Messages Not Received
1. Check connection state is `connected`
2. Verify backend is broadcasting messages
3. Check console for parsing errors

### Auto-Reconnect Not Working
1. Connection state should show `reconnecting`
2. Check console for reconnect attempts
3. Verify backend accepts connections

## Next Steps

1. **Run code generation** for Freezed models:
   ```bash
   cd frontend
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Update app.dart** to wrap with listeners:
   ```dart
   return OobUrlListener(
     child: VdspResponseListener(
       child: MaterialApp(...),
     ),
   );
   ```

3. **Add status widget** to your main screen to monitor connection

4. **Test the connection** by starting both backend and frontend
