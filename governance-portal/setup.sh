#!/bin/bash

# Governance Portal - Setup Script for All Instances

set -e

# Check for localhost flag
USE_LOCALHOST=false
if [ "$1" = "--localhost" ]; then
    USE_LOCALHOST=true
    echo "🏠 Setting up in LOCALHOST mode..."
else
    echo "🌐 Setting up with NGROK (use --localhost flag for localhost mode)..."
fi

echo "🚀 Setting up Governance Portal instances..."

# Load main .env file
MAIN_ENV_FILE="../.env"
if [ -f "$MAIN_ENV_FILE" ]; then
    # shellcheck source=/dev/null
    source "$MAIN_ENV_FILE"
fi

# Function to get port for instance
get_port() {
    case "$1" in
        "hk-ministry") echo "5000" ;;
        "macau-ministry") echo "5001" ;;
        "sg-ministry") echo "5002" ;;
    esac
}

INSTANCES=("hk-ministry" "macau-ministry" "sg-ministry")

# ============================================
# CHECK RUST INSTALLATION
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Checking Rust installation..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v cargo &> /dev/null; then
    echo "❌ Rust/Cargo not found!"
    echo ""
    echo "Please install Rust from: https://rustup.rs/"
    echo ""
    echo "Quick install:"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo ""
    echo "Skipping automatic DID generation..."
    SKIP_DID_GENERATION=true
else
    echo "✓ Rust/Cargo installed: $(cargo --version)"
fi

# ============================================
# SETUP LOCAL RUST DID GENERATION TOOL
# ============================================
if [ "$SKIP_DID_GENERATION" != true ]; then
    echo ""
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
        SKIP_DID_GENERATION=true
    elif [ ! -f "$TRUST_REGISTRY_PATH/Cargo.toml" ]; then
        echo "❌ Error: $TRUST_REGISTRY_PATH/Cargo.toml not found"
        SKIP_DID_GENERATION=true
    else
        echo "✓ Found local Rust DID generation tool"
        
        # Build the Rust tool if needed
        echo "  📦 Building Rust tool (this may take a moment on first run)..."
        cd "$TRUST_REGISTRY_PATH"
        if cargo build --bin generate-secrets --features="dev-tools" --quiet 2>&1 | grep -q "error"; then
            echo "❌ Error building Rust tool"
            SKIP_DID_GENERATION=true
            cd ..
        else
            echo "  ✅ Build successful"
            cd ..
        fi
    fi
fi

