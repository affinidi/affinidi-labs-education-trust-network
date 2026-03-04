# Troubleshooting Guide

This guide covers common issues and their solutions across the Nexigen Demo project.

## Table of Contents

- [DIDComm Issues](#didcomm-issues)
- [CORS Issues](#cors-issues)
- [Setup Issues](#setup-issues)
- [Network Issues](#network-issues)
- [Docker Issues](#docker-issues)

---

## DIDComm Issues

### No Matching Key Agreement Keys Found

**Error**: `Exception: No matching key agreement keys found for the mediator and the recipient.`

**Symptoms**:
- Governance portal fails to start
- DIDComm message encryption fails
- Connection to mediator fails

**Root Cause**:
The `user_config.json` file contains a `did:peer:2` DID that includes X25519 and Ed25519 keys encoded in the DID itself, but the secrets array only includes P-256 and secp256k1 private keys (missing X25519 private key).

**Solution**:
Regenerate the configuration with correct keys:

```bash
# Remove old config files
rm governance-portal/code/assets/user_config.*.json

# Run setup to regenerate
make cleanup
make dev-up
```

Make sure the setup script:
1. Generates did:peer:2 with X25519 + Ed25519 keys
2. Saves X25519 private key in secrets
3. Saves Ed25519 private key in secrets

**See also**: [Governance Portal DID Setup](../governance-portal/docs/DID_SETUP.md)

### DIDComm Protocol Debugging

**Enable Debug Logging**:

```dart
// In your Dart code
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  
  // Your app code
}
```

**Check DIDComm Message Flow**:

```dart
// Log outgoing messages
void sendMessage(Message msg) {
  print('Sending DIDComm message: ${msg.id}');
  print('To: ${msg.to}');
  print('Type: ${msg.type}');
  // Send message
}
```

**Verify Mediator Connection**:

```bash
# Test mediator endpoint
curl https://apse1.mediator.affinidi.io/.well-known/did.json

# Should return DID document with service endpoints
```

**See also**: [verifier-portal/code/DIDCOMM_TROUBLESHOOTING.md](../verifier-portal/code/DIDCOMM_TROUBLESHOOTING.md)

---

## CORS Issues

### CORS Policy Blocking Requests

**Error**: `Access to fetch at 'https://example.com' from origin 'http://localhost' has been blocked by CORS policy`

**Common Causes**:
1. Backend not sending CORS headers
2. Preflight requests not handled
3. Credentials included in cross-origin requests

**Solution 1: Backend CORS Configuration**

For Shelf (Dart backend):

```dart
import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        });
      }
      return null; // Continue to next handler
    },
    responseHandler: (Response response) {
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
      });
    },
  );
}

// Add to pipeline
final handler = Pipeline()
    .addMiddleware(corsMiddleware())
    .addMiddleware(logRequests())
    .addHandler(router.call);
```

**Solution 2: CORS Proxy for External APIs**

```dart
// For proxying external APIs through backend
@Route.post('/api/cors-proxy')
Future<Response> corsProxyHandler(Request request) async {
  final body = await request.readAsString();
  final targetUrl = jsonDecode(body)['url'];
  
  final response = await http.get(Uri.parse(targetUrl));
  
  return Response.ok(
    response.body,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  );
}
```

**See also**: [verifier-portal/code/CORS_FIX.md](../verifier-portal/code/CORS_FIX.md)

---

## Setup Issues

### Rust Not Found

**Error**: Setup script says "Rust not found" or skips DID generation.

**Solution**:

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Reload environment
source $HOME/.cargo/env

# Verify installation
rustc --version
cargo --version

# Run setup again
make cleanup
make dev-up
```

### Ngrok Auth Token Missing

**Error**: `ERROR: authentication failed: Your account is limited to 1 simultaneous ngrok agent`

**Solution**:

```bash
# Get auth token from: https://dashboard.ngrok.com/get-started/your-authtoken

# Add to .env.ngrok
echo "NGROK_AUTH_TOKEN=your_token_here" >> deployment/.env.ngrok

# Or during setup, enter when prompted
make dev-up
```

### Docker Containers Not Starting

**Symptoms**:
- `docker-compose up` fails
- Containers exit immediately
- Port conflicts

**Solutions**:

```bash
# Check for port conflicts
lsof -i :3000  # HK University
lsof -i :3001  # Macau University
lsof -i :4001  # Verifier backend

# Stop conflicting processes or change ports

# Clean up old containers
docker-compose down
docker system prune -a

# Restart
make docker-rebuild
```

### Missing Environment Files

**Error**: `Error: .env file not found`

**Solution**:

```bash
# Run setup to generate all .env files
make dev-up
```

---

## Network Issues

### Localhost vs. Ngrok Confusion

**Symptoms**:
- Services can't connect to each other
- DID resolution fails
- "Connection refused" errors

**Diagnosis**:

```bash
# Check which mode you're running
cat deployment/.env.ngrok | grep MODE

# Should show:
# MODE=ngrok
```

**Solution**:

```bash
# For development (with ngrok tunnels)
make cleanup
make dev-up
```

### Android Emulator Network Issues

**Problem**: Android emulator can't reach `localhost` services.

**Solution**: Android emulator uses special IP for host machine:

```bash
# In student-vault-app/code/.env.local-network
# Replace localhost with:
NOVA_CORP_SERVICE_URL=http://10.0.2.2:4001
HK_UNIVERSITY_SERVICE_URL=http://10.0.2.2:3000
```

`10.0.2.2` is the special IP that Android emulator uses to reach the host machine's localhost.

### Ngrok Tunnel Disconnects

**Symptoms**:
- Ngrok tunnels stop working after a while
- New domain assigned after restart
- DID resolution fails

**Solutions**:

```bash
# Restart ngrok and regenerate configs
make dev-down
make dev-up

# For longer sessions, upgrade ngrok plan
# Free plan: tunnels disconnect after 2-8 hours
# Paid plan: persistent domains, no disconnects
```

---

## Docker Issues

### Container Logs

```bash
# View all logs
make docker-logs

# View specific service
make docker-logs-hk        # HK University
make docker-logs-macau     # Macau University
make docker-logs-tr-hk     # HK Trust Registry

# Or use docker directly
docker logs hk-university-issuer -f
docker logs -f --tail=100 macau-university-issuer
```

### Container Not Responding

```bash
# Check container status
make docker-ps

# Restart specific service
docker restart hk-university-issuer

# Restart all services
make docker-restart

# Force rebuild if code changed
make docker-rebuild
```

### Volume Permissions

**Error**: `Permission denied` when accessing mounted volumes.

**Solution**:

```bash
# Fix permissions on data directories
cd nexigen-demo
chmod -R 755 university-issuance-service/instances/*/data
chmod -R 755 trust-registry/*/data

# Or rebuild with proper permissions
make docker-rebuild
```

---

## Platform-Specific Issues

### macOS

**Homebrew Packages**:

```bash
# Required tools
brew install jq      # JSON processing
brew install ngrok   # Tunneling (optional)
```

**Docker Desktop**: Make sure Docker Desktop is running and has enough resources:
- Memory: 4GB minimum, 8GB recommended
- Disk: 20GB minimum

### Linux

**Docker without sudo**:

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
```

**Systemd services**: Some scripts assume systemd for background processes.

### Windows (WSL2)

**Use WSL2 for best compatibility**:

```bash
# Install WSL2 with Ubuntu
wsl --install

# Run project inside WSL2
cd /mnt/c/path/to/nexigen-demo
```

**Docker Desktop for Windows**: Enable WSL2 backend in Docker Desktop settings.

---

## Flutter-Specific Issues

### Build Runner Conflicts

**Error**: `Conflicting outputs` when running `dart run build_runner build`

**Solution**:

```bash
# Use --delete-conflicting-outputs flag
dart run build_runner build --delete-conflicting-outputs

# Or clean first
dart run build_runner clean
dart run build_runner build
```

### Dependency Conflicts

**Error**: Version solving failed when running `flutter pub get`

**Solution**:

```bash
# Clean and reinstall
flutter clean
rm pubspec.lock
flutter pub get

# If still failing, check dependency_overrides in pubspec.yaml
```

### Hot Reload Not Working

**Symptoms**:
- Changes not reflecting in app
- Need to restart app manually

**Solutions**:

```bash
# Use hot restart instead of hot reload
# In terminal: press 'R' instead of 'r'

# Or restart the app completely
flutter run
```

---

## Getting More Help

If you encounter an issue not covered here:

1. **Check Component-Specific Docs**:
   - [Verifier Portal DIDComm Troubleshooting](../verifier-portal/code/DIDCOMM_TROUBLESHOOTING.md)
   - [Verifier Portal CORS Fix](../verifier-portal/code/CORS_FIX.md)
   - [Governance Portal DID Setup](../governance-portal/docs/DID_SETUP.md)

2. **Check Logs**:
   - Backend: `dart run lib/did_server.dart` (shows console output)
   - Docker: `make docker-logs`
   - Flutter: Console output in IDE or `flutter run`

3. **Verify Setup**:
   ```bash
   # Re-run setup scripts
   make cleanup
   make dev-up
   ```

4. **Check Project Documentation**:
   - [Architecture](architecture.md) - System design
   - [Setup Guide](setup.md) - Installation instructions
   - [Development Guide](development.md) - Development workflow
