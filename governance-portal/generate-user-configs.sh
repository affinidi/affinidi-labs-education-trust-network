#!/bin/bash
# Generate user_config files for Governance Portal instances
# This script generates DID credentials for HK, Macau, and Singapore governance portals
set -e

echo "🔐 Governance Portal - User Config Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ============================================
# PROMPT FOR MEDIATOR INFORMATION
# ============================================
echo "📋 Mediator Configuration"
echo ""

# Check if parameters were passed
if [ $# -eq 2 ]; then
    MEDIATOR_URL="$1"
    MEDIATOR_DID="$2"
    echo "✓ Using provided mediator configuration:"
    echo "  MEDIATOR_URL: $MEDIATOR_URL"
    echo "  MEDIATOR_DID: $MEDIATOR_DID"
else
    # Prompt for mediator information
    read -p "Enter Mediator URL (e.g., https://apse1.mediator.affinidi.io): " MEDIATOR_URL
    if [ -z "$MEDIATOR_URL" ]; then
        echo "❌ MEDIATOR_URL is required. Exiting."
        exit 1
    fi

    read -p "Enter Mediator DID (e.g., did:web:apse1.mediator.affinidi.io:.well-known): " MEDIATOR_DID
    if [ -z "$MEDIATOR_DID" ]; then
        echo "❌ MEDIATOR_DID is required. Exiting."
        exit 1
    fi
fi

echo ""

# ============================================
# CHECK RUST INSTALLATION
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Checking Rust installation..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v cargo &> /dev/null; then
    echo "❌ Error: Rust/Cargo not found"
    echo "   Please install Rust from https://rustup.rs/"
    exit 1
fi

CARGO_VERSION=$(cargo --version)
echo "✓ Rust/Cargo installed: $CARGO_VERSION"
echo ""

# ============================================
# BUILD RUST DID GENERATION TOOL
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔨 Setting up Rust DID generation tool..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Store absolute path to Rust tool directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRUST_REGISTRY_PATH="${SCRIPT_DIR}/rust-did-generation-helper"

if [ ! -d "$TRUST_REGISTRY_PATH" ]; then
    echo "❌ Error: $TRUST_REGISTRY_PATH directory not found"
    echo "   This should contain the Rust code for DID generation"
    exit 1
elif [ ! -f "$TRUST_REGISTRY_PATH/Cargo.toml" ]; then
    echo "❌ Error: $TRUST_REGISTRY_PATH/Cargo.toml not found"
    echo "   The Rust project is incomplete"
    exit 1
else
    echo "✓ Found local Rust DID generation tool"
    
    # Build the Rust tool
    echo "  📦 Building Rust tool (this may take a moment on first run)..."
    cd "$TRUST_REGISTRY_PATH"
    
    if cargo build --bin generate-secrets --features="dev-tools" --quiet 2>&1 | grep -q "error"; then
        echo "  ❌ Build failed"
        cargo build --bin generate-secrets --features="dev-tools"
        exit 1
    else
        echo "  ✅ Build successful"
    fi
    
    cd "$SCRIPT_DIR"
fi

echo ""

# ============================================
# GENERATE USER CONFIG FILES
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Generating DID credentials..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Function to generate a single user_config.json
generate_user_config() {
    local instance_name=$1
    local alias=$2
    local output_file=$3
    
    echo "  🔑 Generating DID for $instance_name..."
    
    # Save current directory
    local original_dir
    original_dir=$(pwd)
    
    # Use local Rust generate-secrets tool to create DID and secrets
    cd "$TRUST_REGISTRY_PATH"
    
    # Run generate-secrets with proper environment variables
    MEDIATOR_URL="${MEDIATOR_URL}" \
    MEDIATOR_DID="${MEDIATOR_DID}" \
    cargo run --bin generate-secrets --features="dev-tools" --quiet 2>/dev/null
    
    # Extract CLIENT_DID and CLIENT_SECRETS from .env.test
    local client_did
    local client_secrets
    client_did=$(grep "^CLIENT_DID=" .env.test | cut -d'=' -f2-)
    client_secrets=$(grep "^CLIENT_SECRETS=" .env.test | cut -d'=' -f2- | sed 's/^"//' | sed 's/"$//' | sed 's/\\"/"/g')
    
    # Return to original directory
    cd "$original_dir"
    
    # Create the user_config.json with proper formatting
    cat > "$output_file" << EOF
{
  "${client_did}": {
    "alias": "${alias}",
    "secrets": ${client_secrets}
  }
}
EOF
    
    echo "  ✅ Generated: $output_file"
    echo "     Admin DID: ${client_did:0:80}..."
    echo ""
    
    # Return the DID for the caller
    echo "$client_did"
}

# Setup code directory
cd code

# Create assets directory if it doesn't exist
mkdir -p assets

# Generate for HK Ministry
echo "🇭🇰 Hong Kong Ministry:"
HK_ADMIN_DID=$(generate_user_config "hk-ministry" "Hong Kong Ministry of Education" "assets/user_config.hk.json")

# Generate for Macau Ministry
echo "🇲🇴 Macau Ministry:"
MACAU_ADMIN_DID=$(generate_user_config "macau-ministry" "Macau Ministry of Education" "assets/user_config.macau.json")

# Generate for Singapore Ministry
echo "🇸🇬 Singapore Ministry:"
SG_ADMIN_DID=$(generate_user_config "sg-ministry" "Singapore Ministry of Education" "assets/user_config.sg.json")

echo "✅ All user_config files generated!"
echo ""

# ============================================
# DISPLAY ADMIN DIDs
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Generated Admin DIDs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "These DIDs have been generated for each governance portal:"
echo ""
echo "🇭🇰 Hong Kong Ministry Admin DID:"
echo "   $HK_ADMIN_DID"
echo ""
echo "🇲🇴 Macau Ministry Admin DID:"
echo "   $MACAU_ADMIN_DID"
echo ""
echo "🇸🇬 Singapore Ministry Admin DID:"
echo "   $SG_ADMIN_DID"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ User config generation complete!"
echo ""
echo "Next steps:"
echo "1. Create Trust Registries on Affinidi Portal using these Admin DIDs"
echo "2. Run the main setup script to configure environment files"
echo ""
