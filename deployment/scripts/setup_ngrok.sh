#!/bin/bash
# Education Trust Network - All-Docker + Ngrok Setup
# Cross-platform: works on macOS, Linux, and Windows (Git Bash / WSL)
#
# Host requirements: ngrok, docker, docker-compose, jq, curl, git, bash
# Everything else (Rust, Dart, Flutter) runs inside Docker containers.
set -e  # Exit on error

# Script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"

# Logging functions
log_info() { echo "✓ $1"; }
log_verbose() { echo "  $1"; }
log_error() { echo "❌ $1"; exit 1; }

# Cross-platform sed -i (macOS vs GNU)
sed_inplace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Education Trust Network - All-Docker + Ngrok Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will:"
echo "  1. Start 3 ngrok tunnels (Universities + Education Ministries)"
echo "  2. Generate all DIDs inside Docker (no Rust/Dart needed on host)"
echo "  3. Build and start ALL services in Docker"
echo ""
echo "Host requirements: ngrok, docker, docker-compose, jq, curl, git"
echo ""

# Check prerequisites (only tools that MUST be on host)
command -v ngrok >/dev/null 2>&1 || log_error "ngrok not installed. Install from: https://ngrok.com/download"
command -v docker >/dev/null 2>&1 || log_error "Docker not installed. Install from: https://docs.docker.com/get-docker/"
command -v jq >/dev/null 2>&1 || log_error "jq not installed. Install from: https://jqlang.github.io/jq/download/"
command -v curl >/dev/null 2>&1 || log_error "curl not installed"
command -v git >/dev/null 2>&1 || log_error "git not installed"

# Docker compose v2 detection (docker compose vs docker-compose)
if docker compose version >/dev/null 2>&1; then
    DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    DC="docker-compose"
else
    log_error "Neither 'docker compose' nor 'docker-compose' found"
fi

# Check if Docker daemon is running
if ! docker ps >/dev/null 2>&1; then
    log_error "Docker is not running. Please start Docker Desktop and try again."
fi

# Create initial .env.ngrok file if it doesn't exist
if [ ! -f "${PROJECT_ROOT}/deployment/.env.ngrok" ]; then
    touch "${PROJECT_ROOT}/deployment/.env.ngrok"
fi

