# DIDComm Protocol Implementation

## Overview

All components use DIDComm v2.1 for secure, authenticated communication.

## Protocols Used

### VDIP (Verifiable Data Issuance Protocol)
**Purpose**: Issue credentials from issuer to wallet

**Message Types:**
- `https://affinidi.com/vdip/1.0/request-credential`
- `https://affinidi.com/vdip/1.0/issue-credential`

**Flow:**
```
Wallet → request-credential → Issuer
Issuer → issue-credential → Wallet
```

### Trust Registry Admin Protocol (tr-admin/1.0)
**Purpose**: Manage trust registry records

**Message Types:**
- `tr-admin/1.0/create-record`
- `tr-admin/1.0/update-record`
- `tr-admin/1.0/delete-record`
- `tr-admin/1.0/read-record`
- `tr-admin/1.0/list-records`

**Flow:**
```
Portal → request → Mediator → Registry
Registry → response → Mediator → Portal
```

## Message Structure

### Plain Text Message
```dart
PlainTextMessage(
  id: '550e8400-e29b-41d4-a716-446655440000',
  type: Uri.parse('tr-admin/1.0/create-record'),
  from: 'did:peer:2.Vz6Mk...',
  to: ['did:peer:2.Vz6Mk...'],
  body: {
    'data': {...}
  },
  createdTime: DateTime.now(),
  expiresTime: DateTime.now().add(Duration(minutes: 5)),
)
```

### Response Message
- Uses same `id` in `threadId` field
- Message type: `{request-type}/response`
- Body contains result or error

## Message Correlation

Request-response correlation uses message IDs:

```dart
// Send request
final messageId = uuid.v4();
pendingRequests[messageId] = Completer();

// Receive response
final threadId = response.threadId;
if (pendingRequests.containsKey(threadId)) {
  pendingRequests[threadId].complete(response);
}
```

**Timeout**: 30 seconds (configurable)

## Key Management

### Configuration File: user_config.json

```json
{
  "did:peer:2.Vz6Mk...": {
    "alias": "AdminAPI",
    "secrets": [
      {
        "id": "did:peer:2.Vz6Mk...#key-1",
        "type": "JsonWebKey2020",
        "privateKeyJwk": {
          "kty": "EC",
          "crv": "P-256",
          "x": "...",
          "y": "...",
          "d": "..."
        }
      }
    ]
  }
}
```

### Supported Key Types

| JWK kty | JWK crv     | Use Case      |
|---------|-------------|---------------|
| OKP     | Ed25519     | Signing       |
| OKP     | X25519      | Key agreement |
| EC      | secp256k1   | Signing       |
| EC      | P-256       | Signing       |
| EC      | P-384       | Signing       |
| EC      | P-521       | Signing       |

### Implementation: Dart

```dart
// Load configuration
final userConfig = await UserConfig.loadFromFile('assets/user_config.json');

// Import keys into keystore
final loader = DidManagerLoader();
final result = await loader.loadFromConfig(userConfig);

// Create DID manager
final didManager = result.didManager; // DidPeerManager
```

### Implementation: Rust

```rust
// Load configuration
let profile = TDKProfile::new("conf/user_config.json");

// Keys managed automatically by TDK
```

## Mediator Integration

### Configuration
- **Mediator URL**: `https://apse1.mediator.affinidi.io/`
- **Protocol**: DIDComm v2
- **Features**: Message routing, queuing

### Client Initialization (Dart)

```dart
final mediatorClient = await DidcommMediatorClient.init(
  didManager: didManager,
  ariesMediatorUrl: mediatorUrl,
);
```

### Sending Messages

```dart
await mediatorClient.packAndSendMessage(
  message: plainTextMessage,
  to: recipientDid,
  from: senderDid,
);
```

### Receiving Messages

```dart
mediatorClient.listenForMessages().listen((message) {
  // Handle incoming message
  final threadId = message.threadId;
  // Match with pending request
});
```

## Error Handling

### Message Errors
- **Timeout**: Request exceeds 30s without response
- **Invalid DID**: DID format validation fails
- **Missing Keys**: Required key not found in keystore
- **Encryption Failure**: Message encryption/decryption fails

### Error Response Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid record format"
  }
}
```

## Security Considerations

### Message Security
- All messages encrypted with recipient's public key
- Messages signed with sender's private key
- Message expiry enforced (5 minutes default)

### DID Validation
- Verify DID format before use
- Check DID resolution
- Validate key relationships

### Key Storage
- Private keys in `user_config.json` (gitignored)
- Use different keys per environment
- Rotate keys periodically

## Debugging

### Enable Logging

```dart
Logger.level = Level.debug;
```

### Common Issues

**Messages not delivered:**
- Check mediator URL is accessible
- Verify recipient DID is correct
- Ensure keys are properly imported

**Timeout errors:**
- Increase timeout if needed
- Check network connectivity
- Verify mediator is operational

**Signature verification fails:**
- Ensure correct private key loaded
- Verify DID matches key in user_config.json
- Check key type matches DID method
