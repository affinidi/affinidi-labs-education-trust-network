# University Issuance Service

Dart backend service for issuing educational credentials to students using DIDComm v2 and VDIP protocol.

## 🚀 Quick Start

### Setup

```bash
# From project root, run main setup to start all services
make dev-up
```

The universities are automatically started in Docker. To run them locally instead:

```bash
# Run HK University (Port 3000)
make hk-university

# Run Macau University (Port 3001)
make macau-university
```

**Available Make Commands (from root):**
- `make hk-university` - Start HK University Issuer (local Dart)
- `make macau-university` - Start Macau University Issuer (local Dart)
- `make docker-logs-hk` - View HK University logs
- `make docker-logs-macau` - View Macau University logs

## 🏗️ Architecture

**MVC Pattern:**
- **Controllers**: HTTP request handlers, route definitions
- **Services**: Business logic (credential issuance, DIDComm communication)
- **Models**: Data structures, credential schemas
- **Utilities**: Helper functions, configuration management

**Communication Flow:**
1. Student scans QR code from issuer portal
2. Student app initiates DIDComm connection
3. Service issues credential via VDIP protocol
4. Credential delivered to student's wallet

## 🔧 Configuration

Each university instance requires environment configuration:

**Example (.env.hk.localhost):**
```env
PORT=3000
UNIVERSITY_NAME=Hong Kong University
UNIVERSITY_DID=did:web:localhost%3A3000:hongkong-university
UNIVERSITY_DOMAIN=localhost:3000/hongkong-university

# Affinidi Services
SERVICE_DID=did:web:...
MEDIATOR_DID=did:web:...
MEDIATOR_URL=https://...

# Trust Registry
TRUST_REGISTRY_DID=did:web:...
TRUST_REGISTRY_URL=https://...

# Storage
STORAGE_BACKEND=file
DATA_PATH=./data

# Credentials
ISSUER_KEY_PATH=./keys/issuer-key.json
ISSUER_DIDWEB_DOMAIN=localhost:3000/hongkong-university
```

## 📍 Instances

| University | Port (Localhost) | Port (Ngrok) | DID |
|------------|------------------|--------------|-----|
| Hong Kong | 3000 | 3301 | did:web:localhost%3A3000:hongkong-university |
| Macau | 3001 | 3302 | did:web:localhost%3A3001:macau-university |

## 🔑 Key Features

- **Multi-instance Architecture**: Single codebase, multiple university instances
- **DIDComm v2**: Secure peer-to-peer communication
- **VDIP Protocol**: Verifiable Data Issuance Protocol
- **Trust Registry Integration**: Validates issuers before credential issuance
- **Flexible Storage**: Support for file-based or Redis storage

## 📚 Documentation

- [Main Project README](../README.md)
- [Localhost Setup Guide](../LOCALHOST_SETUP.md)
- [Architecture](../docs/architecture.md)
- [DIDComm Protocol](../docs/didcomm-protocol.md)
- [Development Guide](../docs/development.md)
