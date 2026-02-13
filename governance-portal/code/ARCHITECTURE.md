# Trust Registry Admin Web App - Architecture

## System Overview

```
┌─────────────────────┐
│  Trust Registry 1   │ ← DIDComm server (admin) + HTTP server (TRQP queries)
│  - Admin DID        │
│  - Query URL        │
└─────────────────────┘
          ↑
          │ DIDComm
          │
┌─────────────────────┐
│  Trust Registry 2   │
│  - Admin DID        │
│  - Query URL        │
└─────────────────────┘
          ↑
          │ DIDComm
          │
┌─────────────────────────────────────────────────────────┐
│  REST API Mediator (Rust - trust-registry-admin-rest-api-rs)  │
│  - Translates REST → DIDComm                            │
│  - Manages multiple trust registry configurations       │
│  - Port: 8080                                          │
└─────────────────────────────────────────────────────────┘
          ↑
          │ HTTP/REST
          │
┌─────────────────────────────────────────────────────────┐
│  Web App (Flutter - trust-registry-admin-web-app-dart) │
│  - Dashboard UI                                         │
│  - Fixed API endpoint: http://localhost:8080/api       │
│  - Manages registries via REST API                     │
└─────────────────────────────────────────────────────────┘
```

## Key Architectural Points

1. **Single REST API Backend**: The web app connects to ONE fixed REST API endpoint (configured in web/config.json)

2. **Registry Management**: Trust registries are added/configured via the web app, stored in the REST API backend

3. **Registry Selection**: When performing operations, the web app specifies which registry to use, and the REST API routes the request appropriately

## API Endpoints

### Registry Management
- `GET /api/registries` - List all configured registries
- `POST /api/registries` - Add new registry (requires: name, admin_did, query_url, description)
- `PUT /api/registries/{id}` - Update registry
- `DELETE /api/registries/{id}` - Remove registry

### Record Operations (per registry)
- `GET /api/registries/{registry_id}/records` - List records
- `POST /api/registries/{registry_id}/records` - Create record
- `PUT /api/registries/{registry_id}/records` - Update record
- `DELETE /api/registries/{registry_id}/records` - Delete record
- `POST /api/registries/{registry_id}/records/query` - Query record

### TRQP Queries (per registry)
- `POST /api/registries/{registry_id}/recognition` - Recognition query
- `POST /api/registries/{registry_id}/authorization` - Authorization query

## Configuration Files

### Web App: `web/config.json`
```json
{
  "apiBaseUrl": "http://localhost:8080/api"
}
```

### Web App: `.env`
```
API_BASE_URL=http://localhost:8080/api
```

### REST API: `.env` (Rust project)
This file will need to support multiple trust registries. Example structure:
```
SERVER_PORT=8080

# Trust Registry 1
TR1_NAME=Production Registry
TR1_ADMIN_DID=did:web:example.com:trust-registry:prod
TR1_QUERY_URL=http://tr1.example.com:3232
TR1_MEDIATOR_DID=did:web:mediator.example.com

# Trust Registry 2
TR2_NAME=Development Registry
TR2_ADMIN_DID=did:web:example.com:trust-registry:dev
TR2_QUERY_URL=http://tr2.example.com:3232
TR2_MEDIATOR_DID=did:web:mediator.example.com
```

## Data Flow Examples

### Adding a Trust Registry
1. User fills form in web app with registry details (name, admin DID, query URL)
2. Web app sends `POST /api/registries` to REST API
3. REST API stores configuration and returns success
4. Web app refreshes dashboard showing new registry

### Creating a Record
1. User selects registry from dashboard
2. User fills record form
3. Web app sends `POST /api/registries/{registry_id}/records`
4. REST API:
   - Looks up registry config
   - Converts REST to DIDComm message
   - Sends to trust registry via DIDComm
   - Returns response
5. Web app updates UI

### Testing TRQP Query
1. User selects registry from test page
2. User fills query form (authority_id, entity_id, action, resource)
3. Web app sends `POST /api/registries/{registry_id}/recognition`
4. REST API:
   - Looks up registry config
   - Makes HTTP request to trust registry's query URL
   - Returns result
5. Web app displays JSON response

## Trust Registry Model

```dart
class TrustRegistry {
  final String id;           // UUID
  final String name;         // Display name
  final String adminDid;     // DID web for admin operations
  final String queryUrl;     // HTTP URL for TRQP queries
  final String? description; // Optional description
  final DateTime createdAt;  // Creation timestamp
}
```

## Next Steps for REST API Implementation

Your Rust REST API needs to:

1. **Add registry management endpoints** (`/api/registries/*`)
2. **Store registry configurations** (in-memory, file, or database)
3. **Accept registry_id in existing endpoints** (update routes to include `/{registry_id}/`)
4. **Route operations to correct trust registry** based on selected registry_id

