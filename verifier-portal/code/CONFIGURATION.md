# Verifier Portal - Configuration Guide

## Quick Start Options

### Option 1: Ngrok Mode (Recommended for Testing)

For internet-accessible testing with mobile devices:

```bash
# Terminal 1: Start ngrok
ngrok http 4000

# Terminal 2: Start verifier with ngrok
cd verifier-portal/code
make dev-up
```

✅ **Fully automated** - generates valid DID configuration automatically

📱 **Works with mobile** - accessible from anywhere via ngrok URL

See [NGROK_SETUP.md](NGROK_SETUP.md) for detailed guide.

### Option 2: Local Network Mode

For WiFi/LAN access only:

```bash
# Edit .env.local-network with your local IP
make run
```

### Option 3: Manual Configuration

For custom setups:

1. Copy example: `cp .env.example .env`
2. Edit `.env` with your DIDs
3. Run: `make run`

## Understanding the Configuration

### Key Environment Variables

**VERIFIER_DID**: This verifier's identity

- Example: `did:web:abc123.ngrok-free.app:nova-corp`
- Must be resolvable (DID document accessible)

**SERVICE_DID**: Permanent DID for MeetingPlace SDK

- Example: `did:web:cheese-parade.meetingplace.affinidi.io`
- Should be a stable, hosted DID

**MEDIATOR_DID**: DIDComm message routing service

- Example: `did:web:apse1.mediator.affinidi.io:.well-known`
- Usually Affinidi's cloud mediator

### Configuration Priority

The app loads configuration in this order:

1. `.env.ngrok` (if exists)
2. `.env.local-network` (if exists)
3. `.env` (fallback)

## Troubleshooting

### "Configuration Error" in UI

**Cause**: Missing or invalid .env file

**Solution**: Use `make dev-up` to auto-generate valid configuration

### DID Resolution Failed

**Cause**: SERVICE_DID cannot be resolved by the SDK

**Common issues**:

- Using placeholder DIDs (did:web:example.com)
- Network issues reaching DID document URL
- Invalid DID format

**Solution**:

```bash
# Use ngrok mode with working defaults
make dev-up

# Or manually set valid SERVICE_DID in .env:
SERVICE_DID=did:web:cheese-parade.meetingplace.affinidi.io
```

### QR Code Not Generating

**Symptoms**: "Error generating QR code" message

**Diagnosis**: Check browser console for:

```
[DIDCommService] ❌ Initialize failed: ...
```

**Solutions**:

1. Verify .env file exists and has valid DIDs
2. Check network connectivity to mediator
3. Ensure SERVICE_DID is resolvable
4. Try `make clean && make dev-up`

## Advanced Configuration

### Custom Mediator

To use your own DIDComm mediator:

```env
MEDIATOR_DID=did:web:your-mediator.com
MEDIATOR_URL=https://your-mediator.com
```

### Multiple Environments

Create environment-specific files:

- `.env.dev` - Development
- `.env.staging` - Staging
- `.env.prod` - Production

Copy the desired one to `.env.ngrok` before running.

### Integration with Full Demo

The full Credulon demo setup handles all services:

```bash
cd affinidi-labs-education-trust-network
make dev-up
```

This automatically:

- Creates ngrok tunnels for 3 services
- Generates all DID configurations
- Starts Docker containers
- Configures trust registries

## Need Help?

1. **Check logs**: Browser console shows detailed initialization steps
2. **Verify ngrok**: Visit http://localhost:4040 to see tunnel status
3. **Test DID resolution**: Try accessing your DID document URL directly
4. **Review examples**: See `.env.example` for reference configuration

## Development Workflow

### Daily Development

```bash
# Use local network for speed
make run
```

### Testing with Mobile

```bash
# Use ngrok for internet access
ngrok http 4000  # Terminal 1
make dev-up    # Terminal 2
```

### Clean Slate

```bash
# Remove all generated files
make clean
rm .env.ngrok keys/*.json data/*

# Regenerate everything
make dev-up
```
