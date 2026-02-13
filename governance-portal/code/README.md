# Governance Portal - Code

Shared Flutter Web codebase for all Governance Portal instances.

## Setup

```bash
# Install dependencies
flutter pub get

# Configure DID
cp assets/user_config.json.example assets/user_config.json
# Edit with your did:peer and private keys

# Run (port 3401)
flutter run -d chrome --web-port=3401
```

## Configuration

### user_config.json
```json
{
  "did:peer:2.Vz6Mk...": {
    "alias": "AdminAPI",
    "secrets": [{
      "id": "did:peer:2.Vz6Mk...#key-1",
      "type": "JsonWebKey2020",
      "privateKeyJwk": { "kty": "EC", "crv": "P-256", ... }
    }]
  }
}
```

### .env (per instance)
```env
MINISTRY_NAME=Hong Kong Education Bureau
TRUST_REGISTRY_DID=did:peer:2.Vz6Mk...
MEDIATOR_DID=did:peer:2.Vz6Mk...
MEDIATOR_URL=https://apse1.mediator.affinidi.io/
```

## Architecture

Clean Architecture with DIDComm client:
- `lib/features/records/` - Trust record CRUD
- `lib/core/infrastructure/didcomm/` - DIDComm client
- `lib/core/infrastructure/config/` - User config & DID loading

## Documentation

See [Project Documentation](../../docs/):
- [Trust Registry Details](../../docs/trust-registry.md)
- [DIDComm Protocol](../../docs/didcomm-protocol.md)
- [Development Guide](../../docs/development.md)


## Architecture

This application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                          # Core infrastructure
│   ├── domain/
│   │   └── exceptions/           # Exception classes
│   ├── infrastructure/
│   │   ├── config/               # Environment-based configuration
│   │   └── didcomm/              # DIDComm client and protocol
│   └── navigation/               # GoRouter configuration
│
└── features/                      # Feature-based modules
    ├── dashboard/                # Dashboard feature
    │   └── presentation/
    │       ├── providers/        # Riverpod state providers
    │       ├── screens/          # Dashboard screen
    │       └── widgets/          # Reusable widgets
    │
    ├── records/                  # Trust records CRUD
    │   ├── domain/
    │   │   ├── entities/         # TrustRecord entity
    │   │   ├── repositories/     # Repository interfaces
    │   │   └── usecases/         # Business logic
    │   ├── data/
    │   │   ├── models/           # Data transfer objects
    │   │   ├── datasources/      # DIDComm data source
    │   │   └── repositories/     # Repository implementations
    │   └── presentation/
    │       ├── providers/        # Riverpod providers
    │       ├── screens/          # List and form screens
    │       └── widgets/          # Record cards and forms
    │
    └── query/                    # TRQP query testing
        └── presentation/
            ├── providers/        # Query state management
            ├── screens/          # Query test screen
            └── widgets/          # Query form and results
```

## Key Features

- **Direct DIDComm Communication**: Communicates directly with cloud-hosted Trust Registry via DIDComm v2 protocol
- **No REST API Layer**: Eliminates unnecessary network hops by implementing DIDComm directly in Flutter
- **Clean Architecture**: Clear separation between domain, data, and presentation layers
- **Riverpod State Management**: Modern, compile-safe state management
- **Exception-based Error Handling**: Simple try-catch blocks instead of Result<T,E> pattern
- **Environment-based Configuration**: Per-ministry instance configuration via environment variables

## DIDComm Protocol

Uses **Trust Registry Admin Protocol (tr-admin/1.0)** with message types:

- `https://affinidi.com/trust-registry/1.0/admin/create-record`
- `https://affinidi.com/trust-registry/1.0/admin/update-record`
- `https://affinidi.com/trust-registry/1.0/admin/delete-record`
- `https://affinidi.com/trust-registry/1.0/admin/read-record`
- `https://affinidi.com/trust-registry/1.0/admin/list-records`

## Configuration

### User Configuration (user_config.json)

The application requires a `user_config.json` file containing the DID and private keys for authentication:

**Location**: `assets/user_config.json`

**Format** (same as Rust trust-registry-admin-rest-api-rs):
```json
{
  "did:peer:2.Vz6Mk...": {
    "alias": "AdminAPI",
    "secrets": [
      {
        "id": "did:peer:2.Vz6Mk...#key-1",
        "type": "JsonWebKey2020",
        "privateKeyJwk": {
          "kty": "OKP",
          "crv": "Ed25519",
          "x": "...",
          "d": "..."
        }
      }
    ]
  }
}
```

**Supported Key Types**:
- Ed25519 (OKP with crv=Ed25519)
- X25519 (OKP with crv=X25519)
- secp256k1 (EC with crv=secp256k1)
- P-256/P-384/P-521 (EC with crv=P-256/P-384/P-521)

**Important**:
- The app will **fail to start** if `user_config.json` is missing or invalid
- Copy `assets/user_config.json.example` and customize with your DID/keys
- Keep the actual `user_config.json` secure and **never commit to git**
- Use the same DID/keys as your Rust admin API for interoperability

### Environment Variables

Create a `.env` file in `code/` directory:

```env
# Ministry Configuration
MINISTRY_NAME=Hong Kong Education Bureau

# DID Configuration
ADMIN_DID=did:key:z6Mk...
TRUST_REGISTRY_DID=did:key:z6Mk...
MEDIATOR_DID=did:key:z6Mk...
MEDIATOR_URL=https://mediator.affinidi.io

# Storage Paths
KEY_STORE_PATH=./keys
DATA_PATH=./data

# Timeouts
RESPONSE_TIMEOUT_SECONDS=30
```

## Setup & Run

### Prerequisites
- Flutter SDK 3.5.0+
- Dart SDK 3.5.0+

### Installation
```bash
cd code
flutter pub get
```

### Configuration Setup

1. **Copy user_config.json.example**:
   ```bash
   cp assets/user_config.json.example assets/user_config.json
   ```

2. **Update with your DID and keys**:
   - Open `assets/user_config.json`
   - Replace with your did:peer DID
   - Add your private keys (Ed25519, secp256k1, etc.)
   - Set appropriate alias

3. **Create .env file** with your environment configuration:
   ```env
   MINISTRY_NAME=Hong Kong Education Bureau
   TRUST_REGISTRY_DID=did:key:z6Mk...
   MEDIATOR_DID=did:key:z6Mk...
   MEDIATOR_URL=https://mediator.affinidi.io
   RESPONSE_TIMEOUT_SECONDS=30
   ```

### Run
```bash
# Run on web (port 3401)
flutter run -d chrome --web-port=3401

# Or use VS Code launch configuration (F5)
```

## Error Handling

All operations use exception-based error handling:

```dart
try {
  final record = await createRecordUseCase(newRecord);
} catch (e) {
  if (e is ValidationException) {
    // Show validation errors
  } else if (e is DIDCommException) {
    // Show communication errors  
  }
}
```

## Deployment

```bash
flutter build web --release
```

## License

See parent project license.
