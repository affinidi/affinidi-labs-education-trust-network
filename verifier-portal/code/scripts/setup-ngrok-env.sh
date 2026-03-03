#!/bin/bash
# Verifier Portal - Ngrok Environment Setup
# This script generates .env.ngrok with valid DIDs for ngrok mode

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "${SCRIPT_DIR}/.." && pwd )"

log_info() { echo "✓ $1"; }
log_error() { echo "❌ $1"; exit 1; }

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Verifier Portal - Ngrok Environment Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .env.ngrok already exists with valid configuration
if [ -f "${PROJECT_DIR}/.env.ngrok" ]; then
    EXISTING_VERIFIER_DID=$(grep "^VERIFIER_DID=" "${PROJECT_DIR}/.env.ngrok" 2>/dev/null | cut -d '=' -f2)
    if [ -n "$EXISTING_VERIFIER_DID" ] && [[ ! "$EXISTING_VERIFIER_DID" =~ example\.com ]]; then
        echo "✓ Found existing .env.ngrok with valid configuration"
        echo "  VERIFIER_DID: $EXISTING_VERIFIER_DID"
        echo ""
        echo "To regenerate, delete .env.ngrok and run this script again"
        exit 0
    fi
fi

# Check for ngrok tunnel
echo "Checking for active ngrok tunnel on port 4000..."
command -v curl >/dev/null 2>&1 || log_error "curl not installed"

# Try to get tunnel info from ngrok API
TUNNELS_JSON=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null || echo "{}")

# Check if ngrok API is accessible
if [ "$TUNNELS_JSON" = "{}" ] || [ -z "$TUNNELS_JSON" ]; then
    echo ""
    echo "❌ Cannot reach ngrok API at http://localhost:4040"
    echo ""
    echo "Please start ngrok first:"
    echo "  ngrok http 4000"
    echo ""
    exit 1
fi

# Parse JSON to get verifier tunnel URL
# Try with jq first (preferred), fall back to grep/sed if not available
if command -v jq >/dev/null 2>&1; then
    # Use jq for clean JSON parsing
    VERIFIER_URL=$(echo "$TUNNELS_JSON" | jq -r '.tunnels[] | select(.config.addr=="http://localhost:4000") | .public_url' 2>/dev/null | grep "https" | head -n 1)
    
    if [ -z "$VERIFIER_URL" ] || [ "$VERIFIER_URL" = "null" ]; then
        # Try to find any tunnel on port 4000
        VERIFIER_URL=$(echo "$TUNNELS_JSON" | jq -r '.tunnels[] | select(.config.addr | contains("4000")) | .public_url' 2>/dev/null | grep "https" | head -n 1)
    fi
else
    # Fallback: use grep/sed (less reliable but works without jq)
    echo "⚠️  jq not found, using grep fallback (install jq for better parsing: brew install jq)"
    VERIFIER_URL=$(echo "$TUNNELS_JSON" | grep -o '"public_url":"https://[^"]*"' | grep "4000" | head -n 1 | cut -d'"' -f4)
    
    if [ -z "$VERIFIER_URL" ]; then
        # Try without port filter
        VERIFIER_URL=$(echo "$TUNNELS_JSON" | grep -o '"public_url":"https://[^"]*"' | head -n 1 | cut -d'"' -f4)
    fi
fi

if [ -z "$VERIFIER_URL" ] || [ "$VERIFIER_URL" = "null" ]; then
    echo ""
    echo "❌ No ngrok tunnel found for port 4000"
    echo ""
    echo "Active tunnels:"
    echo "$TUNNELS_JSON"
    echo ""
    echo "Please start ngrok first:"
    echo "  ngrok http 4000"
    echo ""
    exit 1
fi

# Extract domain from URL (remove https://)
VERIFIER_DOMAIN=$(echo "$VERIFIER_URL" | sed 's|https://||' | sed 's|http://||')

log_info "Found ngrok tunnel: $VERIFIER_URL"
echo "  Domain: $VERIFIER_DOMAIN"
echo ""

# Get DIDComm configuration
echo "Configuring DIDComm settings..."
echo ""

# Use defaults from common configuration
DEFAULT_SERVICE_DID="did:web:cheese-parade.meetingplace.affinidi.io"
DEFAULT_MEDIATOR_DID="did:web:apse1.mediator.affinidi.io:.well-known"
DEFAULT_MEDIATOR_URL="https://apse1.mediator.affinidi.io/.well-known"

echo "Service DID (for MeetingPlace SDK initialization)"
echo "Press Enter to use default: $DEFAULT_SERVICE_DID"
read -p "SERVICE_DID: " SERVICE_DID
SERVICE_DID=${SERVICE_DID:-$DEFAULT_SERVICE_DID}

echo ""
echo "Mediator DID (DIDComm routing mediator)"
echo "Press Enter to use default: $DEFAULT_MEDIATOR_DID"
read -p "MEDIATOR_DID: " MEDIATOR_DID
MEDIATOR_DID=${MEDIATOR_DID:-$DEFAULT_MEDIATOR_DID}

echo ""
echo "Mediator URL"
echo "Press Enter to use default: $DEFAULT_MEDIATOR_URL"
read -p "MEDIATOR_URL: " MEDIATOR_URL
MEDIATOR_URL=${MEDIATOR_URL:-$DEFAULT_MEDIATOR_URL}

# Generate .env.ngrok
echo ""
echo "Generating .env.ngrok..."

# Clean old DID keys to force regeneration with new domain
echo ""
echo "🧹 Cleaning old DID keys..."
rm -f "${PROJECT_DIR}/keys/did-document.json"
rm -f "${PROJECT_DIR}/keys/secrets.json"
log_info "Keys cleaned - fresh DID will be generated on next server start"

cat > "${PROJECT_DIR}/.env.ngrok" << EOF
# Nova Corp Verifier Service Configuration (Ngrok Mode)
# Generated on $(date)

APP_NAME=Nova Corp Verifier
APP_VERSION=1.0.0
PORT=4000

# SSL Configuration (ngrok provides HTTPS)
USE_SSL=true

# Verifier Identity (this service's DID)
VERIFIER_DID=did:web:${VERIFIER_DOMAIN}:nova-corp
VERIFIER_DOMAIN=${VERIFIER_DOMAIN}/nova-corp

# DIDComm Service Configuration
# This is the permanent DID used for SDK initialization
# It should be a resolvable did:web or use Affinidi's MeetingPlace service
SERVICE_DID=${SERVICE_DID}

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
ISSUER_MEDIATOR=${MEDIATOR_DID}

# Storage Configuration
STORAGE_BACKEND=json
DATA_PATH=./data

# Trust Registry (Optional)
TRUST_REGISTRY_URL=
EOF

log_info ".env.ngrok created successfully"
echo ""
echo "Configuration:"
echo "  VERIFIER_DID:  did:web:${VERIFIER_DOMAIN}:nova-corp"
echo "  SERVICE_DID:   ${SERVICE_DID}"
echo "  MEDIATOR_DID:  ${MEDIATOR_DID}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Ngrok environment configured!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Clean and rebuild the app:"
echo "     make clean && make dev-up"
echo ""
echo "  2. Or run directly with ngrok env:"
echo "     flutter build web --release --dart-define-from-file=.env.ngrok"
echo "     dart run bin/did_server.dart --env-file=.env.ngrok"
echo ""
