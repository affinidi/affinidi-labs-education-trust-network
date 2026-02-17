# Certizen - Cross‑Border Educational Credentials Verification

Including Issuer Authorization & Trust Validation

This repository contains an end‑to‑end reference implementation demonstrating how educational certificates can be issued, held, and verified using Verifiable Credentials (VCs), with an added focus on cross‑border issuer authorization and trust recognition.
The goal is to showcase how trusted data ecosystems—especially in regulated markets like education—can evolve beyond traditional PKI-based infrastructures and interoperate with next‑generation decentralized trust technologies.

# Purpose of This Demo

Many trust service providers (such as Certizen in Hong Kong) have a strong foundation in PKI, digital certificates, and regulated identity issuance. They are also accredited to issue vLEI identities, which come with significant governance rigor and cross‑jurisdictional assurance.
However, the education sector introduces new challenges:

- Credentials are personal, not organizational.
- Issuers vary across borders and regulatory systems.
- Students need portable, interoperable proof, not siloed PDFs.
- Verifiers need to know whether a foreign issuer is recognized and authorized.

This repository demonstrates how Affinidi’s technology can complement (not replace) existing high‑assurance stacks by enabling trusted, privacy‑preserving, interoperable educational credential flows.

# What This Repository Demonstrates
## ✔️ Issuance
A trusted issuer (e.g., a university or an education bureau) issues a **W3C Verifiable Credential** representing an educational certificate.
## ✔️ Wallet & Holder Flow
A learner receives and securely stores the credential in a **digital wallet**.
## ✔️ Verification
A verifier validates multiple aspects of the credential:
- **Authenticity** of the credential
- **Cryptographic signature**
- **Status** (e.g., revoked or valid)
- **Issuer’s authorization** to issue that specific credential type
## ✔️ Cross‑Border Issuer Recognition

This demo includes logic to determine whether an issuer from another region or jurisdiction is:

- **Authorized** to issue the specific credential type
- **Recognized** within a relevant **trust registry**
- **Resolvable** through interoperable trust mechanisms

This is especially important because traditional PKI infrastructures typically **do not cover domain‑specific authorization** for education issuers, particularly across borders.

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

![alt text](image.png)

## Demo Flow

## 🔗 Step 1: Trust Registry

### Register Issuers and Verifiers

- **University of Hong Kong (HKU)** is registered as an **authorized issuer** in Hong Kong’s Education Trust Registry operated by the Hong Kong Ministry of Education.  
- **University of Macau (UM)** is registered as an **authorized issuer** in Macau’s Education Trust Registry operated by the Macau Ministry of Education.  
- **Nova Corp (Employer)**, based in Singapore, is registered as an **authorized verifier** in Singapore’s Education Trust Registry operated by Singapore’s Ministry of Education.

### Recognize Governance Frameworks

- Singapore’s Education Trust Registry **recognizes Hong Kong’s Education Trust Registry** as a valid governance framework for Hong Kong–issued educational certificates.  
- Singapore’s Education Trust Registry **recognizes Macau’s Education Trust Registry** as a valid governance framework for Macau–issued educational certificates.

---

## 🎓 Step 2: Issuance of Educational Credentials

- **University of Hong Kong** issues an educational credential to the student using **DIDComm (VDIP) protocol**.  
- **University of Macau** issues an educational credential to the student using **DIDComm (VDIP) protocol**.

---

## 🔍 Step 3: Verification

### Presentation

- The student uses the **Certizen Student App**, powered by **Affinidi TDK**, to present the educational credential to **Nova Corp** via **DIDComm (VDSP) protocol**.

### Verifier Checks Governance Framework Recognition

- Nova Corp verifies whether **Hong Kong’s governance framework** is recognized by Singapore’s Trust Registry  
  → via **TRQP Recognition** call.  
- Nova Corp verifies whether **Macau’s governance framework** is recognized by Singapore’s Trust Registry  
  → via **TRQP Recognition** call.

### Verifier Checks Issuer Authorization

- Nova Corp checks whether **University of Hong Kong** is authorized to issue educational certificates  
  → via **TRQP Authorization** call.  


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
