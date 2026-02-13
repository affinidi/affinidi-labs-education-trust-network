# University Issuance Service - Macau University Instance

## Configuration

This instance issues credentials for Macau University students.

### Environment Variables

Create a `.env` file in this directory with:

```bash
# Service Configuration
PORT=8081
UNIVERSITY_NAME="Macau University"
UNIVERSITY_DID=did:web:{MACAU_UNIVERSITY_DOMAIN}:macau-university

# Affinidi Services
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}

# Trust Registry
TRUST_REGISTRY_URL=http://macau-trust-registry:3233

# Database
STORAGE_BACKEND=json
DATA_PATH=./data

# Credentials
ISSUER_KEY_PATH=./keys/issuer-key.json
```

### Running

```bash
# Install dependencies (from code directory)
cd ../../code
dart pub get

# Run the instance
dart run bin/server.dart --config ../instances/macau-university/.env
```

### Docker

```bash
docker compose -f docker-compose.yml up
```
