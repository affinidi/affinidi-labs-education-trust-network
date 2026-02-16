# Certizen - Decentralized Educational Credentials

Platform for issuing, storing, and verifying educational credentials using DIDComm v2 protocol and trust registries.

## 📁 Project Structure

```
certizen-demo/
├── Makefile                          # Quick commands for all operations
├── README.md                         # This file
├── deployment/                       # All deployment-related files
│   ├── .env.ngrok                   # Environment configuration (created by make dev-up)
│   ├── .env.example                 # Environment template
│   ├── docker/                      # Docker compose files
│   │   ├── docker-compose.localhost.yml
│   │   └── docker-compose.yml
│   └── scripts/                     # Setup and utility scripts
│       ├── setup_ngrok.sh           # Main setup script
│       └── cleanup.sh               # Cleanup script
├── governance-portal/               # Flutter web app for trust registry admin
├── university-issuance-service/     # Dart backend for credential issuance
├── verifier-portal/                 # Dart app for credential verification
├── student-vault-app/               # Flutter mobile app for students
├── trust-registry/                  # Rust trust registry implementation
└── docs/                            # Documentation

```

**Pro Tip:** Use `make help` to see all available commands!

## �🚀 Quick Start

### Prerequisites

**System Requirements:**

- 8GB RAM minimum (16GB recommended)
- 4 CPU cores minimum
- 10GB free disk space

**Software:**

- Docker Desktop 4.0+ installed and running
- ngrok account (free tier works) - [Get it here](https://dashboard.ngrok.com/signup)
- Flutter SDK 3.5.0+
- Dart SDK 3.5.0+
- Git

**Configurations:**

- ngrok auth token
- Mediator DID
- Mediator URL
- Control plane DID (SERVICE_DID)

### Quick Start

```bash
# Start the complete environment with ngrok tunnels
make dev-up
```

This will:

1. Start ngrok tunnels for universities and education ministries
2. Capture dynamic ngrok domains
3. Generate all configurations and DIDs
4. Launch Docker containers (Trust Registries, Universities, etc.)

After setup completes, start the remaining services:

```bash
# Start governance portals (in separate terminals)
make hk-gov
make macau-gov
make sg-gov

# Start verifier portal
make verifier

# Start student app
make student-ios    # or make student-android
```

### Stop Services

```bash
# Stop ngrok tunnels and Docker services
make dev-down
```

## 🏗️ Architecture

```
Trust Registries (HK, Macau, SG)
        │
    ┌───┴───┐
Issuers     Verifiers
    │           │
    └─── Student ───┘
         Vault
```

### Components

| Component                        | Technology       | Description                               |
| -------------------------------- | ---------------- | ----------------------------------------- |
| **Student Vault App**            | Flutter (Mobile) | Credential storage and management         |
| **University Issuance Services** | Dart (Docker)    | Credential issuance backends (HK & Macau) |
| **Verifier Portal**              | Dart             | Employer credential verification          |
| **Governance Portal**            | Flutter (Web)    | Trust registry administration             |
| **Trust Registry**               | Rust (Docker)    | Trust registry backend service            |

## 🐳 Docker Services

The following services run on Docker:

- **HK University Issuer** (port 3000)
- **Macau University Issuer** (port 3001)
- **Trust Registries** (ports 3232, 3233, 3234)

### Useful Docker Commands

For convenience, use the Makefile shortcuts:

```bash
# Show all available commands
make help

# Docker management
make docker-ps          # Check container status
make docker-logs        # View all logs
make docker-stop        # Stop all services
make docker-rebuild     # Rebuild and restart

# Environment
make dev-up             # Start complete environment
make dev-down           # Stop ngrok + Docker
make cleanup            # Full cleanup
```

Or use docker-compose directly:

```bash
# Check container status
docker-compose -f deployment/docker/docker-compose.localhost.yml ps

# View all certizen container logs (single command)
docker-compose -f deployment/docker/docker-compose.localhost.yml logs -f

# View logs from specific service
docker logs hk-university-issuer -f
docker logs macau-university-issuer -f

# Stop services
docker-compose -f deployment/docker/docker-compose.localhost.yml down

# Restart services
docker-compose -f deployment/docker/docker-compose.localhost.yml restart

# Rebuild and restart
docker-compose -f deployment/docker/docker-compose.localhost.yml up -d --build
```

## 🛠️ Technologies

- **Flutter** - Mobile & web UIs (Clean Architecture)
- **Dart** - Backend services (MVC pattern)
- **Rust** - Trust registry API
- **Docker** - Container orchestration
- **DIDComm v2** - Secure communication protocol
- **Riverpod** - State management

## 📚 Documentation

### Quick References

- **[Quick Reference](docs/QUICK_REFERENCE.md)** - Common commands and operations
- **[Environment Restructure](docs/ENVIRONMENT_RESTRUCTURE.md)** - Environment configuration guide
- **[Restructure Complete](docs/RESTRUCTURE_COMPLETE.md)** - Project restructure summary

### Technical Documentation

- **[Architecture](docs/architecture.md)** - System design and component interactions
- **[Setup Guide](docs/setup.md)** - Detailed installation and configuration
- **[DIDComm Protocol](docs/didcomm-protocol.md)** - Protocol implementation details
- **[Trust Registry](docs/trust-registry.md)** - Trust registry configuration
- **[Development Guide](docs/development.md)** - Best practices and coding patterns
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions
- **[Product Requirements](docs/product-requirements.md)** - Project requirements and specifications
- **[Git Workflow](docs/git-workflow.md)** - Version control guidelines

### Component Documentation

- [Governance Portal](governance-portal/README.md)
- [Student Vault App](student-vault-app/README.md)
- [University Issuance Service](university-issuance-service/README.md)
- [Verifier Portal](verifier-portal/README.md)

## 🔌 Service Ports (Localhost)

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

## 🧹 Cleanup

```bash
# Stop and remove all Docker services + ngrok
make cleanup
```

## 📄 License

See [LICENSE](LICENSE) and [NOTICE.txt](NOTICE.txt)
