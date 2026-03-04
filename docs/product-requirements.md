# Nexigen Demo - Project Requirements Document (PRD)

## 1. Executive Summary

**Project Name:** Nexigen Demo  
**Purpose:** Demonstrate university credential issuance and employment verification using decentralized identity infrastructure  
**Architecture:** Clean Architecture with separation of concerns across all Flutter applications. Single codebase with multiple instances pattern for scalability.

### Key Participants

- **Issuers:** Hong Kong University, Macau University (single codebase, 2 instances)
- **Holders:** Students (via Student Vault App)
- **Verifiers:** Nova Corp (employer)
- **Governance:** Hong Kong Ministry, Macau Ministry, Singapore Ministry (single codebase, 3 instances)

### Architecture Highlights

- **University Issuance Service**: Single codebase (`/university-issuance-service/code`) with multiple instances (`/instances/hk-university`, `/instances/macau-university`)
- **Trust Registry API**: Single Rust codebase with 3 ministry instances, each with PostgreSQL backend, manual data entry via admin UI
- **Domain Management**: 6 ngrok tunnels (HK issuer:8080, Macau issuer:8081, Nova verifier:8082, HK TR:3232, Macau TR:3233, SG TR:3234)
- **Student Vault**: Drift-based local profile storage, simplified onboarding (no organization selection), dashboard with credential claim buttons

---

## 2. System Architecture

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│              Trust Registry Layer (3 Instances)                     │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐       │
│  │ HK Ministry    │  │  Macau Ministry│  │    SG Ministry │       │
│  │ Port: 3232     │  │  Port: 3233    │  │    Port: 3234  │       │
│  │ PostgreSQL DB  │  │  PostgreSQL DB │  │    PostgreSQL DB│       │
│  └────────────────┘  └────────────────┘  └────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
           │                    │                    │
     ┌─────┴──────┬─────────────┴──────┬────────────┴────┐
     │            │                    │                  │
┌────▼────────┐  ┌▼──────────────┐  ┌─▼──────────┐  ┌───▼────────┐
│   HK Univ   │  │ Macau Univ    │  │  Nova Corp │  │  Student   │
│  (Issuer)   │  │  (Issuer)     │  │  (Verifier)│  │  Vault App │
│  Port: 8080 │  │  Port: 8081   │  │  Port: 8082│  │  (Mobile)  │
│             │  │               │  │            │  │            │
│ Single Codebase - 2 Instances  │  │            │  │  Profile:  │
└─────────────┴─────────────────┘  └────────────┘  │  Drift DB  │
                                                     └────────────┘
```

### 2.2 Component Overview

| Component                       | Technology     | Architecture       | Port(s)          | Instances         | Purpose                                    |
| ------------------------------- | -------------- | ------------------ | ---------------- | ----------------- | ------------------------------------------ |
| **University Issuance Service** | Dart (Shelf)   | MVC                | 8080, 8081       | 2 (HK, Macau)     | Single codebase for credential issuance    |
| **Verifier Portal**             | Flutter Web    | Clean Architecture | 8082             | 1                 | Nova Corp job portal with verification     |
| **Student Vault App**           | Flutter Mobile | Clean Architecture | -                | 1                 | Student wallet with Drift storage          |
| **Trust Registry API**          | Rust           | Layered            | 3232, 3233, 3234 | 3 (HK, Macau, SG) | TRQP with PostgreSQL backend               |
| **Governance Portal**           | Flutter Web    | Clean Architecture | 3401, 3402, 3403 | 3 (HK, Macau, SG) | Admin portal for trust registry management |
| **Domain Setup**                | Node.js        | Utility            | -                | 1                 | Creates 6 ngrok tunnels                    |

### 2.3 Directory Structure

```
affinidi-labs-education-trust-network/
├── docker-compose.yml              # Main orchestration (all services)
├── .env.example                    # Shared environment configuration
├── setup.sh                        # Automated setup script
├── cleanup.sh                      # Cleanup script
│
├── domain-setup/                   # Ngrok tunnel management
│   ├── code/
│   │   ├── server.js              # Creates 6 tunnels
│   │   ├── domains.json           # Generated domain mappings
│   │   └── Dockerfile
│   └── setup.sh
│
├── university-issuance-service/   # Single codebase for issuers
│   ├── code/                       # Shared codebase (Dart/Shelf)
│   │   ├── lib/
│   │   ├── Dockerfile
│   │   └── pubspec.yaml
│   ├── instances/
│   │   ├── hk-university/         # HK instance configuration
│   │   │   ├── .env.example       # Port 8080, HK-specific config
│   │   │   ├── docker-compose.yml # Standalone compose
│   │   │   └── README.md
│   │   └── macau-university/      # Macau instance configuration
│   │       ├── .env.example       # Port 8081, Macau-specific config
│   │       ├── docker-compose.yml
│   │       └── README.md
│   └── README.md                   # How to add new instances
│
├── governance-portal/             # Single Rust codebase
│   ├── src/                        # Shared Rust code
│   ├── Cargo.toml
│   ├── Dockerfile
│   ├── instances/
│   │   ├── hk-ministry/           # HK Ministry instance
│   │   │   ├── .env.example       # Port 3232, PostgreSQL config
│   │   │   ├── docker-compose.yml # Includes PostgreSQL container
│   │   │   └── README.md
│   │   ├── macau-ministry/        # Macau Ministry instance
│   │   │   ├── .env.example       # Port 3233, PostgreSQL config
│   │   │   ├── docker-compose.yml
│   │   │   └── README.md
│   │   └── sg-ministry/           # Singapore Ministry instance
│   │       ├── .env.example       # Port 3234, PostgreSQL config
│   │       ├── docker-compose.yml
│   │       └── README.md
│   └── README.md                   # Instance management guide
│
├── governance-portal/          # Admin portal for trust registries
│   ├── code/                       # Shared Flutter web codebase
│   │   ├── lib/
│   │   ├── Dockerfile
│   │   ├── pubspec.yaml
│   │   └── setup.sh
│   ├── data/                       # Configuration templates
│   │   └── ministries.json        # Ministry configurations
│   ├── instances/
│   │   ├── hk-ministry/           # HK Ministry portal
│   │   │   ├── .env.example       # Port 3401, API config
│   │   │   ├── docker-compose.yml
│   │   │   └── README.md
│   │   ├── macau-ministry/        # Macau Ministry portal
│   │   │   ├── .env.example       # Port 3402, API config
│   │   │   ├── docker-compose.yml
│   │   │   └── README.md
│   │   └── sg-ministry/           # Singapore Ministry portal
│   │       ├── .env.example       # Port 3403, API config
│   │       ├── docker-compose.yml
│   │       └── README.md
│   ├── DIDCOMM_MIGRATION.md       # Plan for Dart DIDComm migration
│   └── README.md                   # Instance management guide
│
├── verifier-portal/                # Nova Corp verifier
│   ├── code/                       # Flutter web codebase
│   └── README.md
│
└── student-vault-app/              # Student mobile app
    ├── code/
    │   └── lib/
    │       ├── core/
    │       │   └── database/
    │       │       └── app_database.dart  # Drift database
    │       └── features/
    │           ├── profile/        # User profile with Drift
    │           │   ├── data/
    │           │   │   ├── datasources/
    │           │   │   │   └── local/
    │           │   │   │       ├── user_profile_table.dart
    │           │   │   │       └── user_profile_drift_datasource.dart
    │           │   │   └── repositories/
    │           │   ├── domain/
    │           │   │   ├── entities/
    │           │   │   │   └── user_profile.dart
    │           │   │   └── repositories/
    │           │   └── presentation/
    │           ├── credentials/    # Credential management
    │           └── onboarding/     # No org selection
    ├── configs/
    │   └── organizations.dart      # universities array
    └── README.md
