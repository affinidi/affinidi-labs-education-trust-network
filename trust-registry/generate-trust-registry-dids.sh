#!/bin/bash
# Generate unique DIDs for Trust Registry instances
# Each trust registry needs its own DID, separate from the governance portals
set -e

echo "🔐 Generating Trust Registry DIDs..."
echo ""

# Check if we're in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Source directories
mkdir -p hk/config macau/config sg/config

# Check if governance portal DIDs exist (needed for admin ACLs)
if [ ! -f "../governance-portal/code/assets/user_config.hk.json" ]; then
    echo "❌ Error: Governance portal DIDs not found"
    echo "   Please run governance-portal/generate-user-configs.sh first"
    exit 1
fi

# Extract Admin DIDs from governance portal configs
echo "📋 Extracting Admin DIDs from governance portals..."
HK_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.hk.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')
MACAU_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.macau.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')
SG_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.sg.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')

echo "   HK Admin:    ${HK_ADMIN_DID:0:60}..."
echo "   Macau Admin: ${MACAU_ADMIN_DID:0:60}..."
echo "   SG Admin:    ${SG_ADMIN_DID:0:60}..."
echo ""

# Mediator configuration
MEDIATOR_DID="did:web:trip-battery.mediator.affinidi.io"

# Function to generate a trust registry DID
generate_tr_did() {
    local region=$1
    local admin_did=$2
    local region_upper
    region_upper=$(echo "$region" | tr '[:lower:]' '[:upper:]')
    local alias="$region_upper Trust Registry"
    local output_file="$SCRIPT_DIR/$region/config/user_config.$region.json"
    
    # Check if DID already exists
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        echo "✓ DID for $alias already exists, skipping generation"
        return 0
    fi
    
    echo "🔑 Generating DID for $alias with admin: ${admin_did:0:60}..."
    
    # Navigate to the affinidi-trust-registry-rs directory (local clone in trust-registry folder)
    cd "$SCRIPT_DIR/affinidi-trust-registry-rs"
    
    # Create the data directory for CSV storage if it doesn't exist
    mkdir -p "$SCRIPT_DIR/$region/data"
    
    # Use the setup-trust-registry command to generate a new DID
    # Include --admin-dids to configure mediator ACLs for the governance portal
    # Capture the output and extract the JSON profile configuration
    OUTPUT=$(cargo run --bin setup-trust-registry --features="dev-tools" -- \
        --mediator-did "$MEDIATOR_DID" \
        --did-method peer \
        --storage-backend csv \
        --file-storage-path "$SCRIPT_DIR/$region/data" \
        --admin-dids "$admin_did" 2>&1)
    
    # Display the output
    echo "$OUTPUT"
    
    # Extract the profile JSON from PROFILE_CONFIG line in Environment Configuration
    # The PROFILE_CONFIG contains a JSON string that we need to unescape
    PROFILE_JSON=$(echo "$OUTPUT" | grep '"PROFILE_CONFIG":' | sed 's/.*"PROFILE_CONFIG": "\(.*\)".*/\1/' | sed 's/\\"/"/g')
    
    # Remove the leading and trailing single quotes if present
    PROFILE_JSON=$(echo "$PROFILE_JSON" | sed "s/^'//;s/'$//")
    
    # Save the profile to the config file
    if [ -n "$PROFILE_JSON" ]; then
        echo "$PROFILE_JSON" > "$output_file"
        echo "✅ Saved profile to: $output_file"
    else
        echo "❌ Failed to extract profile configuration"
        cd "$SCRIPT_DIR"
        return 1
    fi
    
    cd "$SCRIPT_DIR"
    
    echo "✅ Generated DID for $alias"
    echo ""
}


# Set default repo URL if not in .env
TRUST_REGISTRY_API_REPO_URL="${TRUST_REGISTRY_API_REPO_URL:-https://github.com/affinidi/affinidi-trust-registry-rs}"
TRUST_REGISTRY_API_COMMIT="${TRUST_REGISTRY_API_COMMIT:-2c87c33}" # Pin to specific commit to avoid breaking changes


# Clone the repository if it doesn't exist
if [ ! -d "affinidi-trust-registry-rs" ]; then
    echo "📦 Cloning Affinidi Trust Registry API from repository..."
    git clone "$TRUST_REGISTRY_API_REPO_URL" ./affinidi-trust-registry-rs
    
    # Checkout specific commit/tag/branch if specified
    if [ ! -z "$TRUST_REGISTRY_API_COMMIT" ]; then
        echo "📌 Checking out commit/tag: $TRUST_REGISTRY_API_COMMIT"
        cd ./affinidi-trust-registry-rs
        git checkout "$TRUST_REGISTRY_API_COMMIT"
        cd ..
    fi
else
    echo "✓ Repository already cloned"
    
    # Update to specific commit if specified
    if [ ! -z "$TRUST_REGISTRY_API_COMMIT" ]; then
        echo "📌 Updating to commit/tag: $TRUST_REGISTRY_API_COMMIT"
        cd ./affinidi-trust-registry-rs
        git fetch origin
        git checkout "$TRUST_REGISTRY_API_COMMIT"
        cd ..
    fi
fi


# Generate DIDs for each region with corresponding admin DIDs
generate_tr_did "hk" "$HK_ADMIN_DID"
generate_tr_did "macau" "$MACAU_ADMIN_DID"
generate_tr_did "sg" "$SG_ADMIN_DID"

echo "✅ All Trust Registry DIDs generated successfully!"
echo ""
echo "📝 Configuration files created:"
echo "   - hk/config/user_config.hk.json"
echo "   - macau/config/user_config.macau.json"
echo "   - sg/config/user_config.sg.json"
echo ""
echo "Next steps:"
echo "1. Run ./setup.sh to configure the trust registries"
echo "2. Run ./setup_localhost.sh from the parent directory to start all services"
echo ""