# ============================================
# CHECK IF REGENERATION IS NEEDED
# ============================================
if [ "$SKIP_DID_GENERATION" != true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔍 Checking if DID regeneration needed..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    MEDIATOR_CONFIG_FILE="code/.mediator_config"
    CURRENT_MEDIATOR="${MEDIATOR_URL}|${MEDIATOR_DID}"
    REGENERATE_NEEDED=false
    
    # Check if mediator configuration changed
    if [ -f "$MEDIATOR_CONFIG_FILE" ]; then
        SAVED_MEDIATOR=$(cat "$MEDIATOR_CONFIG_FILE")
        if [ "$CURRENT_MEDIATOR" != "$SAVED_MEDIATOR" ]; then
            echo "⚠️  Mediator configuration changed:"
            echo "   Previous: $SAVED_MEDIATOR"
            echo "   Current:  $CURRENT_MEDIATOR"
            echo ""
            echo "🔄 Will regenerate all DIDs with new mediator"
            REGENERATE_NEEDED=true
            
            # Remove old config files
            rm -f code/assets/user_config.hk.json
            rm -f code/assets/user_config.macau.json
            rm -f code/assets/user_config.sg.json
        else
            echo "✓ Mediator configuration unchanged"
        fi
    else
        echo "ℹ️  No previous mediator configuration found"
        REGENERATE_NEEDED=true
    fi
    
    # Check if any config files are missing
    MISSING_COUNT=0
    [ ! -f "code/assets/user_config.hk.json" ] && MISSING_COUNT=$((MISSING_COUNT + 1))
    [ ! -f "code/assets/user_config.macau.json" ] && MISSING_COUNT=$((MISSING_COUNT + 1))
    [ ! -f "code/assets/user_config.sg.json" ] && MISSING_COUNT=$((MISSING_COUNT + 1))
    
    if [ $MISSING_COUNT -gt 0 ]; then
        echo "ℹ️  $MISSING_COUNT user_config file(s) missing"
        REGENERATE_NEEDED=true
    else
        echo "✓ All user_config files exist"
    fi
    
    if [ "$REGENERATE_NEEDED" = false ]; then
        echo ""
        echo "✅ All DIDs already generated and up to date - skipping generation"
        SKIP_DID_GENERATION=true
    fi
fi

# ============================================
# GENERATE USER_CONFIG.JSON FOR ALL INSTANCES
# ============================================
if [ "$SKIP_DID_GENERATION" != true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔐 Generating DID credentials..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

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
    echo "     DID: ${client_did:0:60}..."
}

# Setup code directory
echo "📦 Setting up shared codebase..."
cd code

# Generate user_config.json for each instance if not skipping
if [ "$SKIP_DID_GENERATION" != true ]; then
    # Generate for HK Ministry
    echo ""
    echo "🇭🇰 Hong Kong Ministry:"
    generate_user_config "hk-ministry" "Hong Kong Ministry of Education" "assets/user_config.hk.json"
    
    # Generate for Macau Ministry
    echo ""
    echo "🇲🇴 Macau Ministry:"
    generate_user_config "macau-ministry" "Macau Ministry of Education" "assets/user_config.macau.json"
    
    # Generate for Singapore Ministry
    echo ""
    echo "🇸🇬 Singapore Ministry:"
    generate_user_config "sg-ministry" "Singapore Ministry of Education" "assets/user_config.sg.json"
    
    echo ""
    echo "✅ All user_config files generated!"
    
    # Save mediator configuration for future checks
    echo "$CURRENT_MEDIATOR" > ".mediator_config"
    echo "📝 Saved mediator configuration"
    echo ""
else
    # Fallback to copying from example if generation is skipped
    if [ ! -f "assets/user_config.json" ]; then
        if [ -f "assets/user_config.json.example" ]; then
            cp assets/user_config.json.example assets/user_config.json
            echo "  📝 Created assets/user_config.json from example"
            echo "  ⚠️  IMPORTANT: Update assets/user_config.json with your DID and private keys!"
        else
            echo "  ❌ ERROR: assets/user_config.json.example not found!"
            exit 1
        fi
    else
        echo "  ✓ assets/user_config.json already exists"
    fi
fi

# Install dependencies
if [ ! -f "pubspec.lock" ]; then
    flutter pub get
fi
cd ..

echo "✅ Shared codebase ready!"
echo ""

# ============================================
# DISPLAY GENERATED DIDS FOR REGISTRATION
# ============================================
if [ "$SKIP_DID_GENERATION" != true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 Generated Admin DIDs (Register These)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⚠️  IMPORTANT: Add these DIDs to your Trust Registry ADMIN_DIDS list:"
    echo ""
    
    for instance in "${INSTANCES[@]}"; do
        case "$instance" in
            "hk-ministry") 
                config_file="code/assets/user_config.hk.json"
                label="🇭🇰 Hong Kong Ministry"
                ;;
            "macau-ministry") 
                config_file="code/assets/user_config.macau.json"
                label="🇲🇴 Macau Ministry"
                ;;
            "sg-ministry") 
                config_file="code/assets/user_config.sg.json"
                label="🇸🇬 Singapore Ministry"
                ;;
        esac
        
        if [ -f "$config_file" ]; then
            # Extract DID from user_config file (it's the first key in the JSON)
            did=$(grep -o '"did:peer:2[^"]*"' "$config_file" | head -1 | tr -d '"')
            echo "$label:"
            echo "  $did"
            echo ""
        fi
    done
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

