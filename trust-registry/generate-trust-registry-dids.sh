#!/bin/bash
# Generate unique DIDs for Trust Registry instances
# Runs entirely in Docker — no Rust/Cargo needed on the host
set -e

echo "Generating Trust Registry DIDs (Docker)..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure output directories exist
mkdir -p hk/config macau/config sg/config

# Check governance portal DIDs exist
if [ ! -f "../governance-portal/code/assets/user_config.hk.json" ]; then
    echo "Error: Governance portal DIDs not found"
    echo "  Please run governance-portal/generate-user-configs.sh first"
    exit 1
fi

# Extract Admin DIDs from governance portal configs
echo "Extracting Admin DIDs from governance portals..."
HK_ADMIN_DID=$(grep -o '"did:peer:2[^"]*"' ../governance-portal/code/assets/user_config.hk.json | head -1 | tr -d '"')
MACAU_ADMIN_DID=$(grep -o '"did:peer:2[^"]*"' ../governance-portal/code/assets/user_config.macau.json | head -1 | tr -d '"')
SG_ADMIN_DID=$(grep -o '"did:peer:2[^"]*"' ../governance-portal/code/assets/user_config.sg.json | head -1 | tr -d '"')

echo "  HK Admin:    ${HK_ADMIN_DID:0:60}..."
echo "  Macau Admin: ${MACAU_ADMIN_DID:0:60}..."
echo "  SG Admin:    ${SG_ADMIN_DID:0:60}..."
echo ""

# Mediator configuration
MEDIATOR_DID="did:web:trip-battery.mediator.affinidi.io"

# Clone the repository if needed
TRUST_REGISTRY_API_REPO_URL="${TRUST_REGISTRY_API_REPO_URL:-https://github.com/affinidi/affinidi-trust-registry-rs}"
TRUST_REGISTRY_API_COMMIT="${TRUST_REGISTRY_API_COMMIT:-2c87c33}"

if [ ! -d "affinidi-trust-registry-rs" ]; then
    echo "Cloning Affinidi Trust Registry API repository..."
    git clone "$TRUST_REGISTRY_API_REPO_URL" ./affinidi-trust-registry-rs
    cd ./affinidi-trust-registry-rs && git checkout "$TRUST_REGISTRY_API_COMMIT" && cd ..
else
    echo "Repository already cloned"
fi

# Build Docker image for DID generation
echo "Building setup-trust-registry Docker image..."
docker build -f Dockerfile.did-gen -t tr-did-gen ./affinidi-trust-registry-rs -q
echo "Build complete."
echo ""

# Function to generate a trust registry DID using Docker
generate_tr_did() {
    local region=$1
    local admin_did=$2
    local output_file="$SCRIPT_DIR/$region/config/user_config.$region.json"

    # Skip if already generated
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        echo "DID for $region already exists, skipping"
        return 0
    fi

    echo "Generating DID for $region..."
    mkdir -p "$SCRIPT_DIR/$region/data"

    OUTPUT=$(docker run --rm \
        -v "$SCRIPT_DIR/$region/data:/data" \
        tr-did-gen \
        --mediator-did "$MEDIATOR_DID" \
        --did-method peer \
        --storage-backend csv \
        --file-storage-path /data \
        --admin-dids "$admin_did" 2>&1)

    # Extract PROFILE_CONFIG JSON from output
    PROFILE_JSON=$(echo "$OUTPUT" | grep '"PROFILE_CONFIG":' | sed 's/.*"PROFILE_CONFIG": "\(.*\)".*/\1/' | sed 's/\\"/"/g' | sed "s/^'//;s/'$//")

    if [ -n "$PROFILE_JSON" ]; then
        echo "$PROFILE_JSON" > "$output_file"
        echo "  Saved: $output_file"
    else
        echo "Failed to generate DID for $region"
        return 1
    fi
}

# Generate DIDs for each region
generate_tr_did "hk" "$HK_ADMIN_DID"
generate_tr_did "macau" "$MACAU_ADMIN_DID"
generate_tr_did "sg" "$SG_ADMIN_DID"

echo ""
echo "All Trust Registry DIDs generated!"
echo ""
echo "Config files:"
echo "  - hk/config/user_config.hk.json"
echo "  - macau/config/user_config.macau.json"
echo "  - sg/config/user_config.sg.json"
echo ""
