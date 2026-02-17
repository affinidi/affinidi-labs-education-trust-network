# Trust Registry

> **⚠️ PROTOTYPE/REFERENCE IMPLEMENTATION**  
> This is a prototype service developed for demonstration and educational purposes only. It is **not a production-ready product** from Affinidi. This reference implementation showcases technical concepts and should not be used in production environments without significant additional development, security hardening, and testing.

Docker-based deployment of 3 Trust Registry instances for Hong Kong, Macau, and Singapore.

## Overview

This directory contains Docker configurations for running 3 separate Trust Registry instances, each with:

- CSV-based storage
- DIDComm enabled (admin operations only)
- Configured with country-specific Admin DIDs
- CORS configured for all service endpoints

## Architecture

```
trust-registry/
├── docker-compose.yml                # Docker configuration for 3 instances
├── setup.sh                          # Setup and deployment script
├── generate-trust-registry-dids.sh   # Generate Trust Registry DIDs
├── .env                              # Environment variables (generated)
├── affinidi-trust-registry-rs/       # Cloned from GitHub (auto-downloaded)
├── hk/
│   ├── config/
│   │   └── user_config.hk.json       # Trust Registry DID config
│   └── data/
│       └── data.csv                  # Trust records
├── macau/
│   ├── config/
│   │   └── user_config.macau.json    # Trust Registry DID config
│   └── data/
│       └── data.csv                  # Trust records
└── sg/
    ├── config/
    │   └── user_config.sg.json       # Trust Registry DID config
    └── data/
        └── data.csv                  # Trust records
```

## Ports

- **Hong Kong**: http://localhost:3232
- **Macau**: http://localhost:3233
- **Singapore**: http://localhost:3234

## Requirements

1. Docker and Docker Compose installed
2. Rust and Cargo installed (for DID generation)
3. Governance Portal admin DIDs generated first
4. Mediator configuration in main .env file

## Setup

### Step 1: Generate Trust Registry DIDs

Each Trust Registry instance needs its own unique DID for DIDComm communication:

```bash
./generate-trust-registry-dids.sh
```

This script will:

- Clone the `affinidi-trust-registry-rs` repository from GitHub (if not present)
- Generate unique DIDs for HK, Macau, and Singapore trust registries
- Configure mediator ACLs with the governance portal admin DIDs
- Save configurations to `hk/config`, `macau/config`, and `sg/config`

**Note:** The `make dev-up` command in the project root handles all setup, including governance portal DIDs and trust registry deployment.

### Step 2: Deploy Trust Registries

From the project root:

```bash
make dev-up
```

This will automatically:

1. Copy user_config files from governance-portal
2. Extract Admin DIDs
3. Create .env file for Docker Compose
4. Start 3 Trust Registry containers

## Configuration

### Storage Backend

- Type: CSV
- Location: `./[country]/data/data.csv`
- Format: `entity_id,authority_id,action,resource,context`

### CORS

All instances allow requests from:

- http://localhost:3000 (HK University)
- http://localhost:3001 (Macau University)
- http://localhost:4000 (Verifier Portal)
- http://localhost:8050 (HK Governance)
- http://localhost:8051 (Macau Governance)
- http://localhost:8052 (SG Governance)

### DIDComm

- Enabled: Yes
- Mode: Admin operations only (`ONLY_ADMIN_OPERATIONS=true`)
- Admin DIDs: Extracted from user_config files

## Usage

### Start Services

```bash
cd trust-registry
docker-compose up -d
```

### Check Status

```bash
docker-compose ps
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f trust-registry-hk
docker-compose logs -f trust-registry-macau
docker-compose logs -f trust-registry-sg
```

### Stop Services

```bash
docker-compose down
```

### Restart Services

```bash
docker-compose restart
```

## Health Checks

Each instance has a health check endpoint:

```bash
curl http://localhost:3232/health  # HK
curl http://localhost:3233/health  # Macau
curl http://localhost:3234/health  # SG
```

## API Endpoints

### Recognition Query