# Setup instances - Update .env files in code directory
for instance in "${INSTANCES[@]}"; do
    echo "⚙️  Setting up $instance instance..."
    
    # Determine the environment file name based on instance
    case "$instance" in
        "hk-ministry") 
            ENV_FILE="code/.env.hk.localhost"
            CONFIG_FILE="code/assets/user_config.hk.json"
            ;;
        "macau-ministry") 
            ENV_FILE="code/.env.macau.localhost"
            CONFIG_FILE="code/assets/user_config.macau.json"
            ;;
        "sg-ministry") 
            ENV_FILE="code/.env.sg.localhost"
            CONFIG_FILE="code/assets/user_config.sg.json"
            ;;
    esac
    
    # Extract ADMIN_DID from user_config file if it exists
    if [ -f "$CONFIG_FILE" ]; then
        ADMIN_DID=$(grep -o '"did:peer:2[^"]*"' "$CONFIG_FILE" | head -1 | tr -d '"')
        echo "  📝 Using ADMIN_DID: ${ADMIN_DID:0:50}..."
    fi
    
    # Check if the environment file needs updating
    if [ -f "$ENV_FILE" ]; then
        # Check if MEDIATOR_DID already exists
        if grep -q "MEDIATOR_DID=" "$ENV_FILE"; then
            echo "  ✓ $ENV_FILE already has MEDIATOR_DID configured"
        else
            echo "  📝 Adding MEDIATOR configuration to $ENV_FILE..."
            
            # Append mediator configuration
            cat >> "$ENV_FILE" << EOF

# Mediator Service (Cloud)
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
EOF
            echo "  ✅ MEDIATOR configuration added"
        fi
        
        # Update ADMIN_DID if we have it
        if [ -n "$ADMIN_DID" ]; then
            if grep -q "^ADMIN_DID=" "$ENV_FILE"; then
                # Replace existing ADMIN_DID
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s|^ADMIN_DID=.*|ADMIN_DID=${ADMIN_DID}|" "$ENV_FILE"
                else
                    sed -i "s|^ADMIN_DID=.*|ADMIN_DID=${ADMIN_DID}|" "$ENV_FILE"
                fi
                echo "  ✅ Updated ADMIN_DID in $ENV_FILE"
            else
                # Add ADMIN_DID if missing
                echo "" >> "$ENV_FILE"
                echo "# Admin DID" >> "$ENV_FILE"
                echo "ADMIN_DID=${ADMIN_DID}" >> "$ENV_FILE"
                echo "  ✅ Added ADMIN_DID to $ENV_FILE"
            fi
        fi
    else
        echo "  ⚠️  Warning: $ENV_FILE not found - skipping"
    fi
done

echo ""
echo "✅ All instances configured!"
echo ""
if [ "$USE_LOCALHOST" = true ]; then
    echo "🏠 LOCALHOST MODE - Service URLs:"
    echo "   - HK Ministry: http://localhost:5000"
    echo "   - Macau Ministry: http://localhost:5001"
    echo "   - Singapore Ministry: http://localhost:5002"
    echo ""
    echo "Trust Registry: ${TRUST_REGISTRY_URL} (Cloud)"
else
    echo "🌐 NGROK MODE - Public URLs will be generated by ngrok"
    echo ""
fi

if [ "$SKIP_DID_GENERATION" != true ]; then
    echo "Next steps:"
    echo "1. 🔐 Register the generated Admin DIDs with your Trust Registry"
    echo "   - Add each DID to the Trust Registry's ADMIN_DIDS environment variable"
    echo "   - Restart Trust Registry services after adding DIDs"
    echo ""
    echo "2. 🔒 Secure the user_config files:"
    echo "   chmod 600 code/assets/user_config.*.json"
    echo "   ⚠️  Never commit these files to git - they contain private keys!"
    echo ""
    echo "3. 🚀 Start individual instances:"
    echo "   cd code && make hk    # HK Ministry (uses user_config.hk.json)"
    echo "   cd code && make macau # Macau Ministry (uses user_config.macau.json)"
    echo "   cd code && make sg    # Singapore Ministry (uses user_config.sg.json)"
else
    echo "Next steps:"
    echo "1. ⚠️  CRITICAL: Update code/assets/user_config.json with your DID and private keys"
    echo "   - Use the same did:peer DID as your Rust admin API for interoperability"
    echo "   - Add your P-256, secp256k1 key types with private keys"
    echo "   - Keep this file secure and never commit to git!"
    echo ""
    echo "2. Ensure Trust Registry API services are running (Cloud or Local)"
    echo ""
    echo "3. Start individual instances:"
    echo "   cd instances/hk-ministry && docker-compose up -d"
    echo "   cd instances/macau-ministry && docker-compose up -d"
    echo "   cd instances/sg-ministry && docker-compose up -d"
    echo ""
    echo "Or start all from project root:"
    echo "   docker-compose up -d"
fi
