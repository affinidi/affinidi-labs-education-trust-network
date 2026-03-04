# Setup Guide

## Prerequisites

**System Requirements:**

- 8GB RAM minimum (16GB recommended)
- 4 CPU cores minimum
- 10GB free disk space
- macOS, Linux, or Windows (with WSL2 for Windows)

**Software:**

- Docker Desktop 4.0+ & Docker Compose 2.0+
- Flutter SDK 3.5.0+
- Dart SDK 3.5.0+
- Rust 1.70+ (for trust registry development)
- ngrok account (free tier works) - [Get it here](https://dashboard.ngrok.com/signup)
- Git

## Quick Start

```bash
# Clone repository
git clone <repository>
cd affinidi-labs-education-trust-network

# Start complete environment (ngrok tunnels + Docker)
make dev-up

# In separate terminals, start the apps:
make hk-gov          # HK Governance Portal
make macau-gov       # Macau Governance Portal
make sg-gov          # Singapore Governance Portal
make verifier        # Nova Corp Verifier
make student-ios     # Student Vault App (iOS)
```

The `make dev-up` command will:

1. Start ngrok tunnels for universities and education ministries
2. Capture dynamic ngrok domains
3. Generate all configurations and DIDs
4. Launch Docker containers (Trust Registries, Universities, etc.)

## Component Setup

### Governance Portal

```bash
cd governance-portal/code

# Install dependencies
flutter pub get

# Configure DID
cp assets/user_config.json.example assets/user_config.json
# Edit user_config.json with your did:peer and private keys

# Create .env file per instance
cd ../instances/hk-ministry
cp .env.example .env
# Edit .env with your configuration

# Run
flutter run -d chrome
```

### University Issuance Services

```bash
cd university-issuance-service/code

# Install dependencies
dart pub get

# Configure per instance
cd ../instances/hk-university
cp .env.example .env
# Edit .env

# Run
dart run bin/server.dart
```

### Student Vault App

```bash
cd student-vault-app/code

# Install dependencies
flutter pub get

# Configure
cp configurations/organizations.dart.example lib/configurations/organizations.dart
# Edit with your issuers/verifiers

# Run
flutter run
```

## Configuration Files

### user_config.json (Trust Registry)

Contains did:peer and private keys. Format:

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

### Environment Variables

Each component requires `.env` file with:

- DID configuration (ADMIN_DID, REGISTRY_DID, MEDIATOR_DID/URL)
- Service endpoints
- Instance-specific settings

## Ports

| Service                     | Port | Run On   |
| --------------------------- | ---- | -------- |
| HK University Issuer        | 3000 | Docker   |
| Macau University Issuer     | 3001 | Docker   |
| HK Trust Registry           | 3232 | Docker   |
| Macau Trust Registry        | 3233 | Docker   |
| Singapore Trust Registry    | 3234 | Docker   |
| Nova Corp Verifier          | 4000 | Terminal |
| HK Governance Portal        | 8050 | Terminal |
| Macau Governance Portal     | 8051 | Terminal |
| Singapore Governance Portal | 8052 | Terminal |

## Troubleshooting

### Governance Portal won't start

- Verify `user_config.json` exists and has valid did:peer
- Check private keys are correctly formatted

### DIDComm messages fail

- Verify mediator URL is accessible
- Check DID configuration matches between services
- Ensure user_config.json keys match did:peer DID

### Flutter build errors

```bash
flutter clean
flutter pub get
```