# ============================================
# STEP 1: NGROK AUTHENTICATION
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Step 1: Ngrok Authentication"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if auth token already exists in .env.ngrok
EXISTING_TOKEN=$(grep "^NGROK_AUTH_TOKEN=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2)

if [ -n "$EXISTING_TOKEN" ]; then
    echo "Found existing ngrok auth token in .env.ngrok"
    NGROK_AUTH_TOKEN="$EXISTING_TOKEN"
    log_info "Using existing ngrok token"
else
    echo "No ngrok token found in .env.ngrok"
    echo "Get your auth token from: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "Enter ngrok auth token:"
    read -r NGROK_AUTH_TOKEN
    [ -z "$NGROK_AUTH_TOKEN" ] && log_error "Ngrok auth token required"
    
    # Save token to .env.ngrok for future use
    if grep -q "^NGROK_AUTH_TOKEN=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null; then
        sed_inplace "s|^NGROK_AUTH_TOKEN=.*|NGROK_AUTH_TOKEN=${NGROK_AUTH_TOKEN}|" "${PROJECT_ROOT}/deployment/.env.ngrok"
    else
        echo "NGROK_AUTH_TOKEN=${NGROK_AUTH_TOKEN}" >> "${PROJECT_ROOT}/deployment/.env.ngrok"
    fi
    log_info "Ngrok token saved to .env.ngrok"
fi

# Configure ngrok
ngrok config add-authtoken "$NGROK_AUTH_TOKEN" >/dev/null 2>&1
log_info "Ngrok authenticated"
echo ""

# ============================================
# STEP 2: SERVICE DID CONFIGURATION
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Step 2: DIDComm Service Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for existing SERVICE_DID
EXISTING_SERVICE_DID=$(grep "^SERVICE_DID=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2)

if [ -n "$EXISTING_SERVICE_DID" ]; then
    echo "Found existing SERVICE_DID in .env.ngrok: $EXISTING_SERVICE_DID"
    log_info "Using existing Service DID"
    SERVICE_DID="$EXISTING_SERVICE_DID"
else
    echo "No SERVICE_DID found. Please provide Service DID:"
    read -r SERVICE_DID
    [ -z "$SERVICE_DID" ] && log_error "Service DID is required"
fi

log_info "Using Service DID"
echo ""

# ============================================
# STEP 3: MEDIATOR CONFIGURATION
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Step 3: Mediator Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for existing mediator config
EXISTING_MEDIATOR_DID=$(grep "^MEDIATOR_DID=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2)
EXISTING_MEDIATOR_URL=$(grep "^MEDIATOR_URL=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2)

if [ -n "$EXISTING_MEDIATOR_DID" ] && [ -n "$EXISTING_MEDIATOR_URL" ]; then
    echo "Found existing Mediator configuration in .env.ngrok"
    echo "  DID: $EXISTING_MEDIATOR_DID"
    echo "  URL: $EXISTING_MEDIATOR_URL"
    MEDIATOR_DID="$EXISTING_MEDIATOR_DID"
    MEDIATOR_URL="$EXISTING_MEDIATOR_URL"
    log_info "Using existing Mediator configuration"
else
    echo "No mediator found. Please provide Mediator configuration:"
    echo "Mediator URL:"
    read -r MEDIATOR_URL
    [ -z "$MEDIATOR_URL" ] && log_error "Mediator URL is required"
    
    echo "Mediator DID:"
    read -r MEDIATOR_DID
    [ -z "$MEDIATOR_DID" ] && log_error "Mediator DID is required"
    
    log_info "Mediator configuration saved"
fi
echo ""

# ============================================
# STEP 4: START NGROK TUNNELS (Universities + Education Ministries)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Step 4: Starting Ngrok Tunnels"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Creating ngrok config with 3 tunnels (2 universities + education ministries)..."
echo ""

# Kill any existing ngrok processes (cross-platform)
if [ -f "${PROJECT_ROOT}/deployment/ngrok.pid" ]; then
    OLD_PID=$(cat "${PROJECT_ROOT}/deployment/ngrok.pid")
    kill "$OLD_PID" 2>/dev/null || true
    rm -f "${PROJECT_ROOT}/deployment/ngrok.pid"
fi
# Also try pkill as fallback (not available on all platforms)
if command -v pkill >/dev/null 2>&1; then
    pkill -f ngrok 2>/dev/null || true
fi
sleep 2

# Create ngrok config file with 3 tunnels
mkdir -p ~/.config/ngrok
cat > ~/.config/ngrok/ngrok-etn.yml << EOF
version: "2"
authtoken: ${NGROK_AUTH_TOKEN}
tunnels:
  hk-university:
    proto: http
    addr: 3000
  macau-university:
    proto: http
    addr: 3001
  education-ministries:
    proto: http
    addr: 3100
EOF

log_verbose "Starting ngrok agent with 3 tunnels (2 universities + education ministries)..."
ngrok start --all --config ~/.config/ngrok/ngrok-etn.yml > "${PROJECT_ROOT}/deployment/ngrok.log" 2>&1 &
NGROK_PID=$!
echo "$NGROK_PID" > "${PROJECT_ROOT}/deployment/ngrok.pid"

log_verbose "Waiting for ngrok to initialize..."
sleep 5

# Check if ngrok is running (cross-platform: use kill -0 instead of ps -p)
if ! kill -0 "$NGROK_PID" 2>/dev/null; then
    echo ""
    echo "❌ Ngrok failed to start. Checking error log..."
    echo ""
    
    # Check for free plan limitation
    if grep -q "may not run more than 3 endpoints" "${PROJECT_ROOT}/deployment/ngrok.log" 2>/dev/null; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "⚠️  NGROK FREE PLAN LIMITATION"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Ngrok free plan only allows 3 tunnels maximum."
        echo "This demo requires 9 tunnels for all services."
        echo ""
        echo "Options:"
        echo ""
        echo "1. 💳 Upgrade to ngrok Pay-as-you-go plan"
        echo "   Visit: https://dashboard.ngrok.com/billing/choose-a-plan?plan=paygo"
        echo "   Cost: ~\$8/month for unlimited tunnels"
        echo ""
        echo "2. 🏠 Use local network setup instead"
        echo "   Run: make cleanup && make setup"
        echo "   Note: Only accessible from devices on same Wi-Fi network"
        echo ""
        echo "3. 🔄 Run services in batches (3 at a time)"
        echo "   Start essential services only"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        exit 1
    else
        # Other error
        echo "Error details:"
        cat "${PROJECT_ROOT}/deployment/ngrok.log"
        exit 1
    fi
fi

log_info "Ngrok tunnels started (PID: $NGROK_PID)"
echo ""

# ============================================
# STEP 5: CAPTURE NGROK DOMAINS
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Step 5: Capturing Ngrok Domains"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_verbose "Querying ngrok API for tunnel information..."

# Query ngrok API
TUNNELS_JSON=$(curl -s http://localhost:4040/api/tunnels)

# Extract public URLs (strip https://)
HK_UNI_DOMAIN=$(echo "$TUNNELS_JSON" | jq -r '.tunnels[] | select(.name=="hk-university") | .public_url' | grep https | sed 's|https://||')
MACAU_UNI_DOMAIN=$(echo "$TUNNELS_JSON" | jq -r '.tunnels[] | select(.name=="macau-university") | .public_url' | grep https | sed 's|https://||')
EDU_MINISTRIES_DOMAIN=$(echo "$TUNNELS_JSON" | jq -r '.tunnels[] | select(.name=="education-ministries") | .public_url' | grep https | sed 's|https://||')

# Validate domains were obtained
[ -z "$HK_UNI_DOMAIN" ] && log_error "Failed to get HK University ngrok domain"
[ -z "$MACAU_UNI_DOMAIN" ] && log_error "Failed to get Macau University ngrok domain"
[ -z "$EDU_MINISTRIES_DOMAIN" ] && log_error "Failed to get Education Ministries ngrok domain"

log_info "Ngrok domains captured"
echo "   🇭🇰 HK University:         https://$HK_UNI_DOMAIN"
echo "   🇲🇴 Macau University:      https://$MACAU_UNI_DOMAIN"
echo "   🎓 Education Ministries:   https://$EDU_MINISTRIES_DOMAIN"
echo ""

# ============================================
# STEP 5.5: COLLECT STUDENT AND PROGRAM DETAILS
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👤 Step 5.5: Student and Program Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for existing student details
EXISTING_STUDENT_FIRST_NAME=$(grep "^STUDENT_FIRST_NAME=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2 | tr -d '"')
EXISTING_STUDENT_LAST_NAME=$(grep "^STUDENT_LAST_NAME=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2 | tr -d '"')
EXISTING_STUDENT_EMAIL=$(grep "^STUDENT_EMAIL=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2 | tr -d '"')

if [ -n "$EXISTING_STUDENT_FIRST_NAME" ] && [ -n "$EXISTING_STUDENT_LAST_NAME" ] && [ -n "$EXISTING_STUDENT_EMAIL" ]; then
    echo "Found existing student details:"
    echo "  Name: $EXISTING_STUDENT_FIRST_NAME $EXISTING_STUDENT_LAST_NAME"
    echo "  Email: $EXISTING_STUDENT_EMAIL"
    echo ""
    read -p "Use existing student details? (y/n): " use_existing
    if [ "$use_existing" = "y" ] || [ "$use_existing" = "Y" ]; then
        STUDENT_FIRST_NAME="$EXISTING_STUDENT_FIRST_NAME"
        STUDENT_LAST_NAME="$EXISTING_STUDENT_LAST_NAME"
        STUDENT_EMAIL="$EXISTING_STUDENT_EMAIL"
        log_info "Using existing student details"
    else
        read -p "Enter student first name: " STUDENT_FIRST_NAME
        read -p "Enter student last name: " STUDENT_LAST_NAME
        read -p "Enter student email: " STUDENT_EMAIL
        log_info "Student details updated"
    fi
else
    echo "Please provide student details for the demo:"
    read -p "Enter student first name: " STUDENT_FIRST_NAME
    read -p "Enter student last name: " STUDENT_LAST_NAME
    read -p "Enter student email: " STUDENT_EMAIL
    log_info "Student details saved"
fi

# Set default values if empty
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME:-"Sample"}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME:-"Student"}
STUDENT_EMAIL=${STUDENT_EMAIL:-"student@example.com"}

# Check for existing program names
EXISTING_HK_PROGRAM=$(grep "^HK_PROGRAM_NAME=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2 | tr -d '"')
EXISTING_MACAU_PROGRAM=$(grep "^MACAU_PROGRAM_NAME=" "${PROJECT_ROOT}/deployment/.env.ngrok" 2>/dev/null | cut -d '=' -f2 | tr -d '"')

if [ -n "$EXISTING_HK_PROGRAM" ] && [ -n "$EXISTING_MACAU_PROGRAM" ]; then
    HK_PROGRAM_NAME="$EXISTING_HK_PROGRAM"
    MACAU_PROGRAM_NAME="$EXISTING_MACAU_PROGRAM"
    log_info "Using existing program names"
else
    HK_PROGRAM_NAME="Bachelor of Science"
    MACAU_PROGRAM_NAME="Masters of Science"
    log_info "Using default program names"
fi

echo ""

# ============================================
# STEP 6: CREATE .env.ngrok WITH HYBRID CONFIGURATION
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Step 6: Creating .env.ngrok (Localhost + Ngrok)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_verbose "Writing localhost/ngrok hybrid configuration to .env.ngrok..."

cat > "${PROJECT_ROOT}/deployment/.env.ngrok" << EOF
# Education Trust Network - All-Docker + Ngrok Configuration
# Generated on $(date)

# Mode Configuration
MODE=all-docker
NGROK_AUTH_TOKEN=${NGROK_AUTH_TOKEN}

# DIDComm Service Configuration
SERVICE_DID=${SERVICE_DID}

# Mediator Configuration
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}

# Ngrok Captured Domains
HK_UNIVERSITY_NGROK_DOMAIN=${HK_UNI_DOMAIN}
MACAU_UNIVERSITY_NGROK_DOMAIN=${MACAU_UNI_DOMAIN}
EDUCATION_MINISTRIES_NGROK_DOMAIN=${EDU_MINISTRIES_DOMAIN}

# Service URLs (Universities and Education Ministries use ngrok, others use localhost)
HK_UNIVERSITY_SERVICE_URL=https://${HK_UNI_DOMAIN}
MACAU_UNIVERSITY_SERVICE_URL=https://${MACAU_UNI_DOMAIN}
EDUCATION_MINISTRIES_SERVICE_URL=https://${EDU_MINISTRIES_DOMAIN}
HK_TRUST_REGISTRY_URL=http://localhost:3232
MACAU_TRUST_REGISTRY_URL=http://localhost:3233
SG_TRUST_REGISTRY_URL=http://localhost:3234
NOVA_CORP_SERVICE_URL=http://localhost:4001
HK_GOVERNANCE_PORTAL_URL=http://localhost:8050
MACAU_GOVERNANCE_PORTAL_URL=http://localhost:8051
SG_GOVERNANCE_PORTAL_URL=http://localhost:8052

# Service DIDs (Universities use ngrok domains, others use localhost)
HK_UNIVERSITY_SERVICE_DID=did:web:${HK_UNI_DOMAIN}:hongkong-university
MACAU_UNIVERSITY_SERVICE_DID=did:web:${MACAU_UNI_DOMAIN}:macau-university
HK_TRUST_REGISTRY_DID=did:web:localhost%3A3232:hk-trust-registry
MACAU_TRUST_REGISTRY_DID=did:web:localhost%3A3233:macau-trust-registry
SG_TRUST_REGISTRY_DID=did:web:localhost%3A3234:sg-trust-registry
NOVA_CORP_SERVICE_DID=did:web:localhost%3A4001:nova-corp
HK_GOVERNANCE_PORTAL_DID=did:web:localhost%3A8050:hk-ministry
MACAU_GOVERNANCE_PORTAL_DID=did:web:localhost%3A8051:macau-ministry
SG_GOVERNANCE_PORTAL_DID=did:web:localhost%3A8052:sg-ministry

# Education Ministry DIDs (Ecosystem IDs - now on dedicated ngrok domain)
HK_EDUCATION_ECOSYSTEM_ID=did:web:${EDU_MINISTRIES_DOMAIN}:hongkong-education-ministry
HK_EDUCATION_MINISTRY_NAME=hongkong-education-ministry
MACAU_EDUCATION_ECOSYSTEM_ID=did:web:${EDU_MINISTRIES_DOMAIN}:macau-education-ministry
MACAU_EDUCATION_MINISTRY_NAME=macau-education-ministry
SG_EDUCATION_ECOSYSTEM_ID=did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry
SG_EDUCATION_MINISTRY_NAME=singapore-education-ministry

# Student Details
STUDENT_FIRST_NAME="${STUDENT_FIRST_NAME}"
STUDENT_LAST_NAME="${STUDENT_LAST_NAME}"
STUDENT_EMAIL="${STUDENT_EMAIL}"

# Program Names
HK_PROGRAM_NAME="${HK_PROGRAM_NAME}"
MACAU_PROGRAM_NAME="${MACAU_PROGRAM_NAME}"

# Verifier Singapore Trust Registry Configuration
SG_EDUCATION_MINISTRY_DID=did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry
SG_EDUCATION_MINISTRY_TRUST_REGISTRY_URL=http://localhost:3234
EOF

log_info ".env.ngrok created with all-docker configuration"

echo ""

# ============================================
# STEP 7: GENERATE ADMIN DIDs (Docker - no Rust needed on host)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Step 7: Generate Admin DIDs (Docker)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Building generate-secrets Docker image (first run compiles Rust - may take a few minutes)..."

DID_GEN_DIR="${PROJECT_ROOT}/governance-portal/rust-did-generation-helper"
docker build -t etn-did-gen "$DID_GEN_DIR" -q

echo "Generating user_config files for governance portals..."
mkdir -p "${PROJECT_ROOT}/governance-portal/code/assets"

# Function: generate a governance portal user config using Docker
generate_admin_did() {
    local label=$1
    local alias=$2
    local output_file=$3

    # Run generate-secrets in Docker; it writes .env.test in /output
    rm -rf "${DID_GEN_DIR}/output_tmp"
    mkdir -p "${DID_GEN_DIR}/output_tmp"
    docker run --rm \
        -e "MEDIATOR_URL=${MEDIATOR_URL}" \
        -e "MEDIATOR_DID=${MEDIATOR_DID}" \
        -v "${DID_GEN_DIR}/output_tmp:/output" \
        etn-did-gen

    # Validate output
    if [ ! -f "${DID_GEN_DIR}/output_tmp/.env.test" ]; then
        log_error "generate-secrets failed for ${label} — no .env.test produced"
    fi

    # Extract CLIENT_DID and CLIENT_SECRETS from .env.test
    local client_did client_secrets
    client_did=$(grep "^CLIENT_DID=" "${DID_GEN_DIR}/output_tmp/.env.test" | cut -d'=' -f2-)
    client_secrets=$(grep "^CLIENT_SECRETS=" "${DID_GEN_DIR}/output_tmp/.env.test" | cut -d'=' -f2- | sed 's/^"//' | sed 's/"$//' | sed 's/\\"/"/g')

    # Create user_config JSON
    cat > "$output_file" << EOJSON
{
  "${client_did}": {
    "alias": "${alias}",
    "secrets": ${client_secrets}
  }
}
EOJSON

    # Clean up temp
    rm -rf "${DID_GEN_DIR}/output_tmp"

    log_verbose "  ${label}: ${client_did:0:60}..."
}

generate_admin_did "HK" "Hong Kong Ministry of Education" \
    "${PROJECT_ROOT}/governance-portal/code/assets/user_config.hk.json"
generate_admin_did "Macau" "Macau Ministry of Education" \
    "${PROJECT_ROOT}/governance-portal/code/assets/user_config.macau.json"
generate_admin_did "SG" "Singapore Ministry of Education" \
    "${PROJECT_ROOT}/governance-portal/code/assets/user_config.sg.json"

# Extract the generated DIDs (they are the keys in the JSON object)
HK_ADMIN_DID=$(jq -r 'keys[0]' "${PROJECT_ROOT}/governance-portal/code/assets/user_config.hk.json")
MACAU_ADMIN_DID=$(jq -r 'keys[0]' "${PROJECT_ROOT}/governance-portal/code/assets/user_config.macau.json")
SG_ADMIN_DID=$(jq -r 'keys[0]' "${PROJECT_ROOT}/governance-portal/code/assets/user_config.sg.json")

log_info "Admin DIDs generated"
echo "   HK:    $HK_ADMIN_DID"
echo "   Macau: $MACAU_ADMIN_DID"
echo "   SG:    $SG_ADMIN_DID"

# Add Admin DIDs to .env.ngrok
cat >> "${PROJECT_ROOT}/deployment/.env.ngrok" << EOF

# Admin DIDs
HK_ADMIN_DID=${HK_ADMIN_DID}
MACAU_ADMIN_DID=${MACAU_ADMIN_DID}
SG_ADMIN_DID=${SG_ADMIN_DID}
EOF

echo ""

# ============================================
# STEP 8: GENERATE TRUST REGISTRY DIDs (Docker - no Rust needed on host)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔑 Step 8: Generate Trust Registry DIDs (Docker)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generating unique DIDs for each Trust Registry instance..."

cd "${PROJECT_ROOT}/trust-registry"

# Clone the trust registry repository if not already present
TRUST_REGISTRY_API_REPO_URL="${TRUST_REGISTRY_API_REPO_URL:-https://github.com/affinidi/affinidi-trust-registry-rs}"
TRUST_REGISTRY_API_COMMIT="${TRUST_REGISTRY_API_COMMIT:-2c87c33}"

if [ ! -d "affinidi-trust-registry-rs" ]; then
    echo "📥 Cloning Trust Registry repository..."
    git clone "$TRUST_REGISTRY_API_REPO_URL" ./affinidi-trust-registry-rs
    cd affinidi-trust-registry-rs && git checkout "$TRUST_REGISTRY_API_COMMIT" && cd ..
else
    echo "✓ Trust Registry repository already exists"
fi

echo "Building setup-trust-registry Docker image (first run compiles Rust - may take a few minutes)..."
docker build -f Dockerfile.did-gen -t tr-did-gen ./affinidi-trust-registry-rs -q

# Function: generate a trust registry DID using Docker
generate_tr_did() {
    local region=$1
    local admin_did=$2
    local output_file="${PROJECT_ROOT}/trust-registry/${region}/config/user_config.${region}.json"

    mkdir -p "${PROJECT_ROOT}/trust-registry/${region}/config"
    mkdir -p "${PROJECT_ROOT}/trust-registry/${region}/data"

    # Skip if already generated
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        log_verbose "  ${region}: DID already exists, skipping"
        return 0
    fi

    # Run setup-trust-registry in Docker
    OUTPUT=$(docker run --rm \
        -v "${PROJECT_ROOT}/trust-registry/${region}/data:/data" \
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
        log_verbose "  ${region}: DID generated"
    else
        log_error "Failed to generate Trust Registry DID for ${region}"
    fi
}

generate_tr_did "hk" "$HK_ADMIN_DID"
generate_tr_did "macau" "$MACAU_ADMIN_DID"
generate_tr_did "sg" "$SG_ADMIN_DID"

# Extract Trust Registry DIDs
HK_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/hk/config/user_config.hk.json" 2>/dev/null || echo "")
MACAU_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/macau/config/user_config.macau.json" 2>/dev/null || echo "")
SG_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/sg/config/user_config.sg.json" 2>/dev/null || echo "")

log_info "Trust Registry DIDs generated"
echo "   HK:    $HK_TRUST_REGISTRY_DID"
echo "   Macau: $MACAU_TRUST_REGISTRY_DID"
echo "   SG:    $SG_TRUST_REGISTRY_DID"

# Add Trust Registry DIDs to .env.ngrok
cat >> "${PROJECT_ROOT}/deployment/.env.ngrok" << EOF

# Trust Registry DIDs
HK_TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
MACAU_TRUST_REGISTRY_DID=${MACAU_TRUST_REGISTRY_DID}
SG_TRUST_REGISTRY_DID=${SG_TRUST_REGISTRY_DID}
EOF

echo ""

# ============================================
# STEP 9: PREPARE TRUST REGISTRY CONFIGS (no Docker start yet)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏛️  Step 9: Prepare Trust Registry Configs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Preparing configs for 3 Trust Registry instances..."

cd "${PROJECT_ROOT}/trust-registry"

# Repository already cloned in Step 8

# Extract profile configs (JSON objects compressed to single line)
HK_PROFILE_CONFIG=$(cat hk/config/user_config.hk.json | tr -d '\n' | tr -d ' ')
MACAU_PROFILE_CONFIG=$(cat macau/config/user_config.macau.json | tr -d '\n' | tr -d ' ')
SG_PROFILE_CONFIG=$(cat sg/config/user_config.sg.json | tr -d '\n' | tr -d ' ')

# Create per-instance Docker env files for the unified docker-compose
CORS_ORIGINS="http://localhost:3000,http://localhost:3001,http://localhost:4000,http://localhost:4001,http://localhost:8050,http://localhost:8051,http://localhost:8052"

mkdir -p hk/data macau/data sg/data

cat > hk/docker.env << EOF
LISTEN_ADDRESS=0.0.0.0:3232
TR_STORAGE_BACKEND=csv
FILE_STORAGE_PATH=/data/data.csv
CORS_ALLOWED_ORIGINS=${CORS_ORIGINS}
AUDIT_LOG_FORMAT=json
ENABLE_DIDCOMM=true
MEDIATOR_DID=${MEDIATOR_DID}
ADMIN_DIDS=${HK_ADMIN_DID}
PROFILE_CONFIG=${HK_PROFILE_CONFIG}
EOF

cat > macau/docker.env << EOF
LISTEN_ADDRESS=0.0.0.0:3232
TR_STORAGE_BACKEND=csv
FILE_STORAGE_PATH=/data/data.csv
CORS_ALLOWED_ORIGINS=${CORS_ORIGINS}
AUDIT_LOG_FORMAT=json
ENABLE_DIDCOMM=true
MEDIATOR_DID=${MEDIATOR_DID}
ADMIN_DIDS=${MACAU_ADMIN_DID}
PROFILE_CONFIG=${MACAU_PROFILE_CONFIG}
EOF

cat > sg/docker.env << EOF
LISTEN_ADDRESS=0.0.0.0:3232
TR_STORAGE_BACKEND=csv
FILE_STORAGE_PATH=/data/data.csv
CORS_ALLOWED_ORIGINS=${CORS_ORIGINS}
AUDIT_LOG_FORMAT=json
ENABLE_DIDCOMM=true
MEDIATOR_DID=${MEDIATOR_DID}
ADMIN_DIDS=${SG_ADMIN_DID}
PROFILE_CONFIG=${SG_PROFILE_CONFIG}
EOF

# Create empty CSV files with headers if they don't exist or are empty
for region in hk macau sg; do
    if [ ! -s "${region}/data/data.csv" ]; then
        echo "entity_id,authority_id,action,resource,recognized,authorized,context,record_type" > "${region}/data/data.csv"
    fi
done

log_info "Trust Registry configs prepared"
echo ""

# ============================================
# STEP 10: CREATE APP ENV FILES (for Docker)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Step 10: Creating app environment files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# --- University instance env files (used by Docker at runtime via env_file) ---
log_verbose "Creating university instance env files..."

# Docker internal URLs for backend-to-backend communication
# Trust registries listen on port 3232 internally (mapped to 3232/3233/3234 on host)

mkdir -p "${PROJECT_ROOT}/university-issuance-service/instances/hk-university"
cat > "${PROJECT_ROOT}/university-issuance-service/instances/hk-university/.env.ngrok" << EOF
PORT=3000
UNIVERSITY_NAME=Hong Kong University
UNIVERSITY_DID=did:web:${HK_UNI_DOMAIN}:hongkong-university
UNIVERSITY_DOMAIN=${HK_UNI_DOMAIN}/hongkong-university
USE_SSL=true
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
TRUST_REGISTRY_URL=http://trust-registry-hk:3232
EDUCATION_ECOSYSTEM_ID=did:web:${EDU_MINISTRIES_DOMAIN}:hongkong-education-ministry
STORAGE_BACKEND=json
DATA_PATH=./data
ISSUER_DIDWEB_DOMAIN=${HK_UNI_DOMAIN}/hongkong-university
ISSUER_KEY_PATH=./keys/issuer-key.json
PROGRAM_NAME=${HK_PROGRAM_NAME}
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

mkdir -p "${PROJECT_ROOT}/university-issuance-service/instances/macau-university"
cat > "${PROJECT_ROOT}/university-issuance-service/instances/macau-university/.env.ngrok" << EOF
PORT=3001
UNIVERSITY_NAME=Macau University
UNIVERSITY_DID=did:web:${MACAU_UNI_DOMAIN}:macau-university
UNIVERSITY_DOMAIN=${MACAU_UNI_DOMAIN}/macau-university
USE_SSL=true
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
TRUST_REGISTRY_DID=${MACAU_TRUST_REGISTRY_DID}
TRUST_REGISTRY_URL=http://trust-registry-macau:3232
EDUCATION_ECOSYSTEM_ID=did:web:${EDU_MINISTRIES_DOMAIN}:macau-education-ministry
STORAGE_BACKEND=json
DATA_PATH=./data
ISSUER_DIDWEB_DOMAIN=${MACAU_UNI_DOMAIN}/macau-university
ISSUER_KEY_PATH=./keys/issuer-key.json
PROGRAM_NAME=${MACAU_PROGRAM_NAME}
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

# --- Verifier Portal env files ---
log_verbose "Creating Verifier Portal env files..."
mkdir -p "${PROJECT_ROOT}/verifier-portal/code/backend"
mkdir -p "${PROJECT_ROOT}/verifier-portal/code/frontend"

# Clean old DID keys to force regeneration with new domain
rm -f "${PROJECT_ROOT}/verifier-portal/code/backend/keys/did-document.json"
rm -f "${PROJECT_ROOT}/verifier-portal/code/backend/keys/secrets.json"

# Backend env file (Dart API server on port 4001, uses Docker service names for trust registries)
cat > "${PROJECT_ROOT}/verifier-portal/code/backend/.env.ngrok" << EOF
APP_NAME=Nova Corp Verifier
APP_VERSION=1.0.0
PORT=4001
USE_SSL=false
VERIFIER_DID=did:web:localhost%3A4001:nova-corp
VERIFIER_DOMAIN=localhost:4001/nova-corp
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
ISSUER_MEDIATOR=${MEDIATOR_DID}
STORAGE_BACKEND=json
DATA_PATH=./data
HK_TRUST_REGISTRY_URL=http://trust-registry-hk:3232
HK_TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
MACAU_TRUST_REGISTRY_URL=http://trust-registry-macau:3232
MACAU_TRUST_REGISTRY_DID=${MACAU_TRUST_REGISTRY_DID}
SG_TRUST_REGISTRY_URL=http://trust-registry-sg:3232
SG_TRUST_REGISTRY_DID=${SG_TRUST_REGISTRY_DID}
SG_EDUCATION_MINISTRY_DID=did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry
SG_EDUCATION_MINISTRY_TRUST_REGISTRY_URL=http://trust-registry-sg:3232
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

# Frontend env file (Flutter web - uses localhost URLs since it runs in the browser)
cat > "${PROJECT_ROOT}/verifier-portal/code/frontend/.env.ngrok" << EOF
APP_NAME=Nova Corp Verifier
APP_VERSION=1.0.0
BACKEND_API=http://localhost:4001/
VERIFIER_URL=http://localhost:4001
VERIFIER_DID=did:web:localhost%3A4001:nova-corp
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

# --- Governance Portal env files (compile-time for Flutter web via --dart-define-from-file) ---
log_verbose "Creating Governance Portal env files..."

# These files are used at Docker BUILD TIME by flutter build web --dart-define-from-file
# They use localhost URLs because the Flutter web app runs in the browser on the host

mkdir -p "${PROJECT_ROOT}/governance-portal/instances/hk-ministry"
cat > "${PROJECT_ROOT}/governance-portal/instances/hk-ministry/.env.ngrok" << EOF
INSTANCE_ID=hk
MINISTRY_NAME=Hong Kong Ministry
GOVERNANCE_DID=did:web:localhost%3A8050:hk-ministry
TRUST_REGISTRY_URL=http://localhost:3232
TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
ADMIN_DID=${HK_ADMIN_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
USER_CONFIG_PATH=assets/user_config.hk.json
EOF

mkdir -p "${PROJECT_ROOT}/governance-portal/instances/macau-ministry"
cat > "${PROJECT_ROOT}/governance-portal/instances/macau-ministry/.env.ngrok" << EOF
INSTANCE_ID=macau
MINISTRY_NAME=Macau Ministry
GOVERNANCE_DID=did:web:localhost%3A8051:macau-ministry
TRUST_REGISTRY_URL=http://localhost:3233
TRUST_REGISTRY_DID=${MACAU_TRUST_REGISTRY_DID}
ADMIN_DID=${MACAU_ADMIN_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
USER_CONFIG_PATH=assets/user_config.macau.json
EOF

mkdir -p "${PROJECT_ROOT}/governance-portal/instances/sg-ministry"
cat > "${PROJECT_ROOT}/governance-portal/instances/sg-ministry/.env.ngrok" << EOF
INSTANCE_ID=sg
MINISTRY_NAME=Singapore Ministry
GOVERNANCE_DID=did:web:localhost%3A8052:sg-ministry
TRUST_REGISTRY_URL=http://localhost:3234
TRUST_REGISTRY_DID=${SG_TRUST_REGISTRY_DID}
ADMIN_DID=${SG_ADMIN_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
USER_CONFIG_PATH=assets/user_config.sg.json
EOF

# Note: Governance portal env files are loaded at container runtime via env_file
# in compose.governance.yml. No build-context copy needed (runtime config injection).

# --- Education Ministries env file ---
log_verbose "Creating Education Ministries service env file..."
mkdir -p "${PROJECT_ROOT}/education-ministries-did-hosting/instance"
cat > "${PROJECT_ROOT}/education-ministries-did-hosting/instance/.env.ngrok" << EOF
PORT=3100
DATA_PATH=./data

# Ministries to initialize
MINISTRIES=hongkong-education-ministry,macau-education-ministry,singapore-education-ministry

# Hong Kong Education Ministry
hongkong-education-ministry_DOMAIN=${EDU_MINISTRIES_DOMAIN}/hongkong-education-ministry
hongkong-education-ministry_TRUST_REGISTRY_URL=http://localhost:3232

# Macau Education Ministry
macau-education-ministry_DOMAIN=${EDU_MINISTRIES_DOMAIN}/macau-education-ministry
macau-education-ministry_TRUST_REGISTRY_URL=http://localhost:3233

# Singapore Education Ministry
singapore-education-ministry_DOMAIN=${EDU_MINISTRIES_DOMAIN}/singapore-education-ministry
singapore-education-ministry_TRUST_REGISTRY_URL=http://localhost:3234
EOF

# --- Student Vault App env file (for mobile/web use) ---
log_verbose "Creating Student Vault App env file..."
mkdir -p "${PROJECT_ROOT}/student-vault-app/code"
cat > "${PROJECT_ROOT}/student-vault-app/code/.env.ngrok" << EOF
APP_NAME=Student Vault
APP_VERSION=1.0.0
USE_SSL=false
HK_UNIVERSITY_SERVICE_URL=https://${HK_UNI_DOMAIN}
HK_UNIVERSITY_SERVICE_DID=did:web:${HK_UNI_DOMAIN}:hongkong-university
MACAU_UNIVERSITY_SERVICE_URL=https://${MACAU_UNI_DOMAIN}
MACAU_UNIVERSITY_SERVICE_DID=did:web:${MACAU_UNI_DOMAIN}:macau-university
NOVA_CORP_SERVICE_URL=http://localhost:4001
NOVA_CORP_SERVICE_DID=did:web:localhost%3A4001:nova-corp
HK_GOVERNANCE_PORTAL_URL=http://localhost:8050
MACAU_GOVERNANCE_PORTAL_URL=http://localhost:8051
SG_GOVERNANCE_PORTAL_URL=http://localhost:8052
HK_TRUST_REGISTRY_URL=http://localhost:3232
MACAU_TRUST_REGISTRY_URL=http://localhost:3233
SG_TRUST_REGISTRY_URL=http://localhost:3234
SERVICE_DID=${SERVICE_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

# Update organizations.json with ngrok domains
log_verbose "Updating organizations.json with ngrok domains..."
ORGS_JSON_FILE="${PROJECT_ROOT}/student-vault-app/code/assets/organizations.json"

cat > "${ORGS_JSON_FILE}" << EOF
{
  "universities": [
    {
      "did": "did:web:${HK_UNI_DOMAIN}:hongkong-university",
      "website": "https://${HK_UNI_DOMAIN}",
      "name": "Hong Kong University"
    },
    {
      "did": "did:web:${MACAU_UNI_DOMAIN}:macau-university",
      "website": "https://${MACAU_UNI_DOMAIN}",
      "name": "Macau University"
    }
  ]
}
EOF

log_info "Environment files created"
echo ""

# ============================================
# STEP 11: RUN SETUP SCRIPTS (only for student app)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Step 11: Running setup scripts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Education ministries data directory
mkdir -p "${PROJECT_ROOT}/education-ministries-did-hosting/instance/data"
log_info "Education Ministries data directory ready"

# Student Vault App setup (still needed for mobile app)
log_verbose "Setting up Student Vault App..."
cd "${PROJECT_ROOT}/student-vault-app"
./setup.sh >/dev/null 2>&1 || true
log_info "Student Vault App setup complete"

log_info "Setup scripts completed"
echo ""

# ============================================
# STEP 12: START ALL DOCKER SERVICES
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 Step 12: Starting ALL Docker services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "${PROJECT_ROOT}/deployment/docker"

# Clean up data and keys folders (they contain old ngrok domains and DIDs)
echo "  Clearing data and keys folders with old ngrok domains..."
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/hk-university/data" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/hk-university/keys" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/macau-university/data" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/macau-university/keys" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/education-ministries-did-hosting/instance/data" 2>/dev/null || true
log_info "Data and keys folders cleared (will be regenerated with new domains)"

# Stop and remove ALL existing containers
echo "  Checking for existing containers..."
for container_name in hk-university-issuer macau-university-issuer education-ministries-did-hosting \
                      trust-registry-hk trust-registry-macau trust-registry-sg \
                      hk-governance-portal macau-governance-portal sg-governance-portal \
                      nova-verifier-backend nova-verifier-frontend; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        echo "  Removing existing container: ${container_name}"
        docker rm -f "${container_name}" > /dev/null 2>&1 || true
    fi
done

# Also stop any old trust-registry docker-compose containers
cd "${PROJECT_ROOT}/trust-registry"
$DC down 2>/dev/null || true

# Stop any old monolithic compose project
cd "${PROJECT_ROOT}/deployment/docker"
$DC -f docker-compose.localhost.yml down 2>/dev/null || true

echo "  ✓ Existing containers cleaned up"

echo ""
echo "🔨 Building and starting ALL services via Docker..."
echo "   (This may take several minutes on first run for Flutter builds)"
echo ""

# Create shared network (if not exists)
docker network create education-trust-network 2>/dev/null || true

# Start services in dependency order:
# 1. Education Ministries (hosts DID documents needed by universities)
# 2. Trust Registries (needed by governance portals and verifier)
# 3. Universities (resolve DIDs from education ministries)
# 4. Governance Portals (connect to trust registries)
# 5. Verifier Portal (needs everything above)

echo "  🏛️  Starting Education Ministries..."
$DC -p etn-edu-ministries -f compose.edu-ministries.yml up -d --build

echo "  📋 Starting Trust Registries..."
$DC -p etn-trust-registries -f compose.trust-registries.yml up -d --build

echo "  🎓 Starting Universities..."
$DC -p etn-universities -f compose.universities.yml up -d --build

echo "  🏢 Starting Governance Portals..."
$DC -p etn-governance -f compose.governance.yml up -d --build

echo "  🔍 Starting Verifier Portal..."
$DC -p etn-nova-verifier -f compose.verifier.yml up -d --build

log_info "All Docker services started"
echo ""

echo "⏳ Waiting for Docker services to start (20 seconds)..."
sleep 20

echo ""
echo "🔍 Checking Docker container status..."
RUNNING_CONTAINERS=$(docker ps --filter "status=running" --format '{{.Names}}' | grep -E "university-issuer|education-ministries|trust-registry|governance-portal|nova-verifier" | wc -l | tr -d ' ')
TOTAL_EXPECTED=11
log_info "Docker services ready ($RUNNING_CONTAINERS/$TOTAL_EXPECTED containers running)"

# Show container status per group
echo ""
echo "  🎓 Universities:"
$DC -p etn-universities -f compose.universities.yml ps
echo ""
echo "  🏛️  Education Ministries:"
$DC -p etn-edu-ministries -f compose.edu-ministries.yml ps
echo ""
echo "  📋 Trust Registries:"
$DC -p etn-trust-registries -f compose.trust-registries.yml ps
echo ""
echo "  🏢 Governance Portals:"
$DC -p etn-governance -f compose.governance.yml ps
echo ""
echo "  🔍 Verifier Portal:"
$DC -p etn-nova-verifier -f compose.verifier.yml ps
echo ""

# ============================================
# SETUP COMPLETE
# ============================================
echo "═══════════════════════════════════════════════════════════"
echo "✅ All-Docker + Ngrok Environment Ready!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📦 All Services Running in Docker:"
echo ""
echo "   🇭🇰 HK University:        https://$HK_UNI_DOMAIN (ngrok → port 3000)"
echo "   🇲🇴 Macau University:     https://$MACAU_UNI_DOMAIN (ngrok → port 3001)"
echo "   🎓 Education Ministries:  https://$EDU_MINISTRIES_DOMAIN (ngrok → port 3100)"
echo ""
echo "   🏛️  Trust Registries:"
echo "      HK:    http://localhost:3232"
echo "      Macau: http://localhost:3233"
echo "      SG:    http://localhost:3234"
echo ""
echo "   📋 Governance Portals:"
echo "      HK:    http://localhost:8050"
echo "      Macau: http://localhost:8051"
echo "      SG:    http://localhost:8052"
echo ""
echo "   ✅ Nova Corp Verifier:"
echo "      Frontend: http://localhost:4000"
echo "      Backend:  http://localhost:4001"
echo ""
echo "� All DIDs Created:"
echo "   Universities:"
echo "      🇭🇰 HK University:     did:web:${HK_UNI_DOMAIN}:hongkong-university"
echo "      🇲🇴 Macau University:  did:web:${MACAU_UNI_DOMAIN}:macau-university"
echo "   Education Ministries:"
echo "      🇭🇰 HK Ministry:       did:web:${EDU_MINISTRIES_DOMAIN}:hongkong-education-ministry"
echo "      🇲🇴 Macau Ministry:    did:web:${EDU_MINISTRIES_DOMAIN}:macau-education-ministry"
echo "      🇸🇬 SG Ministry:       did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry"
echo ""
echo "🌐 DID Documents (via ngrok):"
echo "   Universities:"
echo "      HK:    https://$HK_UNI_DOMAIN/hongkong-university/did.json"
echo "      Macau: https://$MACAU_UNI_DOMAIN/macau-university/did.json"
echo "   Education Ministries:"
echo "      HK:    https://$EDU_MINISTRIES_DOMAIN/hongkong-education-ministry/did.json"
echo "      Macau: https://$EDU_MINISTRIES_DOMAIN/macau-education-ministry/did.json"
echo "      SG:    https://$EDU_MINISTRIES_DOMAIN/singapore-education-ministry/did.json"
echo ""
echo "📱 Mobile App:"
echo "   cd student-vault-app && flutter run   # Student Vault App"
echo ""
echo "🐳 Docker Management:"
echo "   bash deployment/scripts/dev-down.sh           # Stop all"
echo "   bash deployment/scripts/cleanup.sh            # Full cleanup"
echo "   docker compose -p etn-universities -f deployment/docker/compose.universities.yml logs  # University logs"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Ngrok Dashboard: http://localhost:4040"
echo "   (3 tunnels active: HK & Macau Universities + Education Ministries)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📄 Environment file: deployment/.env.ngrok (MODE=all-docker)"
echo ""
echo "To restart everything (new domains):"
echo "   bash deployment/scripts/dev-down.sh && bash deployment/scripts/dev-up.sh"
echo ""
echo "═══════════════════════════════════════════════════════════"
