# DID Document Regeneration Fix

## Problem
The DID document was showing an old ngrok domain (`b094310cc312.ngrok-free.app`) instead of the current one (`503360ba93cf.ngrok-free.app`). This happened because the DID keys were cached in the `keys/` directory and not cleaned up when starting with a new ngrok tunnel.

## Solution
Added automatic cleanup of the `keys/` directory before generating new configurations to ensure the DID document is regenerated with the current ngrok domain.

## Changes Made

### 1. Root Setup Script (`deployment/scripts/setup_ngrok.sh`)
Added keys cleanup before creating verifier `.env.ngrok`:
```bash
# Clean old DID keys to force regeneration with new domain
log_verbose "Cleaning old verifier DID keys..."
rm -f "${PROJECT_ROOT}/verifier-portal/code/keys/did-document.json"
rm -f "${PROJECT_ROOT}/verifier-portal/code/keys/secrets.json"
log_verbose "Keys cleaned - fresh DID will be generated"
```

### 2. Verifier Makefile (`verifier-portal/code/Makefile`)
Added cleanup step to `dev-up` target:
```makefile
dev-up: ngrok-setup
    @echo "🧹 Cleaning old DID keys for fresh generation..."
    @rm -rf keys/*.json
    @echo "   ✅ Keys cleaned"
    @flutter build web --release
    @dart run bin/did_server.dart --env-file=.env.ngrok
```

Enhanced `clean` target:
```makefile
clean:
    @flutter clean
    @rm -rf keys/*.json
    @rm -rf data/*
    @rm -rf build/
    @rm -rf .dart_tool/
```

### 3. Verifier Setup Script (`verifier-portal/code/scripts/setup-ngrok-env.sh`)
Added keys cleanup before generating `.env.ngrok`:
```bash
# Clean old DID keys to force regeneration with new domain
echo ""
echo "🧹 Cleaning old DID keys..."
rm -f "${PROJECT_DIR}/keys/did-document.json"
rm -f "${PROJECT_DIR}/keys/secrets.json"
log_info "Keys cleaned - fresh DID will be generated on next server start"
```

## How It Works

### Before (Problem)
1. Run `make dev-up` with new ngrok tunnel
2. `.env.ngrok` gets new domain: `503360ba93cf.ngrok-free.app`
3. But `keys/did-document.json` still has old domain: `b094310cc312.ngrok-free.app`
4. Server serves cached DID document with wrong domain ❌

### After (Fixed)
1. Run `make dev-up` with new ngrok tunnel
2. Script cleans `keys/*.json` files
3. `.env.ngrok` gets new domain: `503360ba93cf.ngrok-free.app`
4. Server generates fresh DID document with correct domain ✅

## Testing

To test the fix:

1. **Start fresh ngrok environment:**
   ```bash
   cd /Users/csamprajan/Affinidi/POCs/nexigen-demo
   make dev-up
   ```

2. **Or just verifier:**
   ```bash
   cd /Users/csamprajan/Affinidi/POCs/nexigen-demo/verifier-portal/code
   make dev-up
   ```

3. **Verify DID document:**
   ```bash
   # Get your ngrok URL from the output, then:
   curl https://<your-ngrok-domain>/nova-corp/did.json | jq '.id'
   ```
   
   Should show: `"did:web:<your-ngrok-domain>:nova-corp"`

## Manual Cleanup

If you need to manually clean the keys:

```bash
cd /Users/csamprajan/Affinidi/POCs/nexigen-demo/verifier-portal/code
make clean
```

Or:

```bash
rm -f verifier-portal/code/keys/did-document.json
rm -f verifier-portal/code/keys/secrets.json
```

## Related Files

- `verifier-portal/code/keys/did-document.json` - Cached DID document
- `verifier-portal/code/keys/secrets.json` - Private keys
- `verifier-portal/code/.env.ngrok` - Configuration with ngrok domain
- `verifier-portal/code/bin/did_server.dart` - Generates DID if not exists

## Prevention

The scripts now automatically clean these files whenever:
- Running `make dev-up` from root
- Running `make dev-up` from verifier directory
- Running `make ngrok-setup` from verifier directory
- Running `make clean` from verifier directory

This ensures you always get a fresh DID document with the correct domain when starting with a new ngrok tunnel.
