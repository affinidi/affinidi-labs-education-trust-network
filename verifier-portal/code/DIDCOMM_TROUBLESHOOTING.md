# DIDComm Service Initialization Troubleshooting

## Problem
You're seeing this error in the browser console:

```
[DIDCommService] ❌ INITIALIZATION FAILED
[DIDCommService] Error: Instance of 'minified:vK' (code: generic)
```

The app continues in "fallback mode" but full DIDComm functionality doesn't work.

## Root Cause

**CORS (Cross-Origin Resource Sharing) Policy Violation**

When the MeetingPlace SDK initializes, it tries to fetch DID documents from:
- `SERVICE_DID`: `did:web:cheese-parade.meetingplace.affinidi.io`
- `MEDIATOR_DID`: `did:web:apse1.mediator.affinidi.io:.well-known`

Your Flutter web app runs on: `https://503360ba93cf.ngrok-free.app`

Browsers block these cross-origin requests unless the target servers send CORS headers allowing your origin. These servers don't send those headers, so the requests fail.

## Quick Diagnosis

Run the test script to check your setup:

```bash
cd /Users/csamprajan/Affinidi/POCs/certizen-demo/verifier-portal/code
./scripts/test-didcomm-init.sh
```

This will check:
- ✅ Ngrok tunnel status
- ✅ Local DID server
- ✅ Your verifier DID document
- ❌ SERVICE_DID resolution (expected to fail)
- ❌ MEDIATOR_DID resolution (expected to fail)

## Solutions

### Solution 1: Chrome with CORS Disabled (Recommended for Development)

This is the **quickest way** to test your application locally:

```bash
cd /Users/csamprajan/Affinidi/POCs/certizen-demo/verifier-portal/code

# Launch Chrome with CORS disabled
./scripts/launch-chrome-no-cors.sh

# Then navigate to your ngrok URL in the opened Chrome window
```

**⚠️ WARNING:** Only use this Chrome window for development testing. Don't browse other websites.

### Solution 2: Use Native Mobile App (No CORS Issues)

Native apps don't have CORS restrictions:

```bash
# iOS
cd /Users/csamprajan/Affinidi/POCs/certizen-demo/verifier-portal/code
flutter run -d ios

# Android
flutter run -d android
```

### Solution 3: Request CORS Headers (Production Solution)

Contact the teams managing these services and ask them to add CORS headers:

**For `cheese-parade.meetingplace.affinidi.io`:**
```
Access-Control-Allow-Origin: *
# Or specifically: https://503360ba93cf.ngrok-free.app
```

**For `apse1.mediator.affinidi.io`:**
```
Access-Control-Allow-Origin: *
```

### Solution 4: Use Alternative SERVICE_DID

If available, use a `did:key` instead of `did:web` for the SERVICE_DID:

```env
# In .env.ngrok, change from:
SERVICE_DID=did:web:cheese-parade.meetingplace.affinidi.io

# To (if you have it):
SERVICE_DID=did:key:z6Mkfriq1MqLBoPWecGoDLjguo1sB9brj6wT3qZ5BxkKpuP6
```

This avoids HTTP resolution entirely.

## Understanding the Error Flow

### What Happens:

1. **Flutter web app loads** on `https://503360ba93cf.ngrok-free.app`
2. **User clicks "Apply for Job"**
3. **DIDComm service initializes**:
   ```dart
   await DIDCommService().initialize(
     serviceDid: 'did:web:cheese-parade.meetingplace.affinidi.io',
     mediatorDid: 'did:web:apse1.mediator.affinidi.io:.well-known',
   );
   ```
4. **MeetingPlace SDK tries to resolve SERVICE_DID**:
   - Fetch: `https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json`
   - Browser blocks: ❌ **CORS policy violation**
5. **SDK initialization fails** → Generic error thrown
6. **App catches error** → Continues in fallback mode
7. **Limited functionality** → Can generate DIDs but not full DIDComm

### Why "Fallback Mode" Works Partially:

The app can still:
- ✅ Generate local DIDs (`did:key:...`)
- ✅ Serve its own DID document
- ✅ Build QR codes

But cannot:
- ❌ Establish DIDComm channels
- ❌ Send/receive encrypted messages
- ❌ Complete VDSP credential verification flow

## Verification Steps

### 1. Check if Chrome CORS disabled is working:

Open the Chrome instance (launched with `--disable-web-security`), open DevTools (F12), and check console:

**Before (CORS enabled):**
```
❌ Access to fetch at 'https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json'
   from origin 'https://503360ba93cf.ngrok-free.app' has been blocked by CORS policy
```

**After (CORS disabled):**
```
✅ [DIDCommService] ✅ SDK initialized
✅ [DIDCommService] ✅ Permanent DID: did:key:...
✅ [DIDCommService] ✅ VDSP client created
```

### 2. Test DID resolution manually:

```bash
# Test SERVICE_DID (will work from terminal, not from browser)
curl https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json

# Test MEDIATOR_DID
curl https://apse1.mediator.affinidi.io/.well-known/did.json

# Test your verifier DID (should always work)
curl https://503360ba93cf.ngrok-free.app/nova-corp/did.json
```

### 3. Monitor network requests:

In Chrome DevTools (Network tab), look for:
- ✅ `/nova-corp/did.json` - Should succeed (200 OK)
- ❌ `cheese-parade.meetingplace.affinidi.io` - Fails with CORS (unless Chrome CORS disabled)

## Common Issues

### Issue: "Chrome launches but still shows CORS errors"

**Solution:** Make sure you're using the NEW Chrome window that opened with the script. The existing Chrome window won't have CORS disabled.

### Issue: "Script says ngrok not running"

**Solution:** Start ngrok first:
```bash
ngrok http 4000
```

### Issue: "DID document shows old domain"

**Solution:** Clean and regenerate:
```bash
cd /Users/csamprajan/Affinidi/POCs/certizen-demo/verifier-portal/code
make clean
make dev-up
```

### Issue: "Still getting initialization errors after disabling CORS"

**Check:**
1. Are you using the correct Chrome window?
2. Is your ngrok tunnel still active? (check `http://localhost:4040`)
3. Is the DID server running? (check `http://localhost:4000/health`)

## Testing Checklist

- [ ] Ngrok tunnel running on port 4000
- [ ] DID server running (`make dev-up`)
- [ ] Chrome launched with CORS disabled
- [ ] Navigated to ngrok URL in CORS-disabled Chrome
- [ ] Checked browser console for success messages
- [ ] Tested "Apply for Job" button

## References

- [CORS_FIX.md](../CORS_FIX.md) - Detailed CORS solutions
- [DID_REGENERATION_FIX.md](../../DID_REGENERATION_FIX.md) - DID document regeneration
- [NGROK_SETUP.md](../NGROK_SETUP.md) - Ngrok configuration guide

## Getting Help

Run the diagnostic script:
```bash
./scripts/test-didcomm-init.sh
```

Share the output when asking for help.