```

### 2.4 Data Management

**Trust Registries:**

- ❌ **No CSV files** - All data entered manually via Governance Portal
- ✅ **PostgreSQL backend** - Each ministry has dedicated database
- ✅ **Manual entry workflow**: Admin logs into Portal → Enters DID, name, schema → Saves to PostgreSQL
- ✅ **Architecture**: Portal (Flutter) → Trust Registry API (Rust) → Trust Registry (PostgreSQL)
- 📋 **Future migration**: DIDComm to be implemented in Dart (see governance-portal/DIDCOMM_MIGRATION.md)

**Student Vault Profile:**

- ✅ **Drift SQLite** - Local database for user profile
- ✅ **Fields**: firstName, lastName, profilePicPath, currentCompany, currentJobTitle, totalExperienceMonths
- ❌ **No sync with issuance service** - Profile is local only, credentials store issuer data

**Credential Storage:**

- ✅ **Secure storage** - Encrypted credential storage in Student Vault
- ✅ **One credential per university** - Check existence before allowing claim
- ✅ **Credential claim flow**: Dashboard → Tap claim button → Check if exists → Navigate to issuance flow

---

## 3. Application Architecture Standards

### 3.1 Clean Architecture Principles

All Flutter applications (Student Vault App, Verifier Portal, Governance Portal) MUST follow clean architecture:

```
lib/
├── core/                           # Shared foundation
│   ├── app/                        # App initialization & routing
│   ├── design_system/              # Reusable UI components
│   ├── domain/                     # Core business entities
│   ├── infrastructure/             # Cross-cutting concerns
│   ├── navigation/                 # Routing logic
│   └── services/                   # Global services
│
└── features/                       # Feature modules
    └── feature_name/
        ├── data/                   # Data layer
        │   ├── datasources/        # API clients, local storage
        │   ├── models/             # DTOs (Data Transfer Objects)
        │   └── repositories/       # Repository implementations
        │
        ├── domain/                 # Domain layer
        │   ├── entities/           # Business objects
        │   ├── repositories/       # Repository interfaces
        │   └── usecases/           # Business logic
        │
        └── presentation/           # Presentation layer
            ├── screens/            # Full pages
            ├── widgets/            # Feature-specific widgets
            └── providers/          # State management (Riverpod)