```bash
curl --location 'http://localhost:3232/recognition' \
--header 'Content-Type: application/json' \
--data '{
    "authority_id": "did:example:authority1",
    "entity_id": "did:example:entity1",
    "action": "issue",
    "resource": "diploma"
}'
```

### Authorization Query

```bash
curl --location 'http://localhost:3232/authorization' \
--header 'Content-Type: application/json' \
--data '{
    "authority_id": "did:example:authority1",
    "entity_id": "did:example:entity1",
    "action": "verify",
    "resource": "diploma"
}'
```

## Managing Trust Records

Trust records can be managed via:

1. **CSV Files**: Direct editing of `data.csv` files (requires restart)
2. **DIDComm**: Using the Admin DIDs to send CRUD messages

### CSV Format

```csv
entity_id,authority_id,action,resource,context
did:example:issuer1,did:example:gov1,issue,diploma,eyJ0eXBlIjoiZGlwbG9tYSJ9
did:example:verifier1,did:example:gov1,verify,diploma,eyJ0eXBlIjoiZGlwbG9tYSJ9
```

**Context field**: Base64-encoded JSON object with additional metadata

### Adding Records via DIDComm

Use the Admin DID credentials from user_config files to send DIDComm messages for:

- Creating records
- Updating records
- Deleting records
- Querying records

See [Trust Registry Administration](https://github.com/affinidi/affinidi-trust-registry-rs/blob/main/DIDCOMM_PROTOCOLS.md#trust-registry-administration) for protocol details.

## Environment Variables

Each instance uses these environment variables:

| Variable              | Description            | Example                         |
| --------------------- | ---------------------- | ------------------------------- |
| TR_STORAGE_BACKEND    | Storage type           | csv                             |
| FILE_STORAGE_PATH     | CSV file path          | /data/data.csv                  |
| CORS_ALLOWED_ORIGINS  | Allowed origins        | http://localhost:3000,...       |
| AUDIT_LOG_FORMAT      | Log format             | json                            |
| ENABLE_DIDCOMM        | Enable DIDComm         | true                            |
| ONLY_ADMIN_OPERATIONS | Admin-only mode        | true                            |
| MEDIATOR_DID          | Mediator DID           | did:web:...                     |
| ADMIN_DIDS            | Admin DIDs             | did:peer:2...                   |
| PROFILE_CONFIG        | Trust Registry profile | file:///config/user_config.json |

## Troubleshooting

### Container won't start

1. Check Docker is running: `docker info`
2. Check logs: `docker-compose logs [service-name]`
3. Verify user_config files exist
4. Verify .env file contains correct values

### Health check failing

1. Wait 40 seconds for startup (start_period)
2. Check container logs for errors
3. Verify port is not in use: `lsof -i :3232`

### CORS errors

1. Verify CORS_ALLOWED_ORIGINS includes your service URL
2. Restart container after changing CORS settings

### CSV file not updating

1. Restart container after editing CSV: `docker-compose restart [service-name]`
2. Check file permissions
3. Verify CSV format is correct

## Integration with Main Setup

The main `make dev-up` command automatically:

1. Generates user configs
2. Sets up Trust Registry instances
3. Configures services with Trust Registry URLs and DIDs

No manual intervention required - just run `make dev-up` from the project root.

## Security Notes

⚠️ **IMPORTANT**:

- User config files contain private keys - never commit to git
- .env file contains sensitive DIDs - keep secure
- In production, use proper secrets management
- Enable TLS for production deployments
- Use Redis or DynamoDB for production (not CSV)

## Related Documentation

- [Main README](../README.md)
- [Trust Registry GitHub](https://github.com/affinidi/affinidi-trust-registry-rs)
- [DIDComm Protocols](https://github.com/affinidi/affinidi-trust-registry-rs/blob/main/DIDCOMM_PROTOCOLS.md)
- [Setup Guide](https://github.com/affinidi/affinidi-trust-registry-rs/blob/main/SETUP_COMMAND_REFERENCES.md)
