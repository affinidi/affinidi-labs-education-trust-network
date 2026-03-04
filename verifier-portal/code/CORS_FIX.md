# CORS Issue Fix

## Problem

The Flutter web app is trying to fetch DID documents from `https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json`, but this request is blocked by CORS policy because the server doesn't send `Access-Control-Allow-Origin` headers.

**Error in console:**

```
Access to fetch at 'https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json'
from origin 'https://f4e2856a7a42.ngrok-free.app' has been blocked by CORS policy:
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## Quick Start (Recommended)

The easiest way to fix this for development is to run Chrome with CORS disabled:

```bash
cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code

# Launch Chrome with CORS disabled
./scripts/launch-chrome-no-cors.sh

# Then navigate to your ngrok URL in the opened Chrome window
```

## Solutions

### Solution 1: Use ngrok with CORS Configuration (Recommended for Development)

I've created an `ngrok.yml` configuration file that adds CORS headers to responses. To use it:

```bash
cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code

# Start your DID server
dart run bin/did_server.dart --env-file=.env.ngrok

# In another terminal, start ngrok with the config
ngrok start verifier --config ngrok.yml
```

**Note:** This adds CORS headers to responses from YOUR server, but won't fix the issue with `cheese-parade.meetingplace.affinidi.io` since that's a different domain.

### Solution 2: Run Chrome with CORS Disabled (Quick Fix for Development)

**⚠️ WARNING: Only use this for local development. Never deploy this way!**

```bash
# macOS
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security

# Linux
google-chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security

# Windows
chrome.exe --user-data-dir="C:\tmp\chrome_dev_test" --disable-web-security
```

Then open your ngrok URL in this Chrome instance.

### Solution 3: Configure CORS on the MeetingPlace Server (Proper Fix)

Contact the team managing `cheese-parade.meetingplace.affinidi.io` and ask them to add CORS headers:

```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

Or specifically allow your ngrok domain:

```
Access-Control-Allow-Origin: https://f4e2856a7a42.ngrok-free.app
```

### Solution 3: Configure CORS on the MeetingPlace Server (Proper Fix)

Contact the team managing `cheese-parade.meetingplace.affinidi.io` and ask them to add CORS headers:

```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

Or specifically allow your ngrok domain:

```
Access-Control-Allow-Origin: https://f4e2856a7a42.ngrok-free.app
```

### Solution 4: Use the CORS Proxy Endpoint (Added to your server)

I've added a CORS proxy endpoint to your DID server at `/api/cors-proxy`. However, this requires modifying the SDK's HTTP client to route through this proxy, which is complex.

The proxy endpoint usage would be:

```
GET http://localhost:4000/api/cors-proxy?url=https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json
```

### Solution 5: Use Native Mobile Instead of Web

Native mobile apps (iOS/Android) don't have CORS restrictions. Consider using:

- `flutter run -d ios` or `flutter run -d android` instead of web

### Solution 6: Change SERVICE_DID to use did:key instead of did:web

If the MeetingPlace SDK supports it, change from:

```
SERVICE_DID=did:web:cheese-parade.meetingplace.affinidi.io
```

To:

```
SERVICE_DID=did:key:z6Mkfriq...
```

This avoids HTTP resolution entirely, but requires getting the correct did:key value from the MeetingPlace team.

## Recommended Approach

For immediate testing: **Use Solution 2** (Chrome with CORS disabled)

For production: **Use Solution 3** (Fix CORS on the server) or **Solution 5** (Native mobile)

## Testing the Fix

### Option A: Chrome with CORS disabled

1. Start your server:

   ```bash
   cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code
   dart run bin/did_server.dart --env-file=.env.ngrok
   ```

2. Start ngrok:

   ```bash
   ngrok http 4000
   ```

3. Open Chrome with CORS disabled (Solution 2)

4. Navigate to your ngrok URL

5. Try applying for a job - the CORS error should be gone

### Option B: Native mobile (No CORS issues)

1. Connect your device or start emulator

2. Run:
   ```bash
   cd /Users/csamprajan/Affinidi/POCs/affinidi-labs-education-trust-network/verifier-portal/code
   flutter run -d ios  # or -d android
   ```

## Additional Notes

The CORS proxy I added at `/api/cors-proxy` can be useful for other external API calls that face CORS issues. It's already live in your DID server and adds proper CORS headers to proxied responses.

## Why This Happens

CORS (Cross-Origin Resource Sharing) is a browser security feature that blocks web pages from making requests to a different domain than the one that served the web page.

In your case:

- Your web page: `https://f4e2856a7a42.ngrok-free.app`
- Trying to fetch: `https://cheese-parade.meetingplace.affinidi.io/.well-known/did.json`

The browser blocks this unless `cheese-parade.meetingplace.affinidi.io` explicitly allows it with CORS headers.

Native mobile apps don't have this restriction, which is why Solution 5 works.