```

#### Layer Responsibilities

**Domain Layer (Innermost):**

- Pure business logic
- No dependencies on outer layers
- Defines repository interfaces
- Contains entities and use cases
- Framework-agnostic

**Data Layer:**

- Implements repository interfaces
- Handles data sources (API, local storage)
- Data transformation (DTO ↔ Entity)
- Caching strategies

**Presentation Layer:**

- UI components and screens
- State management
- User input handling
- Calls use cases from domain layer
- Never directly accesses data sources

**Core Layer:**

- Shared across all features
- Design system components
- Global services
- Utilities and extensions
- Navigation logic

### 3.2 Dependency Rules

1. **Dependencies point inward**: Outer layers depend on inner layers, never the reverse
2. **Domain is independent**: Domain layer has zero external dependencies
3. **Data implements domain**: Data layer implements interfaces defined in domain
4. **Presentation uses domain**: Presentation calls use cases, never data sources directly

### 3.3 Student Vault App Architecture

```
lib/
├── core/
│   ├── app/
│   │   └── presentation/           # App initialization, splash screen
│   ├── design_system/
│   │   ├── buttons/
│   │   ├── loaders/
│   │   ├── scaffolds/
│   │   └── themes/
│   ├── domain/
│   │   └── models/                 # Shared domain models
│   ├── infrastructure/
│   │   ├── configuration/
│   │   ├── exceptions/
│   │   ├── extensions/
│   │   ├── providers/
│   │   └── utils/
│   ├── navigation/
│   │   └── routes/
│   └── services/
│       ├── network_connectivity_service/
│       └── notification_service/
│
└── features/
    ├── credentials/                # Credential management
    │   ├── data/
    │   │   ├── datasources/        # Vault API, local storage
    │   │   ├── models/             # CredentialModel (DTO)
    │   │   └── repositories/       # CredentialRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/           # Credential (entity)
    │   │   ├── repositories/       # ICredentialRepository (interface)
    │   │   └── usecases/           # GetCredentials, SaveCredential
    │   └── presentation/
    │       ├── screens/            # CredentialsListScreen, CredentialDetailScreen
    │       ├── widgets/            # CredentialCard, CredentialBadge
    │       └── providers/          # CredentialsProvider (Riverpod)
    │
    ├── issuance/                   # Credential issuance flow
    │   ├── data/
    │   │   ├── datasources/        # DIDComm client
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/           # CredentialOffer
    │   │   ├── repositories/
    │   │   └── usecases/           # AcceptCredentialOffer
    │   └── presentation/
    │       ├── screens/            # IssuanceFlowScreen
    │       └── providers/
    │
    ├── verification/               # Credential sharing/presentation
    │   ├── data/
    │   ├── domain/
    │   │   └── usecases/           # ShareCredential, ScanQRCode
    │   └── presentation/
    │       ├── screens/            # QRScannerScreen, ShareScreen
    │       └── widgets/
    │
    └── profile/                    # User profile
        ├── data/
        ├── domain/
        └── presentation/
```

### 3.4 Verifier Portal Architecture (Flutter Web)

**Overview**: Nova Corp career portal for job applications with educational credential verification via DIDComm.

**User Flow**:

1. Browse job listings (no authentication required)
2. View job details with requirements
3. Submit application with QR code for credential sharing
4. Share verifiable educational credentials via Student Vault App
5. Verification against trust registry
6. Application status updated in real-time

**Technology Stack**:

- Flutter Web with Riverpod state management
- GoRouter for navigation
- DIDComm packages (affinidi_tdk_vdsp, ssi, dcql, didcomm)
- qr_flutter for QR code generation
- Clean Architecture pattern

**Architecture**:

```
lib/
├── main.dart                       # App entry with ProviderScope
│
├── core/
│   ├── app/
│   │   └── presentation/
│   │       └── app.dart           # MaterialApp.router setup
│   ├── design_system/
│   │   └── theme/
│   │       └── app_theme.dart     # Material Design 3 theme
│   ├── domain/
│   │   ├── result.dart            # Result<T, E> for error handling
│   │   └── failures.dart          # Failure hierarchy
│   ├── infrastructure/
│   │   ├── config/
│   │   │   └── app_config.dart    # Environment config (DIDs, URLs)
│   │   └── didcomm/
│   │       └── didcomm_service.dart  # DIDComm operations
│   └── navigation/
│       └── app_router.dart        # GoRouter configuration
│
└── features/
    ├── jobs/                       # Job listings feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── jobs_local_datasource.dart  # Mock job data
    │   │   └── repositories/
    │   │       └── jobs_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── job_opening.dart           # JobOpening entity
    │   │   ├── repositories/
    │   │   │   └── jobs_repository.dart       # JobsRepository
    │   │   └── usecases/
    │   │       └── jobs_usecases.dart         # GetJobs, GetJobById, SearchJobs
    │   └── presentation/
    │       ├── screens/
    │       │   ├── jobs_list_screen.dart      # Job listings with search
    │       │   └── job_details_screen.dart    # Job details + apply button
    │       ├── widgets/
    │       │   └── job_card.dart              # Reusable job card
    │       └── providers/
    │           └── jobs_providers.dart        # Riverpod providers
    │
    └── job_application/            # Application + verification flow
        └── presentation/
            └── screens/
                └── job_application_screen.dart  # Form + QR + verification status
```

**Key Features**:

- **6 Mock Job Listings**: Senior Software Engineer, Product Manager, UX/UI Designer, DevOps Engineer, Business Development Manager, Data Scientist
- **Real-time Verification**: StreamProvider for credential verification status updates
- **QR Code Generation**: Client-side OOB invitation generation
- **Form Validation**: Name, email, phone validation with resume/cover letter uploads
- **Credential Display**: Shows verified degree and university on successful verification
- **Clean Architecture**: Strict layer separation (domain → data → presentation)

### 3.5 Governance Portal Architecture (Flutter Web)

**Current Architecture:**

```
Governance Portal (Flutter/Dart)
        ↓ (REST API)
Trust Registry API Service (Rust)
        ↓ (DIDComm)
Affinidi Trust Registry
```

**Instance Structure:**

```
governance-portal/
├── code/                  # Shared Flutter Web codebase
├── data/                  # Configuration templates
└── instances/
    ├── hk-ministry/       # HK Ministry (Port 3401)
    ├── macau-ministry/    # Macau Ministry (Port 3402)
    └── sg-ministry/       # Singapore Ministry (Port 3403)
