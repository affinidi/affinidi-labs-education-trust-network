# Governance Portal

Flutter Web application for managing Trust Registry records. Each ministry (HK, Macau, Singapore) operates their own instance to register and manage issuers and verifiers.

## 🚀 Quick Start

### Setup

```bash
# From project root, run main setup first
make dev-up

# Run HK Ministry (Port 8050)
make hk-gov

# Run Macau Ministry (Port 8051)
make macau-gov

# Run Singapore Ministry (Port 8052)
make sg-gov
```

**Available Make Commands:**
- `make hk` - Start HK Ministry Governance Portal
- `make macau` - Start Macau Ministry Governance Portal
- `make sg` - Start Singapore Ministry Governance Portal
- `make gen` - Generate code (freezed, riverpod, etc.)
- `make strings` - Generate localized string files
- `make help` - Show all available commands
- `make clean` - Clean generated files

## 🏗️ Architecture

**Clean Architecture Pattern:**
- **Domain**: Business logic, entities, repository interfaces
- **Data**: Repository implementations, API clients
- **Presentation**: UI, widgets, Riverpod state management
- **Core**: Shared utilities, constants, design system

**Communication:**
- REST API to Trust Registry backend
- Manages registration/revocation of issuers and verifiers
- Each instance manages its own trust registry

## 🔧 Configuration

Each ministry instance requires environment configuration:

**Example (.env.hk.localhost):**
```env
PORT=8050
MINISTRY_NAME=Hong Kong Ministry of Education
MINISTRY_CODE=hk-ministry
GOVERNANCE_DID=did:web:localhost%3A8050:hk-ministry
TRUST_REGISTRY_DID=did:web:...
TRUST_REGISTRY_URL=https://...
API_BASE_URL=https://.../api
```

Required configuration:
- `user_config.json` with DID and private keys (in `code/assets/`)

## 📍 Instances

| Ministry | Port (Localhost) | Port (Ngrok) |
|----------|------------------|-------------|
| Hong Kong | 8050 | 3401 |
| Macau | 8051 | 3402 |
| Singapore | 8052 | 3403 |

## 📚 Documentation

- [Main Project README](../README.md)
- [Architecture](../docs/architecture.md)
- [Setup Guide](../docs/setup.md)
- [Trust Registry Details](../docs/trust-registry.md)
- [Development Guide](../docs/development.md)
- [DID Setup Guide](docs/DID_SETUP.md) - Automated DID generation
- [Technical Architecture](code/ARCHITECTURE.md) - Component architecture
- [Design System](../design-language/README.md) - Shared UI/UX guidelines
