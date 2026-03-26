# Cross‑Border Educational Credentials Verification

> Including Issuer Authorization & Trust Validation

An end‑to‑end reference implementation demonstrating how educational certificates can be issued, held, and verified using **W3C Verifiable Credentials**, with a focus on cross‑border issuer authorization and trust recognition.

> **⚠️ IMPORTANT: PROTOTYPE/REFERENCE IMPLEMENTATION**  
> This repository contains prototype applications and services developed for **demonstration and educational purposes only**. These are **not production-ready products** from Affinidi. This reference implementation showcases technical concepts and architectural patterns for verifiable credentials and should not be deployed in production environments without significant additional development, security hardening, thorough testing, and professional review.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Purpose](#-purpose)
- [Key Features](#-key-features)
- [Architecture](#️-architecture)
- [Demo Flow](#-demo-flow)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Components](#-components)
- [Docker Services](#-docker-services)
- [Technologies](#️-technologies)
- [Documentation](#-documentation)
- [Service Ports](#-service-ports)
- [Cleanup](#-cleanup)
- [License](#-license)

---

## 🎯 Overview

This repository showcases how trusted data ecosystems—especially in regulated markets like education—can be built on open, interoperable standards using **W3C Verifiable Credentials** and **TRQP‑enabled trust registries**, delivering secure, policy‑governed, cross‑network credential verification across borders.

The demo illustrates a complete credential lifecycle: from **issuance** by universities, through **secure storage** in student wallets, to **verification** by employers across different jurisdictions—all while maintaining privacy, security, and cross-border trust.

### What This Demonstrates Functionally

- 🛡️ **Prevent fake issuers and credentials** — verifiable authority chains ensure only authorized institutions can issue specific credential types, enforced at the trust registry level
- 🌐 **Cross-network trust recognition** — TRQP‑enabled trust registries allow one jurisdiction's governance framework to formally recognize another's, without bilateral agreements for every pair of institutions
- 📜 **Policy‑governed verification** — every verification call is backed by machine-readable trust policies, not manual lookups or out-of-band phone calls
- 🔀 **Reusable across sectors and borders** — the architecture is credential-agnostic and not tied to any single identity scheme, making it applicable beyond education to any domain requiring cross-border issuer authorization

---

## 💡 Purpose

Many trust service providers have a strong foundation in PKI, digital certificates, and regulated identity issuance. Yet cryptographic signatures alone are not enough — verifiers also need to know **who is authorized to issue** a specific credential type, and whether that authority is **recognized across governance boundaries**.

The education sector makes this particularly clear:

- ✅ Credentials are **personal**, not organizational
- ✅ Issuers vary across **borders and regulatory systems**
- ✅ Students need **portable, interoperable proof**, not siloed PDFs
- ✅ Verifiers need to know whether a **foreign issuer is recognized and authorized**

This repository demonstrates how the **W3C Verifiable Credentials** standard and **TRQP‑enabled trust registries** together solve this problem — enabling trusted, privacy‑preserving, policy‑governed credential flows that can be adopted by any trust service provider, regardless of the underlying identity infrastructure they already operate.

Key functional goals this reference implementation addresses:

- Prevent fraudulent credential issuance by anchoring issuer authorization in governance-controlled trust registries
- Enable cross-border issuer recognition through TRQP Recognition and Authorization calls between independent trust registries
- Deliver verifiable authority chains so that every credential carries proof not just of what was issued, but _by whom_ and _under what governance_
- Provide a reusable, standards-based blueprint applicable to any domain requiring cross-network trust — not just education

---

## ✨ Key Features

### 🎓 Credential Issuance

A trusted issuer (e.g., a university or education bureau) issues a **W3C Verifiable Credential** representing an educational certificate.

### 📱 Digital Wallet & Holder Flow

Students receive and securely store credentials in a **digital wallet** with full control over their data.

### 🔍 Multi-Layer Verification

Verifiers validate multiple aspects of the credential:

- ✅ **Authenticity** of the credential
- ✅ **Cryptographic signature** integrity
- ✅ **Status** (revoked or valid)
- ✅ **Issuer authorization** to issue that specific credential type

### 🌍 Cross‑Border Issuer Recognition

The system determines whether an issuer from another jurisdiction is:

- ✅ **Authorized** to issue the specific credential type
- ✅ **Recognized** within a relevant **trust registry**
- ✅ **Resolvable** through interoperable trust mechanisms

> **Why This Matters:** Traditional PKI infrastructures typically do not cover domain‑specific authorization for education issuers, particularly across borders.

---

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

![Architecture Diagram](docs/arch-image.png)

The system consists of:

- **Trust Registries**: Maintain authorized issuer and verifier lists per jurisdiction
- **Issuers**: Universities that issue educational credentials
- **Student Vault**: Mobile app for credential storage and management
- **Verifiers**: Employers or institutions that verify credentials

---

## 🔄 Demo Flow

### Step 1: Trust Registry Setup

#### Register Issuers and Verifiers

- **University of Hong Kong (HKU)** → Registered as an authorized issuer in Hong Kong's Education Trust Registry
- **University of Macau (UM)** → Registered as an authorized issuer in Macau's Education Trust Registry
- **Nova Corp (Employer)** → Registered as an authorized verifier in Singapore's Education Trust Registry

#### Establish Governance Framework Recognition

- Singapore's Trust Registry **recognizes** Hong Kong's Education Trust Registry as a valid governance framework
- Singapore's Trust Registry **recognizes** Macau's Education Trust Registry as a valid governance framework

---

### Step 2: Credential Issuance

- **University of Hong Kong** issues an educational credential to the student via **DIDComm (VDIP) protocol**
- **University of Macau** issues an educational credential to the student via **DIDComm (VDIP) protocol**

---

### Step 3: Credential Verification

#### Presentation

The student uses the **Credulon Student App** (powered by **Affinidi TDK**) to present credentials to **Nova Corp** via **DIDComm (VDSP) protocol**.

#### Verification Process

Nova Corp performs the following checks:

1. **Governance Framework Recognition** (via TRQP Recognition calls)
   - Verifies Hong Kong's governance framework is recognized by Singapore's Trust Registry
   - Verifies Macau's governance framework is recognized by Singapore's Trust Registry

2. **Issuer Authorization** (via TRQP Authorization calls)
   - Confirms University of Hong Kong is authorized to issue educational certificates
   - Confirms University of Macau is authorized to issue educational certificates

---

## 🚀 Quick Start

### Prerequisites

#### System Requirements

- **RAM**: 8GB minimum (16GB recommended)
- **CPU**: 4 cores minimum
- **Disk**: 10GB free space

#### Required Software (Host Machine)

All backend services run inside Docker containers — you do **not** need Rust, Dart, or Flutter installed on your host (except for the Student mobile app).

| Software                                                              | macOS / Linux                                   | Windows                                   |
| --------------------------------------------------------------------- | ----------------------------------------------- | ----------------------------------------- |
| [Docker Desktop 4.0+](https://www.docker.com/products/docker-desktop) | Required                                        | Required (with **WSL 2** backend enabled) |
| [ngrok](https://ngrok.com/download)                                   | Required (free tier works)                      | Required                                  |
| [Git](https://git-scm.com/)                                           | Required                                        | Required — use **Git Bash** or **WSL 2**  |
| `jq`                                                                  | Required (`brew install jq` / `apt install jq`) | Required (`choco install jq` or via WSL)  |
| `curl`                                                                | Pre-installed                                   | Pre-installed in Git Bash / WSL           |
| [Flutter SDK 3.5.0+](https://docs.flutter.dev/get-started/install)    | Only for Student mobile app                     | Only for Student mobile app               |
| [GitHub CLI (`gh`)](https://cli.github.com/)                          | Optional — enables CI artifact fallback         | Optional                                  |

> **Windows Users**: All shell scripts use `bash`. Run commands from **Git Bash** or **WSL 2**. The `Makefile` targets may not work in `cmd.exe` or PowerShell — use the direct bash commands shown below instead.

#### Configuration Requirements

You will be prompted for these during setup:

- ngrok auth token ([get one here](https://dashboard.ngrok.com/get-started/your-authtoken))
- Mediator DID
- Mediator URL
- Control plane DID (SERVICE_DID)
- Student details (name, email) for the demo credential

All values are saved to `deployment/.env.ngrok` and reused on subsequent runs.

---

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/affinidi/affinidi-labs-education-trust-network.git
cd affinidi-labs-education-trust-network
```

#### 2. Start the Complete Environment

**macOS / Linux:**

```bash
make dev-up
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/dev-up.sh
```

The setup script runs a fully automated 12-step process:

| Step | Description                                                   |
| ---- | ------------------------------------------------------------- |
| 1    | Authenticate with ngrok                                       |
| 2    | Configure DIDComm Service DID                                 |
| 3    | Configure Mediator (DID + URL)                                |
| 4    | Start 3 ngrok tunnels (2 universities + education ministries) |
| 5    | Capture ngrok domains                                         |
| 5.5  | Collect student & program details                             |
| 6    | Generate `.env.ngrok` configuration                           |
| 7    | Generate Admin DIDs (via Docker — no Rust on host)            |
| 8    | Generate Trust Registry DIDs (via Docker — no Rust on host)   |
| 9    | Prepare Trust Registry configs                                |
| 10   | Create all app environment files                              |
| 11   | Run setup scripts (student app)                               |
| 12   | Build/pull & start all 11 Docker containers                   |

> **Pre-built images**: At the start, you are prompted to choose a Docker image tag:
>
> - `latest` — most recent build from any branch
> - `main` — last stable build from the main branch
>
> Images are pulled from **GitHub Container Registry** (GHCR), so you skip build on first run. If GHCR is unreachable, the script falls back to CI artifacts → local cache → building from source.

---

#### 3. Start the Student Mobile App

After the environment setup completes, start the student app in a separate terminal:

**macOS / Linux:**

```bash
make student-ios       # iOS simulator
make student-android   # Android emulator/device
make student-web       # Web browser
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/student-app.sh android
bash deployment/scripts/student-app.sh web
```

> **Note**: The Student Vault App is the only component that requires Flutter SDK on the host, as it runs natively on a mobile device or emulator.

---

#### 4. Stop Services

**macOS / Linux:**

```bash
make dev-down      # Stop ngrok tunnels and Docker services
make cleanup       # Complete cleanup (removes all data)
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/dev-down.sh
bash deployment/scripts/cleanup.sh
```

---

### 💡 Pro Tips

**macOS / Linux (Makefile):**

```bash
make help               # View all available commands
make docker-ps          # Check Docker container status
make docker-logs        # View logs from all services
make docker-rebuild     # Force rebuild all images from source
make docker-pull        # Download pre-built images from CI
make docker-cache-status # Show image status (GHCR / local / built)
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/build-images.sh --status   # Show image status
bash deployment/scripts/build-images.sh --pull      # Download from CI
bash deployment/scripts/build-images.sh --force     # Force rebuild
```

---

## 📁 Project Structure

```
affinidi-labs-education-trust-network/
├── Makefile                          # All operation commands
├── README.md                         # This file
│
├── .github/workflows/               # CI/CD
│   └── docker-publish.yml           # Builds & pushes all Docker images to GHCR
│
├── deployment/                       # Deployment configuration
│   ├── .env.ngrok                   # Environment config (auto-generated)
│   ├── docker/                      # Docker compose files (split per service group)
│   │   ├── compose.universities.yml
│   │   ├── compose.edu-ministries.yml
│   │   ├── compose.trust-registries.yml
│   │   ├── compose.governance.yml
│   │   └── compose.verifier.yml
│   └── scripts/                     # Setup and utility scripts
│       ├── setup_ngrok.sh           # Main 12-step setup orchestrator
│       ├── build-images.sh          # Smart image builder (GHCR → CI → cache → build)
│       ├── dev-up.sh / dev-down.sh
│       ├── cleanup.sh
│       └── student-app.sh
│
├── governance-portal/               # Trust registry admin (Flutter Web) → Docker
├── student-vault-app/               # Student credential wallet (Flutter Mobile) → Native
├── university-issuance-service/     # Credential issuance backend (Dart) → Docker
├── verifier-portal/                 # Credential verification (Dart + Flutter Web) → Docker
├── trust-registry/                  # Trust registry backend (Rust) → Docker
├── education-ministries-did-hosting/ # DID document hosting (Dart) → Docker
│
└── docs/                            # Documentation
    ├── architecture.md
    ├── setup.md
    ├── development.md
    └── ...
```

---

## 🧩 Components

| Component                            | Technology            | Description                                   | Deployment |
| ------------------------------------ | --------------------- | --------------------------------------------- | ---------- |
| **Student Vault App**                | Flutter (Mobile)      | Credential storage and management             | Native     |
| **University Issuance Services**     | Dart                  | Credential issuance backends (HK & Macau)     | Docker     |
| **Education Ministries DID Hosting** | Dart                  | DID document hosting for 3 ministries         | Docker     |
| **Verifier Portal (Backend)**        | Dart                  | Employer credential verification API          | Docker     |
| **Verifier Portal (Frontend)**       | Flutter (Web)         | Employer verification UI                      | Docker     |
| **Governance Portals**               | Flutter (Web) + nginx | Trust registry administration (HK, Macau, SG) | Docker     |
| **Trust Registries**                 | Rust                  | Trust registry backend (HK, Macau, SG)        | Docker     |

---

## 🐳 Docker Services

All 11 services run in Docker containers, organized into 5 compose projects:

| Service                           | Container Name                   | Port | Compose Project      |
| --------------------------------- | -------------------------------- | ---- | -------------------- |
| **HK University Issuer**          | hk-university-issuer             | 3000 | etn-universities     |
| **Macau University Issuer**       | macau-university-issuer          | 3001 | etn-universities     |
| **Education Ministries**          | education-ministries-did-hosting | 3100 | etn-edu-ministries   |
| **HK Trust Registry**             | trust-registry-hk                | 3232 | etn-trust-registries |
| **Macau Trust Registry**          | trust-registry-macau             | 3233 | etn-trust-registries |
| **Singapore Trust Registry**      | trust-registry-sg                | 3234 | etn-trust-registries |
| **HK Governance Portal**          | hk-governance-portal             | 8050 | etn-governance       |
| **Macau Governance Portal**       | macau-governance-portal          | 8051 | etn-governance       |
| **Singapore Governance Portal**   | sg-governance-portal             | 8052 | etn-governance       |
| **Nova Corp Verifier (Backend)**  | nova-verifier-backend            | 4001 | etn-nova-verifier    |
| **Nova Corp Verifier (Frontend)** | nova-verifier-frontend           | 4000 | etn-nova-verifier    |

Pre-built images are available from **GitHub Container Registry** (`ghcr.io/affinidi/etn-*`) with multi-platform support (linux/amd64 + linux/arm64, including Apple Silicon).

### Common Docker Commands

#### Using Makefile (macOS / Linux)

```bash
make docker-ps          # Check container status (grouped by service)
make docker-logs        # View all logs
make docker-stop        # Stop all services
make docker-rebuild     # Force rebuild all images from source
make docker-pull        # Download pre-built images from latest CI build
make docker-cache-status # Show image availability (GHCR / local / cache)
```

#### Using docker compose Directly

```bash
cd deployment/docker

# Check container status per project
docker compose -p etn-universities -f compose.universities.yml ps
docker compose -p etn-trust-registries -f compose.trust-registries.yml ps
docker compose -p etn-governance -f compose.governance.yml ps
docker compose -p etn-nova-verifier -f compose.verifier.yml ps

# View specific service logs
docker logs trust-registry-hk -f
docker logs hk-university-issuer -f
docker logs nova-verifier-backend -f

# Restart a specific project
docker compose -p etn-trust-registries -f compose.trust-registries.yml restart
```

---

## 🛠️ Technologies

| Technology                     | Purpose                                     |
| ------------------------------ | ------------------------------------------- |
| **Flutter**                    | Mobile & web UIs (Clean Architecture)       |
| **Dart**                       | Backend services (MVC pattern)              |
| **Rust**                       | High-performance trust registry API         |
| **Docker + BuildKit**          | Container orchestration with build caching  |
| **GHCR**                       | Pre-built multi-arch images (amd64 + arm64) |
| **DIDComm v2**                 | Secure peer-to-peer communication protocol  |
| **Riverpod**                   | State management for Flutter apps           |
| **W3C Verifiable Credentials** | Credential format standard                  |
| **ngrok**                      | Public tunnel endpoints for DID resolution  |

---

## 📚 Documentation

### 🚀 Quick Guides

| Document                                   | Description                             |
| ------------------------------------------ | --------------------------------------- |
| [Quick Reference](docs/QUICK_REFERENCE.md) | Common commands and operations          |
| [Setup Guide](docs/setup.md)               | Detailed installation and configuration |
| [Troubleshooting](docs/troubleshooting.md) | Common issues and solutions             |

### 🏗️ Technical Documentation

| Document                                             | Description                              |
| ---------------------------------------------------- | ---------------------------------------- |
| [Architecture](docs/architecture.md)                 | System design and component interactions |
| [DIDComm Protocol](docs/didcomm-protocol.md)         | Protocol implementation details          |
| [Trust Registry](docs/trust-registry.md)             | Trust registry configuration             |
| [Development Guide](docs/development.md)             | Best practices and coding patterns       |
| [Git Workflow](docs/git-workflow.md)                 | Version control guidelines               |
| [Product Requirements](docs/product-requirements.md) | Project requirements and specifications  |

### 📦 Component Documentation

- [Governance Portal](governance-portal/README.md) - Trust registry administration
- [Student Vault App](student-vault-app/README.md) - Mobile wallet application
- [University Issuance Service](university-issuance-service/README.md) - Credential issuance
- [Verifier Portal](verifier-portal/README.md) - Credential verification

---

## 🔌 Service Ports

| Service                           | Port | Runtime |
| --------------------------------- | ---- | ------- |
| **HK University Issuer**          | 3000 | Docker  |
| **Macau University Issuer**       | 3001 | Docker  |
| **Education Ministries**          | 3100 | Docker  |
| **HK Trust Registry**             | 3232 | Docker  |
| **Macau Trust Registry**          | 3233 | Docker  |
| **Singapore Trust Registry**      | 3234 | Docker  |
| **Nova Corp Verifier (Frontend)** | 4000 | Docker  |
| **Nova Corp Verifier (Backend)**  | 4001 | Docker  |
| **HK Governance Portal**          | 8050 | Docker  |
| **Macau Governance Portal**       | 8051 | Docker  |
| **Singapore Governance Portal**   | 8052 | Docker  |
| **Ngrok Dashboard**               | 4040 | Host    |

---

## 🧹 Cleanup

To completely remove all services and data:

**macOS / Linux:**

```bash
make cleanup
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/cleanup.sh
```

This will:

- ✅ Stop all 11 Docker containers
- ✅ Remove Docker volumes and networks
- ✅ Terminate ngrok tunnels
- ✅ Clean up generated configuration files and DIDs

---

## 📖 Usage Guide

Once setup is complete and all services and applications are running, follow these instructions to execute an end-to-end issuance and verification flow.

### ✅ Issuers

Issuers are pre-configured for this demo and will use VDIP to issue credentials to students. All issuers have entries in their respective trust registries as authorized issuers.

**No additional configuration is required.**

---

### 🏛️ Configuring Trust Registries

If setup was successful, three trust registries and three governance portals are running—one for each jurisdiction (HK, Macau, SG).

**Required DIDs and URLs** can be found in the `dev-up` command logs or in `/deployment/.env.ngrok`.

#### Hong Kong Trust Registry

1. Open the Hong Kong governance portal: `http://localhost:8050/`
2. Enter a name for the registry
3. Skip the quick setup page
4. Add a record:

- **Entity ID**: HK University's DID
- **Authority ID**: HK Ministry's DID
- **Action**: `issue`
- **Resource**: `EducationCredential`
- **Trust Status**: `Authorized`

5. Click **Create Record** and verify the record appears in **Records**

#### Macau Trust Registry

1. Open the Macau governance portal: `http://localhost:8051/`
2. Enter a name for the registry
3. Skip the quick setup page
4. Add a record:

- **Entity ID**: Macau University's DID
- **Authority ID**: Macau Ministry's DID
- **Action**: `issue`
- **Resource**: `EducationCredential`
- **Trust Status**: `Authorized`

5. Click **Create record** and verify the record appears in **Records**

#### Singapore Trust Registry

1. Open the Singapore governance portal: `http://localhost:8052/`
2. Enter a name for the registry
3. Skip the quick setup page
4. Add two records:

   **Record 1** (HK Recognition):

- **Entity ID**: HK Ministry's DID
- **Authority ID**: SG Ministry's DID
- **Action**: `recognize`
- **Resource**: `listed-registry`
- **Trust Status**: `Recognized`

**Record 2** (Macau Recognition):

- **Entity ID**: Macau Ministry's DID
- **Authority ID**: SG Ministry's DID
- **Action**: `recognize`
- **Resource**: `listed-registry`
- **Trust Status**: `Recognized`

5. Click **Create Record** for each and verify both records appear in **Records**

**Example**: ![Hong Kong registry setup](docs/HK-registry.mov.gif)

---

### 📱 Student App

1. Start your emulator or physical device:

**macOS / Linux:**

```bash
make student-ios      # For iOS
make student-android  # For Android
make student-web      # For Web browser
```

**Windows (Git Bash / WSL):**

```bash
bash deployment/scripts/student-app.sh android
bash deployment/scripts/student-app.sh web
```

2. Complete the registration/login process. Note: OTP authentication is mocked; only specific email domains are allowed.
3. Complete your student profile (use matching details from the `make dev-up` setup)
4. When prompted to claim VCs, claim both credentials

**Example**:

<img src="docs/Student-app.gif" alt="Student app flow" width="320" height="auto" />

---

### 🔍 Verifier App

1. Open the verifier portal: `http://localhost:4000/`
2. Browse the job listings
3. Click a job posting, then click **Apply** on the detail page
4. Note the pre-configured name and QR code
5. Scan the QR code using the Student App and follow the credential-sharing process
6. After successful credential sharing, the verifier validates the credential and trust registry status
7. Results appear below the application

**Repeat** as needed by deleting shared credentials or restarting from step 3.

| ![Job listings](docs/image.png) | ![Application form](docs/image-1.png) | ![Verification result](docs/image-2.png) |
| ------------------------------- | ------------------------------------- | ---------------------------------------- |

**Example**: ![credential sharing](docs/final-sharing.gif)

---

## 📄 License

See [LICENSE](LICENSE) and [NOTICE.txt](NOTICE.txt) for details.

---

## 🤝 Contributing

This is a reference implementation for demonstration purposes. For questions or suggestions, please open an issue.

---

## 🔗 Related Resources

- [Affinidi Documentation](https://docs.affinidi.com)
- [W3C Verifiable Credentials](https://www.w3.org/TR/vc-data-model/)
- [DIDComm Messaging](https://identity.foundation/didcomm-messaging/spec/)

---

<div align="center">

**Built with ❤️ by the Affinidi Team**

</div>
