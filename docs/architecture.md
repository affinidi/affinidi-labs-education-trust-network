# Architecture

## System Overview

Nexigen uses DIDComm protocol and trust registries for credential issuance and verification.

```
Trust Registries (HK, Macau, SG)
        │
    ┌───┴───┐
Issuers     Verifiers
    │           │
    └─── Student ───┘
         Vault
```

## Components

### Student Vault App
- **Tech**: Flutter (Clean Architecture)
- **Purpose**: Store and share credentials
- **DIDComm**: Receives credentials from issuers, presents to verifiers

### University Issuance Services
- **Tech**: Dart/Shelf (MVC pattern)
- **Instances**: HK University, Macau University
- **DIDComm**: Issues credentials via VDIP protocol

### Verifier Portal
- **Tech**: Flutter Web (Clean Architecture)
- **Purpose**: Employer verification interface
- **DIDComm**: Requests and verifies presentations

### Governance Portal
- **Tech**: Flutter Web (Clean Architecture)
- **Purpose**: Manage trust registry records
- **DIDComm**: Direct communication with trust registry (tr-admin/1.0 protocol)
- **Config**: Uses `user_config.json` for persistent did:peer identity

### Trust Registry Admin API
- **Tech**: Rust
- **Purpose**: Backend API for trust registry operations
- **Config**: Uses `user_config.json` for DID configuration

## DIDComm Protocols

### VDIP (Verifiable Data Issuance Protocol)
Used by issuers to deliver credentials to wallet.

### Trust Registry Admin Protocol (tr-admin/1.0)
Used by portals to manage trust registry records:
- create-record
- update-record
- delete-record
- read-record
- list-records

## Data Flow

1. **Credential Issuance**
   ```
   Issuer → VDIP → Student Vault
   ```

2. **Credential Verification**
   ```
   Student Vault → Presentation → Verifier Portal
   Verifier Portal → Trust Registry → Validation
   ```

3. **Trust Registry Management**
   ```
   Admin Portal → DIDComm (tr-admin/1.0) → Trust Registry
   ```

## Key Design Decisions

### Clean Architecture for Flutter Apps
- Domain layer has zero external dependencies
- Repository pattern for data access
- Riverpod for state management

### MVC for Backend Services
- Controllers handle HTTP requests
- Services contain business logic
- Models define data structures

### File-Based DID Configuration
- Both Rust and Dart use `user_config.json`
- Ensures identity consistency across services
- Supports did:peer with multiple key types (Ed25519, secp256k1, P-256/384/521)

### Direct DIDComm Implementation
- No REST API intermediary for Governance Portal
- Reduces network hops and latency
- Full DIDComm v2 implementation in Dart