```

**Application Structure:**

```
lib/
├── core/
│   ├── app/
│   │   └── presentation/
│   │       ├── app.dart            # MaterialApp configuration
│   │       └── app_controller.dart # Global app state
│   ├── design_system/
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── cards/
│   │   │   ├── info_card.dart
│   │   │   └── data_card.dart
│   │   ├── inputs/
│   │   │   ├── text_field.dart
│   │   │   ├── dropdown.dart
│   │   │   └── search_bar.dart
│   │   ├── loaders/
│   │   │   ├── circular_loader.dart
│   │   │   └── skeleton_loader.dart
│   │   ├── scaffolds/
│   │   │   ├── admin_scaffold.dart
│   │   │   └── dashboard_layout.dart
│   │   └── themes/
│   │       ├── app_theme.dart
│   │       ├── colors.dart
│   │       └── typography.dart
│   ├── domain/
│   │   └── models/
│   │       ├── result.dart         # Result<T, E> type
│   │       └── failure.dart        # Error handling
│   ├── infrastructure/
│   │   ├── configuration/
│   │   │   └── env_config.dart     # Environment configuration
│   │   ├── exceptions/
│   │   │   ├── network_exception.dart
│   │   │   └── api_exception.dart
│   │   ├── extensions/
│   │   │   ├── string_extensions.dart
│   │   │   ├── date_extensions.dart
│   │   │   └── list_extensions.dart
│   │   ├── providers/
│   │   │   ├── dio_provider.dart   # HTTP client
│   │   │   └── storage_provider.dart
│   │   └── utils/
│   │       ├── validators.dart
│   │       ├── formatters.dart
│   │       └── constants.dart
│   ├── navigation/
│   │   ├── app_router.dart         # Go Router configuration
│   │   └── routes/
│   │       ├── admin_routes.dart
│   │       └── auth_routes.dart
│   └── services/
│       ├── analytics_service/      # Analytics tracking
│       ├── auth_service/           # Authentication (future)
│       └── logging_service/        # Logging
│
└── features/
    ├── dashboard/                  # Main dashboard
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── stats_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── registry_stats_model.dart
    │   │   └── repositories/
    │   │       └── dashboard_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── registry_stats.dart
    │   │   ├── repositories/
    │   │   │   └── dashboard_repository.dart
    │   │   └── usecases/
    │   │       ├── get_registry_stats.dart
    │   │       └── get_recent_activity.dart
    │   └── presentation/
    │       ├── screens/
    │       │   └── dashboard_screen.dart
    │       ├── widgets/
    │       │   ├── stats_card.dart
    │       │   ├── activity_feed.dart
    │       │   └── registry_selector.dart
    │       └── providers/
    │           └── dashboard_provider.dart
    │
    ├── registries/                 # Registry management
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── registry_remote_datasource.dart
    │   │   │   └── registry_local_datasource.dart
    │   │   ├── models/
    │   │   │   ├── registry_model.dart
    │   │   │   └── registry_config_model.dart
    │   │   └── repositories/
    │   │       └── registry_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── registry.dart
    │   │   │   └── registry_config.dart
    │   │   ├── repositories/
    │   │   │   └── registry_repository.dart
    │   │   └── usecases/
    │   │       ├── get_all_registries.dart
    │   │       ├── select_registry.dart
    │   │       └── update_registry_config.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── registries_list_screen.dart
    │       │   └── registry_detail_screen.dart
    │       ├── widgets/
    │       │   ├── registry_card.dart
    │       │   └── registry_status_badge.dart
    │       └── providers/
    │           └── registries_provider.dart
    │
    ├── issuers/                    # Issuer management
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── issuer_remote_datasource.dart
    │   │   ├── models/
    │   │   │   ├── issuer_model.dart
    │   │   │   └── issuer_assertion_model.dart
    │   │   └── repositories/
    │   │       └── issuer_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── issuer.dart
    │   │   │   └── issuer_assertion.dart
    │   │   ├── repositories/
    │   │   │   └── issuer_repository.dart
    │   │   └── usecases/
    │   │       ├── get_issuers.dart
    │   │       ├── get_issuer_details.dart
    │   │       ├── add_issuer.dart
    │   │       ├── update_issuer.dart
    │   │       └── remove_issuer.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── issuers_list_screen.dart
    │       │   ├── issuer_detail_screen.dart
    │       │   └── add_issuer_screen.dart
    │       ├── widgets/
    │       │   ├── issuer_card.dart
    │       │   ├── issuer_form.dart
    │       │   └── assertion_list.dart
    │       └── providers/
    │           └── issuers_provider.dart
    │
    ├── verifiers/                  # Verifier management
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── verifier_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── verifier_model.dart
    │   │   └── repositories/
    │   │       └── verifier_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── verifier.dart
    │   │   ├── repositories/
    │   │   │   └── verifier_repository.dart
    │   │   └── usecases/
    │   │       ├── get_verifiers.dart
    │   │       ├── add_verifier.dart
    │   │       └── update_verifier.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── verifiers_list_screen.dart
    │       │   └── verifier_detail_screen.dart
    │       ├── widgets/
    │       │   └── verifier_card.dart
    │       └── providers/
    │           └── verifiers_provider.dart
    │
    ├── schemas/                    # Credential schema management
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── schema_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── credential_schema_model.dart
    │   │   └── repositories/
    │   │       └── schema_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── credential_schema.dart
    │   │   ├── repositories/
    │   │   │   └── schema_repository.dart
    │   │   └── usecases/
    │   │       ├── get_schemas.dart
    │   │       ├── add_schema.dart
    │   │       └── validate_schema.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── schemas_list_screen.dart
    │       │   └── schema_detail_screen.dart
    │       ├── widgets/
    │       │   ├── schema_card.dart
    │       │   └── schema_viewer.dart
    │       └── providers/
    │           └── schemas_provider.dart
    │
    └── query/                      # TRQP query interface
        ├── data/
        │   ├── datasources/
        │   │   └── trqp_remote_datasource.dart
        │   ├── models/
        │   │   ├── query_request_model.dart
        │   │   └── query_response_model.dart
        │   └── repositories/
        │       └── query_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── query_request.dart
        │   │   └── query_response.dart
        │   ├── repositories/
        │   │   └── query_repository.dart
        │   └── usecases/
        │       ├── execute_trqp_query.dart
        │       └── validate_query.dart
        └── presentation/
            ├── screens/
            │   └── query_tester_screen.dart
            ├── widgets/
            │   ├── query_builder.dart
            │   ├── query_result_viewer.dart
            │   └── query_history.dart
            └── providers/
                └── query_provider.dart
