# Quick Start Guide - Verifier Portal with Ngrok

## TL;DR - Get Running Fast

```bash
cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code

# 1. Start server and ngrok
make dev-up

# 2. In another terminal, launch Chrome with CORS disabled
make chrome-no-cors

# 3. Navigate to your ngrok URL in the Chrome window that just opened
#    (Find URL in the make dev-up output or at http://localhost:4040)
```

That's it! 🎉

## What Just Happened?

1. **`make dev-up`:**
   - Cleaned old DID keys
   - Generated `.env.ngrok` with your ngrok domain
   - Built Flutter web app
   - Started DID server on port 4000
   - Server serves both:
     - Your DID document at `/nova-corp/did.json`
     - Flutter web app at `/`

2. **`make chrome-no-cors`:**
   - Launched Chrome with `--disable-web-security`
   - This allows the app to resolve external DID documents
   - **Critical for DIDComm functionality**

3. **Navigate to ngrok URL:**
   - App loads in CORS-disabled Chrome
   - DIDComm service initializes successfully
   - Full functionality available

## Troubleshooting

### Issue: Still seeing CORS errors?

**Diagnostic:**

```bash
make test-init
```

This will check:

- Ngrok tunnel status
- DID server health
- DID document validity
- SERVICE_DID resolution
- MEDIATOR_DID resolution

### Issue: DID document shows wrong domain?

**Fix:**

```bash
make clean
make dev-up
```

### Issue: "Error: command not found"

**Check you're in the right directory:**

```bash
pwd
# Should output: /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code
```

## Full Workflow

### Initial Setup (First Time Only)

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Configure ngrok auth token:**
   ```bash
   ngrok config add-authtoken YOUR_TOKEN
   ```
   Get token from: https://dashboard.ngrok.com/get-started/your-authtoken

### Daily Development Workflow

1. **Terminal 1 - Start Server:**

   ```bash
   cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code
   make dev-up
   ```

   Note the ngrok URL from the output:

   ```
   ✅ Ngrok tunnel started
      Public URL: https://abc123xyz.ngrok-free.app
   ```

2. **Terminal 2 - Launch Chrome:**

   ```bash
   make chrome-no-cors
   ```

3. **Open ngrok URL** in the Chrome window that just opened

4. **Test the application:**
   - Browse job listings
   - Click "Apply for Job"
   - Scan QR code with mobile app
   - Complete credential verification flow

### Making Changes

When you modify Flutter code:

```bash
# Rebuild and restart
make dev-up
```

The server will:

- Reuse existing DID keys (no cleanup)
- Rebuild Flutter web app
- Restart server

When you change DID configuration or get a new ngrok domain:

```bash
# Clean and start fresh
make clean
make dev-up
```

## Available Commands

```bash
make help           # Show all available commands
make run            # Run with default .env (localhost)
make ngrok-setup    # Generate .env.ngrok from active ngrok
make dev-up       # Full setup: cleanup, build, run with ngrok
make test-init      # Diagnose DIDComm initialization issues
make chrome-no-cors # Launch Chrome with CORS disabled
make clean          # Clean all generated files
```

## Understanding the Setup

### Directory Structure

```
verifier-portal/code/
├── .env.ngrok              # Generated - ngrok configuration
├── keys/
│   ├── did-document.json   # Your verifier's DID document
│   └── secrets.json        # Private keys (keep secure!)
├── build/web/              # Compiled Flutter app
├── bin/
│   └── did_server.dart     # DID + web server
└── scripts/
    ├── launch-chrome-no-cors.sh
    ├── setup-ngrok-env.sh
    └── test-didcomm-init.sh
```

### Network Flow

```
┌─────────────┐
│   Browser   │ ──https://abc.ngrok-free.app──▶ ┌──────────┐
│  (Chrome    │                                  │  Ngrok   │
│ CORS-off)   │ ◀──────────────────────────────  │  Tunnel  │
└─────────────┘                                  └────┬─────┘
                                                      │
                                                      │ localhost:4000
                                                      ▼
                                                ┌───────────────┐
                                                │  DID Server   │
                                                │ (did_server.  │
                                                │    dart)      │
                                                └───────────────┘
                                                      │
                                                      ├──▶ /nova-corp/did.json
                                                      │    (DID document)
                                                      │
                                                      └──▶ /
                                                           (Flutter web app)
```

### Why CORS Disabled?

The MeetingPlace SDK needs to resolve external DIDs:

- `did:web:cheese-parade.meetingplace.affinidi.io`
- `did:web:apse1.mediator.affinidi.io:.well-known`

These servers don't send CORS headers allowing your ngrok domain, so:

- ✅ **Chrome with CORS disabled:** Works perfectly
- ❌ **Normal Chrome:** Blocked by CORS policy
- ✅ **Native mobile app:** No CORS restrictions

## Production Deployment

For production, you need proper CORS configuration or use native apps:

### Option 1: Request CORS Headers

Contact MeetingPlace/Mediator service teams to add:

```
Access-Control-Allow-Origin: https://your-production-domain.com
```

### Option 2: Use Native Apps

Build and deploy mobile apps (no CORS issues):

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

### Option 3: Use Different SERVICE_DID

If available, use `did:key` instead of `did:web`:

```env
SERVICE_DID=did:key:z6Mkfriq1MqLBoPWecGoDLjguo1sB9brj6wT3qZ5BxkKpuP6
```

## Learn More

- **CORS Issues:** See [DIDCOMM_TROUBLESHOOTING.md](DIDCOMM_TROUBLESHOOTING.md)
- **CORS Solutions:** See [CORS_FIX.md](CORS_FIX.md)
- **DID Regeneration:** See [../DID_REGENERATION_FIX.md](../DID_REGENERATION_FIX.md)
- **Ngrok Setup:** See [NGROK_SETUP.md](NGROK_SETUP.md)

## Getting Help

1. **Run diagnostics:**

   ```bash
   make test-init
   ```

2. **Check logs:**
   - Server logs: Terminal 1 (where you ran `make dev-up`)
   - Browser console: F12 in Chrome
   - Ngrok dashboard: http://localhost:4040

3. **Share output when asking for help**

## Tips & Tricks

### View Ngrok Dashboard

```bash
open http://localhost:4040
```

Shows all HTTP requests, very useful for debugging!

### Stop Everything

```bash
# Stop dev-up (Ctrl+C in Terminal 1)
# Close Chrome CORS-disabled window
# Kill any leftover ngrok processes:
pkill -f ngrok
```

### Quick Restart

```bash
# If server is running, Ctrl+C
# Then:
make dev-up
# Chrome window stays open, just refresh
```

### Check if CORS is Actually Disabled

In Chrome DevTools Console:

```javascript
fetch("https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json")
  .then((r) => r.json())
  .then((d) => console.log("✅ CORS disabled:", d.id))
  .catch((e) => console.error("❌ CORS still active:", e));
```

If you see the DID, CORS is disabled ✅  
If you see CORS error, CORS is still active ❌

## Next Steps

1. ✅ Get the verifier portal running
2. 📱 Set up student vault mobile app
3. 🏛️ Configure trust registries
4. 🎓 Start university issuer services
5. 🔗 Test end-to-end credential flow

Happy coding! 🚀
