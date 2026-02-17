# Education Ministries DID Hosting Service

> **⚠️ PROTOTYPE/REFERENCE IMPLEMENTATION**  
> This is a prototype service developed for demonstration and educational purposes only. It is **not a production-ready product** from Affinidi. This reference implementation showcases technical concepts and should not be used in production environments without significant additional development, security hardening, and testing.

A dedicated service for hosting DID:web documents for education ministries in the Certizen Demo.

## Overview

This service hosts DID documents for education ministries from multiple regions:

- Hong Kong Education Ministry
- Macau Education Ministry
- Singapore Education Ministry

Each ministry's DID document is served at its respective path, enabling decentralized identity resolution.

## Quick Start

### Running with Docker (Recommended)

The service automatically starts with Docker when you run the main setup:

```bash
# From project root
make dev-up
```

This will:

- Start ngrok tunnels
- Generate DID documents for all 3 ministries
- Start the service via Docker on port 3100

### Running Locally (Development)

For local development without Docker:

```bash
# From this directory
make dev-up
```

Or from the project root:

```bash
make education-ministries
```

### Viewing Logs

```bash
# Docker logs
make docker-logs-edu

# Or from project root
cd ../.. && make docker-logs-edu
```

## Available Commands

From this directory:

```bash
make help           # Show all available commands
make dev-up         # Start service locally (Dart)
make dev-down       # Stop local service
make docker-up      # Start via Docker
make docker-down    # Stop Docker container
make logs           # View Docker logs
make clean          # Clean generated data
```

From project root:

```bash
make education-ministries    # Start service locally
make docker-logs-edu         # View logs
```

## Architecture

- **Language**: Dart
- **Server**: Shelf HTTP server
- **Storage**: File-based JSON storage
- **DID Method**: did:web
- **Port**: 3100

## Directory Structure

```
education-ministries-did-hosting/
├── code/
│   ├── bin/
│   │   └── server.dart          # Main server entry point
│   ├── lib/
│   │   ├── env.dart             # Environment variable loader
│   │   ├── storage_interface.dart
│   │   ├── file_storage.dart    # JSON file storage
│   │   ├── did_generator.dart   # DID generation logic
│   │   ├── handlers.dart        # HTTP handlers
│   │   └── routes.dart          # Route definitions
│   ├── pubspec.yaml
│   ├── Dockerfile
│   └── .env.example
├── instance/
│   ├── .env.ngrok               # Runtime configuration (generated)
│   └── data/                    # Generated DID documents
├── docker-compose.yml
├── setup.sh
├── Makefile
└── README.md
```

## Configuration

Environment variables are automatically generated in `instance/.env.ngrok` by the setup script:

```bash
# Server
PORT=3100

# Ministries (comma-separated)
MINISTRIES=hongkong-education-ministry,macau-education-ministry,singapore-education-ministry

# Ministry-specific configuration
{ministry-name}_DOMAIN=domain.com/ministry-path
{ministry-name}_TRUST_REGISTRY_URL=https://trust-registry-url
```

## DID Resolution

DIDs are served at paths following the did:web specification:

- `did:web:domain.com:hongkong-education-ministry` → `https://domain.com/hongkong-education-ministry/did.json`
- `did:web:domain.com:macau-education-ministry` → `https://domain.com/macau-education-ministry/did.json`
- `did:web:domain.com:singapore-education-ministry` → `https://domain.com/singapore-education-ministry/did.json`

## Endpoints

### Health Check

```bash
GET /
GET /health
```

Returns service status.

### DID Documents

```bash
GET /{ministry-name}/did.json
```

Returns the DID document for the specified ministry.

Example:

```bash
curl https://your-domain.ngrok-free.app/hongkong-education-ministry/did.json
```

## Development

### Prerequisites

- Dart SDK 3.0+
- Docker (for containerized deployment)

### Local Setup

1. Ensure `instance/.env.ngrok` exists (run `make dev-up` from project root first)
2. Install dependencies:
   ```bash
   cd code && dart pub get
   ```
3. Start the service:
   ```bash
   make dev-up
   ```

### Adding a New Ministry

1. Update the `MINISTRIES` list in `instance/.env.ngrok`
2. Add ministry-specific configuration:
   ```bash
   new-ministry_DOMAIN=domain.com/new-ministry
   new-ministry_TRUST_REGISTRY_URL=https://trust-registry-url
   ```
3. Restart the service

## Generated Files

The service generates and stores:

- DID documents at `{ministry-name}/did.json`
- Private keys (for future signing operations)
- Metadata about generated DIDs

All data is persisted in the `instance/data/` directory.

## Docker Deployment

The service is automatically included in the main Docker Compose setup:

```yaml
services:
  education-ministries:
    build: ./code
    ports:
      - "3100:3100"
    volumes:
      - ./instance/data:/app/data
      - ./instance/.env.ngrok:/app/.env.ngrok:ro
```

## Troubleshooting

### Service not starting

1. Check if `instance/.env.ngrok` exists
2. Verify port 3100 is not in use
3. Check logs: `make logs` or `docker logs education-ministries-did-hosting`

### DID documents not accessible

1. Verify ngrok tunnel is running: visit http://localhost:4040
2. Check service is running: `docker ps | grep education-ministries`
3. Test locally: `curl http://localhost:3100/hongkong-education-ministry/did.json`

### Cannot access from other services

1. Ensure Docker network `certizen-network` exists
2. Verify container is on the same network
3. Check firewall settings

## Production Considerations

- **Key Management**: Private keys are stored in plain JSON. For production, use a proper key management system.
- **HTTPS**: The service expects to run behind ngrok or a reverse proxy with HTTPS.
- **Backup**: Regularly backup the `instance/data/` directory.
- **Monitoring**: Set up proper logging and monitoring for production deployments.
