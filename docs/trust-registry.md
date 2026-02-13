# Trust Registry

## Overview

Trust registries store assertions about issuers and verifiers, enabling participants to verify each other's legitimacy.

## Architecture

### Trust Registry Service (Rust)
- Stores assertion records
- Accepts DIDComm messages
- Validates requests via DID signatures

### Governance Portal (Flutter/Dart)
- Admin UI for managing records
- Direct DIDComm communication (no REST intermediary)
- Multi-instance support (HK, Macau, SG)

### Trust Registry Admin API (Rust)
- Optional REST API wrapper
- Provides HTTP endpoints for non-DIDComm clients

## Record Structure

```json
{
  "id": "uuid",
  "issuerDid": "did:peer:2.Vz6Mk...",
  "subjectDid": "did:peer:2.Vz6Mk...",
  "assertionType": "CredentialIssuer",
  "credentialTypes": ["UniversityDegreeCredential"],
  "status": "active",
  "createdAt": "2025-01-01T00:00:00Z",
  "updatedAt": "2025-01-01T00:00:00Z"
}
```

## Operations

### Create Record
```dart
await trAdminClient.createRecord(
  issuerDid: 'did:peer:2.Vz6Mk...',
  subjectDid: 'did:peer:2.Vz6Mk...',
  assertionType: 'CredentialIssuer',
  credentialTypes: ['UniversityDegreeCredential'],
);
```

### Update Record
```dart
await trAdminClient.updateRecord(
  recordId: 'uuid',
  status: 'inactive',
);
```

### Delete Record
```dart
await trAdminClient.deleteRecord(recordId: 'uuid');
```

### Read Record
```dart
final record = await trAdminClient.readRecord(recordId: 'uuid');
```

### List Records
```dart
final records = await trAdminClient.listRecords();
```

## DIDComm Protocol

### Message Types
- `tr-admin/1.0/create-record`
- `tr-admin/1.0/update-record`
- `tr-admin/1.0/delete-record`
- `tr-admin/1.0/read-record`
- `tr-admin/1.0/list-records`

### Request Format
```json
{
  "id": "message-uuid",
  "type": "tr-admin/1.0/create-record",
  "from": "did:peer:2.Vz6Mk...",
  "to": ["did:peer:2.Vz6Mk..."],
  "body": {
    "issuerDid": "did:peer:2.Vz6Mk...",
    "subjectDid": "did:peer:2.Vz6Mk...",
    "assertionType": "CredentialIssuer",
    "credentialTypes": ["UniversityDegreeCredential"]
  }
}
```

### Response Format
```json
{
  "id": "response-uuid",
  "type": "tr-admin/1.0/create-record/response",
  "threadId": "message-uuid",
  "from": "did:peer:2.Vz6Mk...",
  "to": ["did:peer:2.Vz6Mk..."],
  "body": {
    "record": { ... }
  }
}
```

## Multi-Instance Setup

### Instance Configuration

Each ministry has its own:
- Trust registry service
- Portal instance
- DID configuration

**Instances:**
- HK Ministry (Port 3401)
- Macau Ministry (Port 3402)
- SG Ministry (Port 3403)

### Configuration Files

**Portal: `.env`**
```env
MINISTRY_NAME=Hong Kong Education Bureau
TRUST_REGISTRY_DID=did:peer:2.Vz6Mk...
MEDIATOR_DID=did:peer:2.Vz6Mk...
MEDIATOR_URL=https://apse1.mediator.affinidi.io/
```

**Portal: `user_config.json`**
```json
{
  "did:peer:2.Vz6Mk...": {
    "alias": "HK Admin Portal",
    "secrets": [...]
  }
}
```

## Implementation Details

### Dart Implementation (Portal)

**Key Classes:**
- `TrAdminClient` - DIDComm client
- `UserConfig` - Configuration loader
- `DidManagerLoader` - Key importer
- `RecordsRemoteDataSource` - Repository pattern adapter

**Message Correlation:**
- 30-second timeout per request
- UUID v4 for message IDs
- Completer-based async response handling

### Rust Implementation (Backend API)

**Key Components:**
- `TDKProfile` - DID and key management
- Message handlers for each operation
- JSON storage backend

## Security

### Authentication
- All requests must be signed with admin DID
- Trust registry validates signature before processing

### Authorization
- Only configured admin DIDs can manage records
- Admin DIDs stored in trust registry configuration

### Key Management
- Admin keys in `user_config.json`
- Separate keys per environment
- Keys never exposed in logs or responses

## Troubleshooting

### Portal won't connect
- Verify `user_config.json` exists and valid
- Check trust registry DID in .env
- Ensure mediator URL is accessible

### Records not created
- Verify admin DID is authorized
- Check message signature
- Review trust registry logs

### Timeout errors
- Check network connectivity
- Verify mediator is operational
- Consider increasing timeout
