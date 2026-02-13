#!/bin/bash
# Verifier Service setup script
set -e  # Exit on error

# Check for localhost flag
USE_LOCALHOST=false
if [ "$1" = "--localhost" ]; then
    USE_LOCALHOST=true
    echo "🏠 Setting up in LOCALHOST mode..."
else
    echo "🌐 Setting up with NGROK (use --localhost flag for localhost mode)..."
fi

echo "🚀 Setting up Verifier Service..."
echo "📦 Using code from included repository (verifier-portal/code/)"

# Load main .env file
MAIN_ENV_FILE="../deployment/.env"
if [ -f "$MAIN_ENV_FILE" ]; then
    source "$MAIN_ENV_FILE"
fi

# Verify code directory exists
if [ ! -d "code" ]; then
    echo "❌ Error: code directory not found at verifier-portal/code/"
    echo "   The repository should include the verifier portal code."
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
# Nova Corp Verifier Service Configuration (Localhost Mode)
NOVA_CORP_SERVICE_URL=http://localhost:4000
NOVA_CORP_SERVICE_DID=did:web:localhost%3A4000:nova-corp

# Trust Registry (Cloud)
TRUST_REGISTRY_URL=${TRUST_REGISTRY_URL}

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_SERVICE_ENDPOINT=${MEDIATOR_SERVICE_ENDPOINT}

# Port
SERVICE_PORT=4000
EOF
    
    echo "✅ Localhost configuration created"
else
    echo "🌐 Using ngrok URLs from main .env file..."
    
    # Create/update .env file for ngrok mode
    cat > code/.env << EOF
# Nova Corp Verifier Service Configuration (Ngrok Mode)
NOVA_CORP_SERVICE_URL=${NOVA_CORP_SERVICE_URL}
NOVA_CORP_SERVICE_DID=${NOVA_CORP_SERVICE_DID}

# Trust Registry (Cloud)
TRUST_REGISTRY_URL=${TRUST_REGISTRY_URL}

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_SERVICE_ENDPOINT=${MEDIATOR_SERVICE_ENDPOINT}

# Port (used by ngrok)
SERVICE_PORT=4000
EOF
    
    echo "✅ Ngrok configuration created"
fi

echo ""
echo "✅ Verifier Service setup completed!"

