#!/bin/sh
set -e

# Generate .env file from environment variables
cat > /app/.env << EOF
# Generated from Docker environment variables
PORT=${PORT:-4000}
USE_SSL=${USE_SSL:-false}
VERIFIER_NAME=${VERIFIER_NAME:-Nova Corp}
VERIFIER_DID=${VERIFIER_DID}
VERIFIER_URL=${VERIFIER_URL}
VERIFIER_DOMAIN=${VERIFIER_DOMAIN}
HK_TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
HK_TRUST_REGISTRY_URL=${HK_TRUST_REGISTRY_URL}
MACAU_TRUST_REGISTRY_DID=${MACAU_TRUST_REGISTRY_DID}
MACAU_TRUST_REGISTRY_URL=${MACAU_TRUST_REGISTRY_URL}
SG_TRUST_REGISTRY_DID=${SG_TRUST_REGISTRY_DID}
SG_TRUST_REGISTRY_URL=${SG_TRUST_REGISTRY_URL}
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
ISSUER_MEDIATOR=${MEDIATOR_DID}
STORAGE_BACKEND=${STORAGE_BACKEND:-json}
DATA_PATH=${DATA_PATH:-./data}
EOF

echo "✅ Generated .env file"

# Start DID server in background
echo "🚀 Starting DID server on port ${PORT:-4000}..."
cd /app
dart run bin/did_server.dart --env-file=.env &
DID_SERVER_PID=$!

# Wait a bit for DID server to start
sleep 2

echo "✅ DID server started (PID: $DID_SERVER_PID)"
echo "📄 DID document will be available at /<path>/did.json"
echo ""
echo "🎯 Server ready and listening..."

# Wait for DID server process
wait $DID_SERVER_PID
