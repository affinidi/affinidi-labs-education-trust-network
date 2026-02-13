# Student Vault App

Flutter mobile application for students to receive, store, and share verifiable educational credentials using DIDComm v2 protocol.

## 🚀 Quick Start

### Setup

```bash
# From project root, run main setup first
make dev-up

# Run on iOS Simulator
make student-ios

# Run on Android Emulator
make student-android
```

**Available Make Commands (from root):**
- `make student-ios` - Run on iOS Simulator
- `make student-android` - Run on Android Emulator

**Note for Android:** Update the .env file to use `10.0.2.2` instead of `localhost`/`0.0.0.0` for emulator network access.
- `make strings` - Generate localized string files
- `make help` - Show all available commands
- `make clean` - Clean generated files

## ✨ Features

- **Receive Credentials**: Accept credentials from university issuers via VDIP protocol
- **Secure Storage**: Store credentials locally and securely
- **QR Code Scanning**: Scan QR codes from issuers and verifiers
- **Credential Presentation**: Share credentials with employers/verifiers
- **Multi-Organization**: Support for multiple universities and verifiers
- **DIDComm v2**: Secure, peer-to-peer communication

## 🏗️ Architecture

**Clean Architecture Pattern:**
- **Domain**: Entities, use cases, repository interfaces
- **Data**: Repository implementations, data sources, API clients
- **Presentation**: UI, widgets, screens, Riverpod state management
- **Core**: Shared utilities, design system, constants

**Key Technologies:**
- Flutter/Dart
- Riverpod (state management)
- DIDComm v2 (secure messaging)
- Affinidi Messaging (mediator)

## 🔧 Configuration

### Environment Configuration (.env.local-network)

```env
APP_NAME=Student Vault
APP_VERSION=1.0.0
USE_SSL=false

# University Services
HK_UNIVERSITY_SERVICE_URL=http://localhost:3000
HK_UNIVERSITY_SERVICE_DID=did:web:localhost%3A3000:hongkong-university
MACAU_UNIVERSITY_SERVICE_URL=http://localhost:3001
MACAU_UNIVERSITY_SERVICE_DID=did:web:localhost%3A3001:macau-university

# Verifier Service
NOVA_CORP_SERVICE_URL=http://localhost:4000
NOVA_CORP_SERVICE_DID=did:web:localhost%3A4000:nova-corp

# Affinidi Services
SERVICE_DID=did:web:...
MEDIATOR_DID=did:web:...
MEDIATOR_URL=https://...
```

### Organizations Configuration

The setup script automatically copies `organizations.localhost.dart` to `organizations.dart` with the correct configuration.

## 📱 Platform-Specific Notes

### iOS Simulator
- Use `localhost` URLs (default configuration)
- No additional changes needed

### Android Emulator
- Replace `localhost` with `10.0.2.2` in `.env.local-network`
- Android emulators use `10.0.2.2` to access host machine

### Physical Devices
- Use ngrok setup for physical device testing
- See main project README for ngrok configuration

## 📚 Documentation

- [Main Project README](../README.md)
- [Architecture](../docs/architecture.md) - System architecture
- [Setup Guide](../docs/setup.md) - Installation instructions
- [DIDComm Protocol](../docs/didcomm-protocol.md) - Protocol details
- [Development Guide](../docs/development.md) - Development workflow
- [Troubleshooting](../docs/troubleshooting.md) - Common issues and solutions
- [Technical Setup](code/README.md) - Detailed technical setup
- [Design System](../design-language/README.md) - Shared UI/UX guidelines
