# University Issuance Service - Hong Kong University Instance

## Configuration

This instance issues credentials for Hong Kong University students.

### Environment Variables

Create a `.env` file in this directory with:

```bash
# Service Configuration
PORT=8080
UNIVERSITY_NAME="Hong Kong University"
UNIVERSITY_DID=did:web:{HK_UNIVERSITY_DOMAIN}:hongkong-university

# Affinidi Services
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}

# Trust Registry
TRUST_REGISTRY_URL=http://hk-trust-registry:3232

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
dart run bin/server.dart --config ../instances/hk-university/.env
```

### Docker

```bash
docker compose -f docker-compose.yml up
```