```

#### Key Features for Governance Portal

**Dashboard:**

- Overview of connected Trust Registry
- Real-time statistics (record counts)
- Recent activity feed
- Quick actions (add/refresh records)

**Registry Management:**

- View registry configuration
- Monitor registry health
- Test DIDComm connectivity

**Record Management:**

- List all assertion records
- Add new records (authority, entity, action, resource)
- Update existing records
- Delete records with confirmation
- Bulk operations

**Query Interface:**

- Test Recognition queries
- Test Authorization queries
- View formatted JSON responses
- Query history

**Instance Configuration:**
Each ministry instance has:

- Unique port (HK: 3401, Macau: 3402, SG: 3403)
- Ministry-specific branding (name, logo, colors)
- Backend API endpoint configuration
- Environment-based settings

**Future Enhancement:**

- Direct DIDComm connection (see DIDCOMM_MIGRATION.md)
- Eliminates Rust backend dependency
- Native Dart DIDComm implementation

---

## 4. UI/UX Standards

- Export query history

### 3.6 Backend Services Architecture (MVC)

Both HK and Macau issuance services follow Model-View-Controller pattern:

```
lib/
├── models/              # Data models
│   ├── student.dart
│   ├── credential.dart
│   ├── credential_offer.dart
│   └── didcomm_message.dart
│
├── controllers/         # Request handlers
│   ├── student_controller.dart
│   ├── credential_controller.dart
│   ├── didcomm_controller.dart
│   └── health_controller.dart
│
├── views/              # Response formatters
│   ├── api_response.dart
│   └── error_response.dart
│
├── services/           # Business logic
│   ├── credential_service.dart
│   ├── didcomm_service.dart
│   ├── trust_registry_service.dart
│   ├── signing_service.dart
│   └── database_service.dart
│
├── middleware/         # Cross-cutting concerns
│   ├── auth_middleware.dart
│   ├── logging_middleware.dart
│   └── error_middleware.dart
│
├── routes/             # API routing
│   └── api_routes.dart
│
├── config/             # Configuration
│   ├── database_config.dart
│   ├── did_config.dart
│   └── env_config.dart
│
└── utils/              # Utilities
    ├── validators.dart
    └── constants.dart
