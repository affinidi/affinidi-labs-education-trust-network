#!/bin/bash
# Issuer Service setup script
set -e  # Exit on error

# Check for localhost flag
USE_LOCALHOST=false
if [ "$1" = "--localhost" ]; then
    USE_LOCALHOST=true
    echo "🏠 Setting up in LOCALHOST mode..."
else
    echo "🌐 Setting up with NGROK (use --localhost flag for localhost mode)..."
fi

echo "🚀 Setting up HK Issuance Service..."
echo "📦 Using code from included repository (hk-issuance-service/code/)"

# Clean up old data and keys folders from previous ngrok domains
echo "🧹 Cleaning up old data and keys folders..."
rm -rf instances/hk-university/data 2>/dev/null || true
rm -rf instances/hk-university/keys 2>/dev/null || true
rm -rf instances/macau-university/data 2>/dev/null || true
rm -rf instances/macau-university/keys 2>/dev/null || true
echo "✓ Old data and keys folders cleaned"

# Load main .env file
MAIN_ENV_FILE="../deployment/.env"
if [ -f "$MAIN_ENV_FILE" ]; then
    # shellcheck source=/dev/null
    source "$MAIN_ENV_FILE"
fi

# Verify code directory exists
if [ ! -d "code" ]; then
    echo "❌ Error: code directory not found at hk-issuance-service/code/"
    echo "   The repository should include the HK issuance service code."
    exit 1
fi

echo "✓ Code directory verified"

# Install Dart dependencies
echo "📦 Installing Dart dependencies..."
cd code
if dart pub get; then
    echo "✅ Dependencies installed successfully"
else
    echo "⚠️  Failed to install dependencies, but continuing..."
fi
cd ..

# Configure service URLs based on mode
if [ "$USE_LOCALHOST" = true ]; then
    echo "🏠 Configuring localhost URLs..."
    
    # Create/update .env file for localhost mode
    cat > code/.env << EOF
# Hong Kong University Service Configuration (Localhost Mode)
HK_UNIVERSITY_SERVICE_URL=http://localhost:3000
HK_UNIVERSITY_DID=did:web:localhost%3A3000:hongkong-university
MACAU_UNIVERSITY_SERVICE_URL=http://localhost:3001
MACAU_UNIVERSITY_DID=did:web:localhost%3A3001:macau-university

# Trust Registry (Cloud)
TRUST_REGISTRY_URL=${TRUST_REGISTRY_URL}

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_SERVICE_ENDPOINT=${MEDIATOR_SERVICE_ENDPOINT}

# Ports
HK_SERVICE_PORT=3000
MACAU_SERVICE_PORT=3001
EOF
    
    echo "✅ Localhost configuration created"
else
    echo "🌐 Using ngrok URLs from main .env file..."
    
    # Create/update .env file for ngrok mode
    cat > code/.env << EOF
# Hong Kong University Service Configuration (Ngrok Mode)
HK_UNIVERSITY_SERVICE_URL=${HK_UNIVERSITY_SERVICE_URL}
HK_UNIVERSITY_DID=${HK_UNIVERSITY_DID}
MACAU_UNIVERSITY_SERVICE_URL=${MACAU_UNIVERSITY_SERVICE_URL}
MACAU_UNIVERSITY_DID=${MACAU_UNIVERSITY_DID}

# Trust Registry (Cloud)
TRUST_REGISTRY_URL=${TRUST_REGISTRY_URL}

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_SERVICE_ENDPOINT=${MEDIATOR_SERVICE_ENDPOINT}

# Ports (used by ngrok)
HK_SERVICE_PORT=3000
MACAU_SERVICE_PORT=3001
EOF
    
    echo "✅ Ngrok configuration created"
fi

echo ""
echo "✅ University Issuance Service setup completed!"

