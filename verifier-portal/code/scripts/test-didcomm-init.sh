#!/bin/bash
# Quick test script to verify DIDComm service initialization
# This helps debug CORS and DID resolution issues

set -e

echo "🧪 Testing DIDComm Service Initialization"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Read configuration
if [ -f .env.ngrok ]; then
    echo "📋 Reading .env.ngrok configuration..."
    # Use grep to safely read values without sourcing the file
    SERVICE_DID=$(grep "^SERVICE_DID=" .env.ngrok | cut -d'=' -f2)
    MEDIATOR_DID=$(grep "^MEDIATOR_DID=" .env.ngrok | cut -d'=' -f2)
    VERIFIER_DID=$(grep "^VERIFIER_DID=" .env.ngrok | cut -d'=' -f2)
    echo "✓ Configuration loaded"
else
    echo "❌ .env.ngrok not found"
    echo "   Run 'make ngrok-setup' first"
    exit 1
fi

echo ""
echo "🔍 Configuration:"
echo "   VERIFIER_DID: $VERIFIER_DID"
echo "   SERVICE_DID: $SERVICE_DID"
echo "   MEDIATOR_DID: $MEDIATOR_DID"
echo ""

# Test 1: Check if ngrok tunnel is running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: Ngrok Tunnel Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
NGROK_STATUS=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null || echo "")
if [ -n "$NGROK_STATUS" ]; then
    echo "✅ Ngrok is running"
    TUNNEL_URL=$(echo "$NGROK_STATUS" | grep -o '"public_url":"https://[^"]*"' | head -n 1 | cut -d'"' -f4)
    echo "   Tunnel: $TUNNEL_URL"
else
    echo "⚠️  Ngrok not detected at localhost:4040"
    echo "   Start ngrok: ngrok http 4000"
fi
echo ""

# Test 2: Check if local DID server is running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 2: Local DID Server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
HEALTH_CHECK=$(curl -s http://localhost:4000/health 2>/dev/null || echo "")
if [ "$HEALTH_CHECK" = "OK" ]; then
    echo "✅ DID server is running on port 4000"
else
    echo "❌ DID server not responding on port 4000"
    echo "   Start server: make dev-up"
    exit 1
fi
echo ""

# Test 3: Check local DID document
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 3: Verifier DID Document"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
DID_PATH="/nova-corp/did.json"
DID_DOC=$(curl -s "http://localhost:4000${DID_PATH}" 2>/dev/null || echo "")
if [ -n "$DID_DOC" ]; then
    DID_ID=$(echo "$DID_DOC" | grep -o '"id":"[^"]*"' | head -n 1 | cut -d'"' -f4)
    echo "✅ DID document available"
    echo "   ID: $DID_ID"
    
    # Check if DID matches expected domain
    if [[ "$DID_ID" == *"$VERIFIER_DID"* ]] || [[ "$VERIFIER_DID" == *"$(echo $DID_ID | cut -d':' -f3)"* ]]; then
        echo "   ✅ DID matches configuration"
    else
        echo "   ⚠️  DID mismatch!"
        echo "   Expected: $VERIFIER_DID"
        echo "   Got: $DID_ID"
        echo ""
        echo "   Fix: Run 'make clean' then 'make dev-up'"
    fi
else
    echo "❌ DID document not available at $DID_PATH"
fi
echo ""

# Test 4: Check SERVICE_DID resolution (CORS issue will show here)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 4: SERVICE_DID Resolution (CORS Test)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract domain and path from SERVICE_DID
SERVICE_DOMAIN=$(echo "$SERVICE_DID" | sed 's/did:web://' | sed 's/%3A/:/g' | sed 's/:/.well-known\//')
if [[ "$SERVICE_DID" == *":.well-known"* ]]; then
    SERVICE_URL="https://${SERVICE_DOMAIN}/did.json"
else
    SERVICE_URL="https://$(echo $SERVICE_DID | sed 's/did:web://' | sed 's/%3A/:/g' | sed 's/:/\//g')/.well-known/did.json"
fi

echo "Trying to resolve: $SERVICE_URL"
SERVICE_DID_DOC=$(curl -s "$SERVICE_URL" 2>/dev/null || echo "")
if [ -n "$SERVICE_DID_DOC" ] && [[ "$SERVICE_DID_DOC" == *"\"id\""* ]]; then
    echo "✅ SERVICE_DID resolved successfully"
    echo "   This means CORS should work in Chrome (with --disable-web-security)"
else
    echo "❌ Cannot resolve SERVICE_DID"
    echo "   URL: $SERVICE_URL"
    echo ""
    echo "   This is expected! The SERVICE_DID resolution will fail from:"
    echo "   • Normal browsers (CORS policy)"
    echo "   • Command line (may work, but browser won't)"
    echo ""
    echo "   ✅ SOLUTION: Use Chrome with CORS disabled"
    echo "   Run: ./scripts/launch-chrome-no-cors.sh"
fi
echo ""

# Test 5: Check MEDIATOR_DID resolution
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 5: MEDIATOR_DID Resolution"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MEDIATOR_DOMAIN=$(echo "$MEDIATOR_DID" | sed 's/did:web://' | sed 's/%3A/:/g')
MEDIATOR_URL="https://${MEDIATOR_DOMAIN}/did.json"

echo "Trying to resolve: $MEDIATOR_URL"
MEDIATOR_DID_DOC=$(curl -s "$MEDIATOR_URL" 2>/dev/null || echo "")
if [ -n "$MEDIATOR_DID_DOC" ] && [[ "$MEDIATOR_DID_DOC" == *"\"id\""* ]]; then
    echo "✅ MEDIATOR_DID resolved successfully"
else
    echo "❌ Cannot resolve MEDIATOR_DID"
    echo "   URL: $MEDIATOR_URL"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Summary & Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "If you see CORS errors in browser console:"
echo ""
echo "  1. ✅ Launch Chrome with CORS disabled:"
echo "     ./scripts/launch-chrome-no-cors.sh"
echo ""
echo "  2. 🌐 Navigate to your ngrok URL"
echo "     (Check ngrok dashboard: http://localhost:4040)"
echo ""
echo "  3. 🧪 Test the application"
echo ""
echo "Alternative solutions:"
echo "  • Use native mobile app (no CORS): flutter run -d ios/android"
echo "  • Contact MeetingPlace team to enable CORS for your domain"
echo "  • Use different SERVICE_DID (if available)"
echo ""