```

---

## 4. Technical Requirements

### 4.1 Flutter Applications Standards

All Flutter apps (Student Vault, Verifier Portal, Governance Portal) must follow:

#### Code Organization

1. **Feature-based structure**: Group by feature, not by type
2. **Clean Architecture layers**: Domain → Data → Presentation
3. **Dependency injection**: Use Riverpod for DI
4. **State management**: Riverpod with code generation
5. **Routing**: Go Router for declarative routing

#### Code Quality

1. **Type safety**: All variables properly typed, no `dynamic`
2. **Null safety**: Strict null safety enabled
3. **Immutability**: Use `@immutable` and `const` where possible
4. **Documentation**: Dartdoc comments for all public APIs
5. **Testing**: Unit tests for business logic (80% coverage minimum)

#### Architecture Patterns

1. **Repository pattern**: Abstract data sources
2. **Use case pattern**: Single responsibility business logic
3. **Provider pattern**: State management
4. **Factory pattern**: Object creation
5. **Dependency inversion**: Depend on abstractions, not implementations

#### File Naming Conventions

- Entities: `job_opening.dart`
- Models (DTOs): `job_opening_model.dart`
- Repositories (interfaces): `jobs_repository.dart`
- Repository implementations: `jobs_repository_impl.dart`
- Use cases: `get_job_listings.dart`
- Providers: `jobs_provider.dart`
- Screens: `job_listings_screen.dart`
- Widgets: `job_card.dart`

### 4.2 Code Quality Requirements

1. **No Legacy References**
   - Search and remove all occurrences of: Sweet Lane, Ayra Forum
   - Replace with university-specific or generic terms

2. **Type Safety**
   - All Dart code must have proper type annotations
   - Enable strict mode in `analysis_options.yaml`

3. **Documentation**
   - All public APIs must have dartdoc comments
   - Architecture diagrams in `/docs`

4. **Testing**
   - Unit tests for all business logic
   - Minimum 80% code coverage

5. **Error Handling**
   - Proper exception types for domain errors
   - Logging for debugging

### 4.3 Security Requirements

1. **Credential Security**
   - Credentials must be signed with proper cryptographic keys
   - No credentials in logs or error messages

2. **DIDComm Communication**
   - All credential exchanges via encrypted DIDComm protocol
   - Prevent man-in-the-middle attacks

3. **Trust Registry Validation**
   - Always verify issuer/verifier is registered in trust registry
   - Validate credential expiration and revocation status

4. **API Security**
   - Authentication for admin endpoints
   - Input validation and sanitization

### 4.4 Performance Requirements

1. **Response Times**
   - Job listings page: < 500ms load time
   - Trust registry admin dashboard: < 800ms load time
   - Mobile app startup: < 1 second

2. **Scalability**
   - Support 10,000+ students per university
   - Handle 100+ concurrent trust registry queries
   - Efficient credential storage and retrieval

---

## 5. Technical Stack

### Frontend (Flutter)

- **Framework:** Flutter 3.x
- **State Management:** Riverpod
- **HTTP Client:** Dio
- **QR Code:** qr_flutter, mobile_scanner
- **Secure Storage:** flutter_secure_storage
- **Routing:** Go Router
- **DIDComm:** Custom Dart implementation

### Backend (Dart)

- **Framework:** Shelf (HTTP server)
- **Database:** PostgreSQL / SQLite
- **DID Management:** Custom implementation
- **Cryptography:** pointycastle
- **Testing:** test package

### Infrastructure

- **Container:** Docker
- **Orchestration:** Docker Compose
- **Tunneling:** ngrok (for local development)
- **Trust Registry:** Rust (Affinidi implementation)

---

## 6. Refactoring Tasks

### Phase 1: Cleanup (Priority: High)

- [x] Search and remove all Sweet Lane references
- [x] Remove Ayra Forum logic
- [x] Remove conglomerate/group entity logic
- [x] Update environment variable names
- [x] Clean up unused code and assets

### Phase 2: Rename & Restructure (Priority: High)

- [x] Rename `hk-issuance-service` → `university-issuance-service` (single codebase)
- [x] Create 2 instances: hk-university, macau-university
- [x] Restructure verifier-portal to clean architecture
- [x] Restructure governance-portal to instance-based architecture (code/, data/, instances/)
- [x] Remove organization selection from student-vault-app
- [x] Add user profile with Drift storage
- [x] Update dashboard with credential claim buttons

### Phase 3: Trust Registry (Priority: High)

- [x] Implement three separate trust registry instances (HK, Macau, SG)
- [x] Create PostgreSQL backend for each instance
- [x] Remove CSV data files (manual entry via admin UI)

### Phase 4: Verifier Portal (Priority: Medium)

- [x] Implement job listings UI (clean architecture)
- [x] Implement job details page
- [x] Implement application page with QR code
- [x] Implement credential verification flow
- [x] Add verification status indicators
- [x] Integrate with trust registry

### Phase 5: Governance Portal (Priority: Medium)

- [x] Restructure to instance-based architecture (code/, data/, instances/)
- [x] Create 3 ministry instances (HK, Macau, SG)
- [x] Document DIDComm migration plan (DIDCOMM_MIGRATION.md)
- [ ] Implement instance-specific branding and configuration
- [ ] Test REST API integration with Trust Registry API (Rust)

### Phase 6: Issuance Services (Priority: Medium)

- [x] Implement MVC structure for university issuance service
- [x] Create 2 instances (HK, Macau) with single codebase
- [x] Create credential templates (StudentID, Transcript, Degree)
- [x] Implement DIDComm credential issuance
- [x] Add admin APIs for student management

### Phase 7: Integration & Testing (Priority: High)

- [ ] End-to-end testing: Issue credential → Store → Share → Verify
- [ ] Test all three trust registries
- [ ] Test both universities independently
- [ ] Test job application flow

---

## 13. Setup and Deployment

### 13.1 Prerequisites

**Required Software:**

- Docker Desktop (v20.10+) with Compose plugin
- Node.js 18+ (for domain setup)
- Rust 1.70+ (for trust registry API)
- Dart 3.0+ (for issuance services)
- Flutter 3.10+ (for web and mobile apps)
- Git (for cloning Trust Registry repository)

**Required Accounts & Credentials:**

- ngrok account with auth token ([Get token](https://dashboard.ngrok.com/get-started/your-authtoken))
- Affinidi DIDComm Mediator configured ([Setup guide](https://docs.affinidi.com/products/affinidi-messaging/didcomm-mediator/))
- Affinidi Meetingplace Control Plane configured ([Setup guide](https://docs.affinidi.com/products/affinidi-messaging/meeting-place/))

**System Requirements:**

- RAM: Minimum 8GB (16GB recommended)
- Disk: At least 10GB free space
- Network: Stable internet connection

### 13.2 Quick Start (All Services)

The setup script follows a standardized pattern for consistent configuration:

```bash
# 1. Clone repository
git clone <repo-url>
cd affinidi-labs-education-trust-network

# 2. Run automated setup script
./setup.sh
```

**The setup script will:**

1. ✅ Create `.env` from `.env.example` if not present
2. ✅ Prompt for required credentials:
   - `SERVICE_DID` (Meetingplace Service DID)
   - `MEDIATOR_DID` (DIDComm Mediator DID)
   - `NGROK_AUTH_TOKEN` (if USE_NGROK=true)
3. ✅ Auto-derive configuration values:
   - `MEDIATOR_DOMAIN` from `MEDIATOR_DID`
   - `MEDIATOR_URL` from domain
   - `HK_UNIVERSITY_SERVICE_DID` from `HK_UNIVERSITY_DIDWEB_DOMAIN`
   - `MACAU_UNIVERSITY_SERVICE_DID` from `MACAU_UNIVERSITY_DIDWEB_DOMAIN`
   - `NOVA_CORP_SERVICE_DID` from `NOVA_CORP_DIDWEB_DOMAIN`
4. ✅ Set default Trust Registry URLs (Docker internal network)
5. ✅ Validate Docker is running
6. ✅ Run domain setup (if ngrok enabled)
7. ✅ Run component setup scripts:
   - Trust Registry API
   - University Issuance Service
   - Verifier Portal
   - Student Vault Mobile App

```bash
# 3. Start all services
docker compose up -d --force-recreate

