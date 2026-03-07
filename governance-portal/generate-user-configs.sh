#!/bin/bash
# Generate user_config files for Governance Portal instances
# This script generates DID credentials for HK, Macau, and Singapore governance portals
# Runs entirely in Docker — no Rust/Cargo needed on the host
set -e

echo "Governance Portal - User Config Generation (Docker)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ============================================
# PROMPT FOR MEDIATOR INFORMATION
# ============================================

# Check if parameters were passed
if [ $# -eq 2 ]; then
    MEDIATOR_URL="$1"
    MEDIATOR_DID="$2"
    echo "Using provided mediator configuration:"
    echo "  MEDIATOR_URL: $MEDIATOR_URL"
    echo "  MEDIATOR_DID: $MEDIATOR_DID"
else
    echo "Enter Mediator URL (e.g., https://apse1.mediator.affinidi.io):"
    read -r MEDIATOR_URL
    [ -z "$MEDIATOR_URL" ] && echo "MEDIATOR_URL is required" && exit 1

    echo "Enter Mediator DID (e.g., did:web:apse1.mediator.affinidi.io:.well-known):"
    read -r MEDIATOR_DID
    [ -z "$MEDIATOR_DID" ] && echo "MEDIATOR_DID is required" && exit 1
fi

echo ""

# ============================================
# CHECK DOCKER
# ============================================
command -v docker >/dev/null 2>&1 || { echo "Docker not installed"; exit 1; }

# ============================================
# BUILD DOCKER IMAGE FOR DID GENERATION
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DID_GEN_DIR="${SCRIPT_DIR}/rust-did-generation-helper"

echo "Building generate-secrets Docker image..."
docker build -t credulon-did-gen "$DID_GEN_DIR" -q
echo "Build complete."
echo ""

# ============================================
# GENERATE USER CONFIG FILES
# ============================================
echo "Generating DID credentials..."
echo ""

generate_user_config() {
    local instance_name=$1
    local alias=$2
    local output_file=$3

    echo "  Generating DID for ${instance_name}..."

    # Run generate-secrets in Docker; writes .env.test in /output
    mkdir -p "${DID_GEN_DIR}/output_tmp"
    docker run --rm \
        -e "MEDIATOR_URL=${MEDIATOR_URL}" \
        -e "MEDIATOR_DID=${MEDIATOR_DID}" \
        -v "${DID_GEN_DIR}/output_tmp:/output" \
        credulon-did-gen 2>/dev/null

    # Extract CLIENT_DID and CLIENT_SECRETS from .env.test
    local client_did client_secrets
    client_did=$(grep "^CLIENT_DID=" "${DID_GEN_DIR}/output_tmp/.env.test" | cut -d'=' -f2-)
    client_secrets=$(grep "^CLIENT_SECRETS=" "${DID_GEN_DIR}/output_tmp/.env.test" | cut -d'=' -f2- | sed 's/^"//' | sed 's/"$//' | sed 's/\\"/"/g')

    # Clean up temp
    rm -rf "${DID_GEN_DIR}/output_tmp"

    # Create the user_config.json
    cat > "$output_file" << EOJSON
{
  "${client_did}": {
    "alias": "${alias}",
    "secrets": ${client_secrets}
  }
}
EOJSON

    echo "  Generated: $output_file"
    echo "  Admin DID: ${client_did:0:80}..."
    echo ""
}

# Setup output directory
cd "${SCRIPT_DIR}/code"
mkdir -p assets

# Generate for each ministry
generate_user_config "hk-ministry" "Hong Kong Ministry of Education" "assets/user_config.hk.json"
generate_user_config "macau-ministry" "Macau Ministry of Education" "assets/user_config.macau.json"
generate_user_config "sg-ministry" "Singapore Ministry of Education" "assets/user_config.sg.json"

echo "All user_config files generated!"
echo ""
