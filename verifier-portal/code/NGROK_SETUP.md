# Verifier Portal - Ngrok Setup Guide

## Overview

This guide explains how to run the Nova Corp Verifier Portal with ngrok, making it accessible over the internet.

## Quick Start

### 1. Start ngrok tunnel

```bash
ngrok http 4000
```

Keep this terminal open. Note the ngrok URL (e.g., `https://abc123.ngrok-free.app`).

### 2. Run the verifier with ngrok

In a new terminal:

```bash
cd /path/to/nexigen-demo/verifier-portal/code
make dev-up
```

This will:
1. Detect your active ngrok tunnel
2. Generate `.env.ngrok` with the correct DID configuration
3. Build the Flutter web app
4. Start the DID server

### 3. Access the verifier

Open your browser to the ngrok URL shown in step 1.

## What `make dev-up` Does

The `dev-up` target automates the following:

1. **Detects ngrok tunnel**: Queries ngrok API at `http://localhost:4040/api/tunnels`
2. **Generates `.env.ngrok`**: Creates configuration with:
   - `VERIFIER_DID=did:web:<ngrok-domain>:nova-corp` (your verifier's identity)
   - `SERVICE_DID=did:web:cheese-parade.meetingplace.affinidi.io` (MeetingPlace service)
   - `MEDIATOR_DID` and `MEDIATOR_URL` (DIDComm routing)
3. **Builds Flutter app**: Compiles the web application
4. **Starts server**: Runs both DID document server and web UI

## Configuration

### Generated .env.ngrok Example

```env
APP_NAME=Nova Corp Verifier
APP_VERSION=1.0.0
PORT=4000

# SSL Configuration (ngrok provides HTTPS)
USE_SSL=true

# Verifier Identity (this service's DID)
VERIFIER_DID=did:web:abc123.ngrok-free.app:nova-corp
VERIFIER_DOMAIN=abc123.ngrok-free.app/nova-corp

# DIDComm Service Configuration
SERVICE_DID=did:web:cheese-parade.meetingplace.affinidi.io
MEDIATOR_DID=did:web:apse1.mediator.affinidi.io:.well-known
MEDIATOR_URL=https://apse1.mediator.affinidi.io/.well-known
```

### Custom Configuration

To use different SERVICE_DID or MEDIATOR settings:

```bash
# Run setup script manually
bash scripts/setup-ngrok-env.sh

# You'll be prompted for custom values
# Or press Enter to use defaults
```

## How It Works

### DID Generation

The verifier needs a `did:web` DID that resolves to a DID document. With ngrok:

1. Your verifier's DID: `did:web:<ngrok-domain>:nova-corp`
2. DID document URL: `https://<ngrok-domain>/nova-corp/did.json`
3. The `did_server.dart` generates and serves this document automatically

### Configuration Loading

The Flutter app loads configuration in priority order:

1. `.env.ngrok` (ngrok mode)
2. `.env.local-network` (local WiFi)
3. `.env` (localhost)

This happens at runtime in `main.dart`, no rebuild needed when switching modes.

### DIDComm Integration

- **SERVICE_DID**: Your permanent DID for SDK initialization (usually a hosted DID)
- **VERIFIER_DID**: This verifier instance's DID (changes per ngrok session)
- **MEDIATOR_DID**: Cloud service for DIDComm message routing

## Troubleshooting

### No ngrok tunnel found

**Error**: `❌ No ngrok tunnel found for port 4000`

**Solution**: 
```bash
# Start ngrok first
ngrok http 4000
```

### DID resolution failed

**Error**: SDK initialization fails with DID resolution error

**Cause**: SERVICE_DID cannot be resolved

**Solution**:
1. Check SERVICE_DID in `.env.ngrok`
2. Ensure it's a valid, resolvable `did:web` DID
3. For testing, use: `did:web:cheese-parade.meetingplace.affinidi.io`

### Configuration not updating

**Solution**: Delete `.env.ngrok` and run `make ngrok-setup` again:
```bash
rm .env.ngrok
make ngrok-setup
```

### ngrok session expired

ngrok free tier sessions expire after 8 hours.

**Solution**:
1. Restart ngrok: `ngrok http 4000`
2. Regenerate config: `rm .env.ngrok && make dev-up`

## Manual Setup (Alternative)

If you prefer manual configuration:

### 1. Create `.env.ngrok` manually

```bash
cp .env.example .env.ngrok
```

Edit `.env.ngrok` with your ngrok domain.

### 2. Build and run

```bash
flutter build web --release
dart run bin/did_server.dart --env-file=.env.ngrok
```

## Integration with Full Demo

To run the entire Nexigen demo with ngrok (all universities + verifier):

```bash
cd /path/to/nexigen-demo
make dev-up
```

This starts:
- HK University (ngrok)
- Macau University (ngrok)
- Nova Corp Verifier (ngrok)
- All other services (local network)

## Development Tips

### Quick iteration

For development, use local network mode instead:
```bash
make clean
# Edit .env.local-network
make run
```

### Testing with mobile

Ngrok URLs work great for testing with mobile devices:
1. Run `make dev-up`
2. Open ngrok URL on mobile
3. QR code scanning works from anywhere

### Inspecting ngrok traffic

Ngrok provides a web UI at http://localhost:4040 showing:
- All HTTP requests
- Request/response details
- Replay capability

## Security Notes

- Ngrok URLs are public - anyone can access them
- Ngrok free tier URLs change on restart
- For production, use proper hosting with static domains
- Never commit `.env.ngrok` with production credentials

## Next Steps

After successful ngrok setup:

1. **Test the flow**:
   - Open verifier at ngrok URL
   - Navigate to job application
   - Scan QR code with student app
   - Share credentials
   - Verify reception in verifier

2. **Integrate with student app**:
   - Configure student app to recognize your verifier
   - Add to organization list if needed

3. **Monitor logs**:
   - Check browser console for errors
   - Watch terminal for DIDComm messages
   - Inspect ngrok traffic at localhost:4040
