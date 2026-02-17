# Verifier Portal

> **⚠️ PROTOTYPE/REFERENCE IMPLEMENTATION**  
> This is a prototype application developed for demonstration and educational purposes only. It is **not a production-ready product** from Affinidi. This reference implementation showcases technical concepts and should not be used in production environments without significant additional development, security hardening, and testing.

Flutter Web application for employers to verify student credentials. Simulates a company career portal where job applicants can present their educational credentials.

## 🚀 Quick Start

### Setup

```bash
# From project root, run main setup first
make dev-up

# Run Nova Corp Verifier (Port 4000)
make verifier
```

**Available Make Commands (from root):**

- `make verifier` - Start Nova Corp Verifier Portal
- `make help` - Show all available commands

### Access the Portal

```
http://localhost:4000
```

## ✨ Features

- **Career Portal UI**: Professional company portal interface
- **QR Code Generation**: Generate QR codes for credential verification requests
- **Credential Reception**: Receive credential presentations from students via DIDComm
- **Trust Registry Validation**: Verify issuer authenticity against trust registries
- **Multi-Registry Support**: Validates credentials from HK, Macau, and SG trust registries
- **Real-time Verification**: Instant credential verification feedback

## 🏗️ Architecture

**Clean Architecture Pattern:**

- **Domain**: Verification logic, entities, repository interfaces
- **Data**: Repository implementations, API clients
- **Presentation**: UI, widgets, Riverpod state management
- **Core**: Shared utilities, design system

**Verification Flow:**

1. Display QR code on career portal
2. Student scans QR code with vault app
3. Student selects credentials to share
4. Verifier receives and validates credentials
5. Check issuer against trust registries
6. Display verification result

## 🔧 Configuration

**Environment Configuration (.env.local-network):**

```env
PORT=4000
VERIFIER_NAME=Nova Corp
VERIFIER_DID=did:web:localhost%3A4000:nova-corp

# Trust Registries
HK_TRUST_REGISTRY_DID=did:web:...
HK_TRUST_REGISTRY_URL=https://...
MACAU_TRUST_REGISTRY_DID=did:web:...
MACAU_TRUST_REGISTRY_URL=https://...
SG_TRUST_REGISTRY_DID=did:web:...
SG_TRUST_REGISTRY_URL=https://...

# Affinidi Services
SERVICE_DID=did:web:...
MEDIATOR_DID=did:web:...
MEDIATOR_URL=https://...

# Storage
STORAGE_BACKEND=json
DATA_PATH=./data
```

## 🔍 Verification Process

1. **Receive Presentation**: Student presents credentials via DIDComm
2. **Validate Structure**: Check credential format and signatures
3. **Verify Issuer**: Confirm issuer is registered in trust registry
4. **Check Status**: Verify credential hasn't been revoked
5. **Display Result**: Show verification success/failure to employer

## 📍 Service Details

| Environment | Port | URL                    |
| ----------- | ---- | ---------------------- |
| Localhost   | 4000 | http://localhost:4000  |
| Ngrok       | 3500 | https://{ngrok-domain} |

## 📚 Documentation

- [Main Project README](../README.md)
- [Quick Start Guide](code/QUICK_START.md) - Get up and running quickly
- [Getting Started](code/GETTING_STARTED.md) - Detailed setup instructions
- [Configuration Guide](code/CONFIGURATION.md) - Environment and config details
- [Architecture](../docs/architecture.md) - System architecture
- [DIDComm Troubleshooting](code/DIDCOMM_TROUBLESHOOTING.md) - Debug DIDComm issues
- [CORS Fix Guide](code/CORS_FIX.md) - Resolving CORS issues
- [Ngrok Setup](code/NGROK_SETUP.md) - Internet-accessible setup
- [DID Regeneration Fix](docs/DID_REGENERATION_FIX.md) - DID key troubleshooting
- [Design System](../design-language/README.md) - Shared UI/UX guidelines
- [DIDComm Protocol](../docs/didcomm-protocol.md)
- [Trust Registry](../docs/trust-registry.md)
- [Development Guide](../docs/development.md)