# 4. Verify services are running
docker compose ps

# 5. View logs
docker compose logs -f

# 6. Access services:
# - HK University Issuer: http://localhost:8080
# - Macau University Issuer: http://localhost:8081
# - Nova Corp Verifier: http://localhost:8082
# - HK Ministry TR Admin: http://localhost:3001
# - Macau Ministry TR Admin: http://localhost:3002
# - SG Ministry TR Admin: http://localhost:3003

# 7. Run mobile app
cd student-vault-app/code
flutter run --dart-define-from-file=configurations/.env
```

### 13.3 Setup Script Standards

All component setup scripts follow this pattern:

1. **Environment Check**

   ```bash
   # Check .env exists, create from example
   if [ ! -f ".env" ]; then
       cp .env.example .env
   fi
   ```

2. **Validate Required Variables**

   ```bash
   # Prompt for missing critical variables
   SERVICE_DID=$(grep "^SERVICE_DID=" .env | cut -d '=' -f2)
   if [ -z "$SERVICE_DID" ]; then
       read -p "Please enter SERVICE_DID: " SERVICE_DID
       sed -i.bak "s|^SERVICE_DID=.*|SERVICE_DID=$SERVICE_DID|" .env
       rm -f .env.bak
   fi
   ```

3. **Auto-Derive Configuration**

   ```bash
   # Extract MEDIATOR_DOMAIN from MEDIATOR_DID
   MEDIATOR_DOMAIN=$(echo "$MEDIATOR_DID" | sed 's|^did:web:||')
   sed -i.bak "s|^MEDIATOR_DOMAIN=.*|MEDIATOR_DOMAIN=$MEDIATOR_DOMAIN|" .env
   rm -f .env.bak
   ```

4. **Docker Validation**

   ```bash
   # Ensure Docker is running
   if ! docker info > /dev/null 2>&1; then
       echo "❌ Docker is not running."
       exit 1
   fi
   ```

5. **Component Setup**
   - Run individual component configurations
   - Display progress with clear section headers
   - Confirm successful completion

### 13.4 Running Individual Services

**Option 1: Run specific instance manually**

```bash
# Hong Kong University Issuer
cd university-issuance-service/instances/hk-university
cp .env.example .env
# Edit .env with instance-specific config
docker-compose up -d

# Macau University Issuer
cd university-issuance-service/instances/macau-university
cp .env.example .env
docker-compose up -d

# Hong Kong Ministry Trust Registry
cd governance-portal/instances/hk-ministry
cp .env.example .env
docker-compose up -d
```

**Option 2: Run from main compose with specific service**

```bash
# Run only HK issuer and its dependencies
docker-compose up -d domain-setup hk-trust-registry-db hk-trust-registry hk-university-issuer

# Run only Macau issuer
docker-compose up -d domain-setup macau-trust-registry-db macau-trust-registry macau-university-issuer

# Run all trust registries
docker-compose up -d domain-setup hk-trust-registry-db hk-trust-registry macau-trust-registry-db macau-trust-registry sg-trust-registry-db sg-trust-registry
```

### 13.4 Adding New University Instance

To add a new university (e.g., Singapore University):

1. **Create instance directory:**

```bash
cd university-issuance-service/instances
mkdir sg-university
```

2. **Copy configuration files:**

```bash
cp hk-university/.env.example sg-university/.env.example
cp hk-university/docker-compose.yml sg-university/docker-compose.yml
cp hk-university/README.md sg-university/README.md
```

3. **Update configuration:**
   Edit `sg-university/.env.example`:

```env
PORT=8083
ENTITY_NAME=singapore-university
ENTITY_DISPLAY_NAME=Singapore University
SERVICE_DID=did:web:example.ngrok.io:singapore-university
TRUST_REGISTRY_URL=http://sg-trust-registry:3234
```

4. **Update domain setup:**
   Edit `domain-setup/code/server.js` to add the new service:

```javascript
const SERVICES = [
  // ... existing services
  { name: "SG University Issuer", localPort: 8083, subdomain: "sg-uni" },
];
```

5. **Update main docker-compose.yml:**
   Add the new service definition following the pattern of existing issuers.

6. **Update student-vault-app:**
   Edit `configs/organizations.dart` to add the new university:

```dart
const universities = [
  // ... existing
  Organization(
    id: 'singapore-university',
    name: 'Singapore University',
    did: 'did:web:REPLACE_WITH_DOMAIN:singapore-university',
  ),
];
```

### 13.5 Adding New Trust Registry Instance

To add a new trust registry (e.g., Japan Ministry):

1. **Create Trust Registry API instance:**

```bash
cd governance-portal/instances
mkdir japan-ministry
```

2. **Copy configuration files:**

```bash
cp hk-ministry/.env.example japan-ministry/.env.example
cp hk-ministry/docker-compose.yml japan-ministry/docker-compose.yml
cp hk-ministry/README.md japan-ministry/README.md
```

3. **Update Trust Registry API configuration:**
   Edit `japan-ministry/.env.example`:

```env
PORT=3235
REGISTRY_NAME=Japan Ministry of Education
STORAGE_BACKEND=postgres
DATABASE_URL=postgresql://postgres:postgres@japan-trust-registry-db:5432/trust_registry
```

4. **Create Governance Portal instance:**

```bash
cd governance-portal/instances
mkdir japan-ministry
```

5. **Copy portal configuration:**

```bash
cp hk-ministry/.env.example japan-ministry/.env.example
cp hk-ministry/docker-compose.yml japan-ministry/docker-compose.yml
cp hk-ministry/README.md japan-ministry/README.md
```

6. **Update portal configuration:**
   Edit `japan-ministry/.env.example`:

```env
PORT=3404
MINISTRY_NAME=Japan Ministry of Education
MINISTRY_SHORT_NAME=JP-MOE
COUNTRY_CODE=JP
API_BASE_URL=http://localhost:3235/api
TRUST_REGISTRY_ENDPOINT=http://japan-trust-registry:3235
PRIMARY_COLOR=#BC002D
SECONDARY_COLOR=#FFFFFF
```

7. **Update main docker-compose.yml:**
   Add both Trust Registry API and Portal service definitions.

8. **Update ministries data:**
   Edit `governance-portal/data/ministries.json` to add the new ministry configuration.

### 13.6 Configuration Management

**Main .env (Root):**

- Shared across all services
- Contains global settings (ngrok token, mediator config)
- Used by main `docker-compose.yml`

**Instance .env (Per Service):**

- Instance-specific configuration
- Port assignments
- Entity names and DIDs
- Database credentials

**Priority:** Instance .env overrides main .env

### 13.7 Database Management

**Trust Registry PostgreSQL:**

```bash
# Connect to HK ministry database
docker exec -it nexigen-hk-tr-db psql -U postgres -d hk_trust_registry

# Backup database
docker exec nexigen-hk-tr-db pg_dump -U postgres hk_trust_registry > hk_tr_backup.sql

# Restore database
docker exec -i nexigen-hk-tr-db psql -U postgres hk_trust_registry < hk_tr_backup.sql
```

**Student Vault Drift Database:**

- Located on device: `/data/data/com.nexigen.student_vault/databases/nexigen_student_vault.sqlite`
- Managed by Drift ORM
- No manual intervention required

### 13.8 Monitoring and Logs

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f hk-university-issuer
docker-compose logs -f hk-trust-registry

# View database logs
docker-compose logs -f hk-trust-registry-db
```

### 13.9 Cleanup

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v

# Run cleanup script
./cleanup.sh
```

### 13.10 Production Considerations

**Security:**

- ❌ Do NOT use default PostgreSQL passwords in production
- ✅ Use secrets management (Docker secrets, vault)
- ✅ Enable TLS for all external communications
- ✅ Implement rate limiting on APIs

**Scalability:**

- Single codebase architecture allows horizontal scaling
- Run multiple instances behind load balancer
- PostgreSQL read replicas for trust registries
- CDN for static assets

**Monitoring:**

- Implement health check endpoints
- Use Prometheus + Grafana for metrics
- Centralized logging with ELK stack
- Alert on database connection failures

**Backup Strategy:**

- Daily PostgreSQL backups
- Store backups in S3 or equivalent
- Test restoration procedures regularly
- Keep 30-day retention policy
- [ ] Test trust registry admin operations
- [ ] Performance testing

### Phase 8: Documentation (Priority: Medium)

- [ ] Update README files
- [ ] Create architecture diagrams
- [ ] Write API documentation
- [ ] Create developer setup guide
- [ ] Create demo script
- [ ] Document trust registry admin features

---

## 7. Success Criteria

### Functional Success

✅ Students can receive credentials from HK and Macau universities independently  
✅ Students can store multiple credentials in wallet  
✅ Students can scan QR code and share degree credential with Nova Corp  
✅ Nova Corp can verify credentials from both universities  
✅ Trust registry validates all issuers correctly  
✅ Admin can manage trust registries through web interface  
✅ Admin can add/remove issuers and verifiers  
✅ Admin can test TRQP queries interactively

### Technical Success

✅ All Flutter apps follow clean architecture  
✅ No Sweet Lane or Ayra Forum references  
✅ 80%+ code coverage for business logic  
✅ All services start via Docker Compose  
✅ Performance targets met  
✅ Security requirements satisfied

### User Experience Success

✅ Intuitive mobile app for students  
✅ Professional job portal for Nova Corp  
✅ User-friendly admin interface for registry management  
✅ Clear error messages and feedback  
✅ Responsive UI on all devices

---

## 8. Appendix

### 8.1 Credential Types

**StudentIDCredential:**

- Student ID number
- Full name
- University name
- Program
- Enrollment date
- Status (active/graduated)

**TranscriptCredential:**

- Student ID
- List of courses with grades
- GPA
- Semester information
- Issued date

**DegreeCredential:**

- Student ID
- Full name
- Degree type (Bachelor, Master, PhD)
- Major/Field of study
- Graduation date
- GPA
- Honors/Distinctions

### 8.2 Trust Registry Assertions

**Issuers (Universities):**

- `issue:student:id` - Can issue student ID credentials
- `issue:student:transcript` - Can issue transcript credentials
- `issue:student:degree` - Can issue degree credentials

**Verifiers (Employers):**

- `verify:employment:degree` - Can verify degree credentials
- `verify:employment:transcript` - Can verify transcript credentials

### 8.3 DID Web Structure

**Hong Kong University:**

```
did:web:<ngrok-domain>:hongkong-university
```

**Macau University:**

```
did:web:<ngrok-domain>:macau-university
```

**Nova Corp:**

```
did:web:<ngrok-domain>:nova-corp
```

**Ministry DIDs:**

```
did:web:hk-ministry.example.com
did:web:macau-ministry.example.com
did:web:sg-ministry.example.com
```

---

**Document Version:** 2.0  
**Last Updated:** [Current Date]  
**Next Review:** After Phase 2 completion
