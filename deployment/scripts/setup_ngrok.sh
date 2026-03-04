#!/bin/bash
# Nexigen Demo - Ngrok Complete Environment Setup
# This script starts ngrok tunnels FIRST, captures domains, writes .env.ngrok, then generates configs
set -e  # Exit on error

# Script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"

# Logging functions
log_info() { echo "✓ $1"; }
log_verbose() { echo "  $1"; }
log_error() { echo "❌ $1"; exit 1; }

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Nexigen Demo - Localhost + Ngrok Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will:"
echo "  1. Start 3 ngrok tunnels (Universities + Education Ministries)"
echo "  2. Use localhost for other services"
echo "  3. Write .env.ngrok with localhost/ngrok configuration"
echo "  4. Generate all configs & DIDs"
echo "  5. Launch Docker containers"
echo ""
echo "⚠️  Note: Ngrok free plan = 3 tunnels (using all available)"
echo "   Universities & Education Ministries: Internet accessible via ngrok"
echo "   Other services: Localhost only"
echo ""

# Check prerequisites
command -v ngrok >/dev/null 2>&1 || log_error "ngrok not installed. Install from: https://ngrok.com/download"
command -v docker >/dev/null 2>&1 || log_error "Docker not installed"
command -v jq >/dev/null 2>&1 || log_error "jq not installed. Install with: brew install jq"

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
        sed -i.bak "s|^NGROK_AUTH_TOKEN=.*|NGROK_AUTH_TOKEN=${NGROK_AUTH_TOKEN}|" "${PROJECT_ROOT}/deployment/.env.ngrok"
        rm -f "${PROJECT_ROOT}/deployment/.env.ngrok.bak"
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

# Kill any existing ngrok processes
pkill -f ngrok || true
sleep 2

# Create ngrok config file with 3 tunnels
mkdir -p ~/.config/ngrok
cat > ~/.config/ngrok/ngrok-nexigen.yml << EOF
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
nohup ngrok start --all --config ~/.config/ngrok/ngrok-nexigen.yml > "${PROJECT_ROOT}/deployment/ngrok.log" 2>&1 &
NGROK_PID=$!
echo "$NGROK_PID" > "${PROJECT_ROOT}/deployment/ngrok.pid"

log_verbose "Waiting for ngrok to initialize..."
sleep 5

# Check if ngrok is running
if ! ps -p "$NGROK_PID" > /dev/null 2>&1; then
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
# Nexigen Demo - Localhost + Ngrok Configuration
# Generated on $(date)

# Mode Configuration
MODE=localhost-ngrok
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

log_info ".env.ngrok created with hybrid configuration"

# Set shell variables for later use in echo statements
HK_UNIVERSITY_SERVICE_DID="did:web:${HK_UNI_DOMAIN}:hongkong-university"
MACAU_UNIVERSITY_SERVICE_DID="did:web:${MACAU_UNI_DOMAIN}:macau-university"
HK_EDUCATION_ECOSYSTEM_ID="did:web:${EDU_MINISTRIES_DOMAIN}:hongkong-education-ministry"
MACAU_EDUCATION_ECOSYSTEM_ID="did:web:${EDU_MINISTRIES_DOMAIN}:macau-education-ministry"
SG_EDUCATION_ECOSYSTEM_ID="did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry"
NOVA_CORP_SERVICE_DID="did:web:localhost%3A4001:nova-corp"

echo ""

# ============================================
# STEP 7: GENERATE ADMIN DIDs (using .env.ngrok)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Step 7: Generate Admin DIDs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generating user_config files for governance portals..."

cd "${PROJECT_ROOT}/governance-portal"
./generate-user-configs.sh "$MEDIATOR_URL" "$MEDIATOR_DID" >/dev/null 2>&1

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
# STEP 8: GENERATE TRUST REGISTRY DIDs (using .env.ngrok)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔑 Step 8: Generate Trust Registry DIDs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generating unique DIDs for each Trust Registry instance..."

cd "${PROJECT_ROOT}/trust-registry"
./generate-trust-registry-dids.sh >/dev/null 2>&1

# Extract Trust Registry DIDs
HK_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/hk/config/user_config.hk.json")
MACAU_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/macau/config/user_config.macau.json")
SG_TRUST_REGISTRY_DID=$(jq -r '.did' "${PROJECT_ROOT}/trust-registry/sg/config/user_config.sg.json")

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
# STEP 9: DEPLOY TRUST REGISTRIES
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏛️  Step 9: Deploy Trust Registries"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Deploying 3 Trust Registry instances on Docker..."

cd "${PROJECT_ROOT}/trust-registry"
./setup.sh >/dev/null 2>&1

log_info "Trust Registry instances deployed"
echo ""

# ============================================
# STEP 10: CREATE APP ENV FILES (from .env.ngrok)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Step 10: Creating app environment files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create university instance env files (using ngrok with SSL)
log_verbose "Creating Docker environment files for universities..."

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
TRUST_REGISTRY_URL=http://localhost:3232
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
TRUST_REGISTRY_URL=http://localhost:3233
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

# Create verifier portal env files (using ngrok)
log_verbose "Creating Verifier Portal env files..."
mkdir -p "${PROJECT_ROOT}/verifier-portal/code/backend"
mkdir -p "${PROJECT_ROOT}/verifier-portal/code/frontend"

# Clean old DID keys to force regeneration with new domain
log_verbose "Cleaning old verifier DID keys..."
rm -f "${PROJECT_ROOT}/verifier-portal/code/backend/keys/did-document.json"
rm -f "${PROJECT_ROOT}/verifier-portal/code/backend/keys/secrets.json"
log_verbose "Keys cleaned - fresh DID will be generated"

# Backend env file (Dart API server on port 4001)
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
HK_TRUST_REGISTRY_URL=http://localhost:3232
MACAU_TRUST_REGISTRY_URL=http://localhost:3233
SG_TRUST_REGISTRY_URL=http://localhost:3234
SG_EDUCATION_MINISTRY_DID=did:web:${EDU_MINISTRIES_DOMAIN}:singapore-education-ministry
SG_EDUCATION_MINISTRY_TRUST_REGISTRY_URL=http://localhost:3234
STUDENT_FIRST_NAME=${STUDENT_FIRST_NAME}
STUDENT_LAST_NAME=${STUDENT_LAST_NAME}
STUDENT_EMAIL=${STUDENT_EMAIL}
EOF

# Frontend env file (Flutter web on port 4000)
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

# Create governance portal env files (using local network)
log_verbose "Creating Governance Portal env files..."

mkdir -p "${PROJECT_ROOT}/governance-portal/instances/hk-ministry"
cat > "${PROJECT_ROOT}/governance-portal/instances/hk-ministry/.env.ngrok" << EOF
INSTANCE_ID=hk
UNIVERSITY_NAME=Hong Kong Ministry
GOVERNANCE_DID=did:web:localhost%3A8050:hk-ministry
TRUST_REGISTRY_URL=https://${HK_TR_DOMAIN}
TRUST_REGISTRY_DID=${HK_TRUST_REGISTRY_DID}
ADMIN_DID=${HK_ADMIN_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
USER_CONFIG_PATH=assets/user_config.hk.json
EOF

mkdir -p "${PROJECT_ROOT}/governance-portal/instances/macau-ministry"
cat > "${PROJECT_ROOT}/governance-portal/instances/macau-ministry/.env.ngrok" << EOF
INSTANCE_ID=macau
UNIVERSITY_NAME=Macau Ministry
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
UNIVERSITY_NAME=Singapore Ministry
GOVERNANCE_DID=did:web:localhost%3A8052:sg-ministry
TRUST_REGISTRY_URL=http://localhost:3234
TRUST_REGISTRY_DID=${SG_TRUST_REGISTRY_DID}
ADMIN_DID=${SG_ADMIN_DID}
MEDIATOR_DID=${MEDIATOR_DID}
MEDIATOR_URL=${MEDIATOR_URL}
USER_CONFIG_PATH=assets/user_config.sg.json
EOF

# Create education ministries service env file
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

# Create student vault app env file (universities use ngrok, others use localhost)
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
# STEP 11: RUN SETUP SCRIPTS
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Step 11: Running setup scripts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

log_verbose "Setting up University Issuance Service..."
cd "${PROJECT_ROOT}/university-issuance-service"
./setup.sh >/dev/null 2>&1
log_info "University Issuance Service setup complete"

log_verbose "Setting up Education Ministries DID Hosting..."
cd "${PROJECT_ROOT}/education-ministries-did-hosting"
./setup.sh >/dev/null 2>&1
log_info "Education Ministries service setup complete"

log_verbose "Setting up Verifier Portal..."
cd "${PROJECT_ROOT}/verifier-portal"
./setup.sh >/dev/null 2>&1
log_info "Verifier Portal setup complete"

log_verbose "Setting up Student Vault App..."
cd "${PROJECT_ROOT}/student-vault-app"
./setup.sh >/dev/null 2>&1
log_info "Student Vault App setup complete"

log_info "All setup scripts completed"
echo ""

# ============================================
# STEP 12: START DOCKER SERVICES
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 Step 12: Starting Docker services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "${PROJECT_ROOT}/deployment/docker"

# Clean up data and keys folders (they contain old ngrok domains and DIDs)
echo "  Clearing data and keys folders with old ngrok domains..."
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/hk-university/data" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/hk-university/keys" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/macau-university/data" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/university-issuance-service/instances/macau-university/keys" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/education-ministries-did-hosting/instance/data" 2>/dev/null || true
rm -rf "${PROJECT_ROOT}/education-ministries-did-hosting/instance/keys" 2>/dev/null || true
log_info "Data and keys folders cleared (will be regenerated with new domains)"

# Stop and remove existing containers if they exist
echo "  Checking for existing containers..."
for container_name in hk-university-issuer macau-university-issuer education-ministries-did-hosting; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        echo "  Removing existing container: ${container_name}"
        docker rm -f "${container_name}" > /dev/null 2>&1 || true
    fi
done
echo "  ✓ Existing containers cleaned up"

echo "Starting HK & Macau Universities + Education Ministries via Docker..."
docker-compose -f docker-compose.localhost.yml up -d --build

log_info "Docker services started"
echo ""

echo "⏳ Waiting for Docker services to start (15 seconds)..."
sleep 15

echo ""
echo "🔍 Checking Docker container status..."
RUNNING_CONTAINERS=$(docker ps --filter "status=running" | grep -E "university-issuer|education-ministries" | wc -l | tr -d ' ')
log_info "Docker services ready ($RUNNING_CONTAINERS containers running)"
echo ""

# ============================================
# SETUP COMPLETE
# ============================================
echo "═══════════════════════════════════════════════════════════"
echo "✅ Localhost + Ngrok Environment Ready!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📦 Docker Services:"
echo "   🇭🇰 HK University:        https://$HK_UNI_DOMAIN"
echo "   🇲🇴 Macau University:     https://$MACAU_UNI_DOMAIN"
echo "   🎓 Education Ministries:  https://$EDU_MINISTRIES_DOMAIN (port 3100)"
echo ""
echo "🌐 Education Ministry DIDs (all on ngrok):"
echo "      - HK Ministry:         https://$EDU_MINISTRIES_DOMAIN/hongkong-education-ministry/did.json"
echo "      - Macau Ministry:      https://$EDU_MINISTRIES_DOMAIN/macau-education-ministry/did.json"
echo "      - SG Ministry:         https://$EDU_MINISTRIES_DOMAIN/singapore-education-ministry/did.json"
echo ""
echo "🆔 All DIDs Created:"
echo "   Universities:"
echo "      🇭🇰 HK University:     $HK_UNIVERSITY_SERVICE_DID"
echo "      🇲🇴 Macau University:  $MACAU_UNIVERSITY_SERVICE_DID"
echo "   Education Ministries:"
echo "      🇭🇰 HK Ministry:       $HK_EDUCATION_ECOSYSTEM_ID"
echo "      🇲🇴 Macau Ministry:    $MACAU_EDUCATION_ECOSYSTEM_ID"
echo "      🇸🇬 SG Ministry:       $SG_EDUCATION_ECOSYSTEM_ID"
echo "   Verifier:"
echo "      ✅ Nova Corp:          $NOVA_CORP_SERVICE_DID"
echo ""
echo "💻 Localhost Services:"
echo "   🏛️  Trust Registries:     http://localhost:3232 (HK), :3233 (Macau), :3234 (SG)"
echo "   📋 Governance Portals:    http://localhost:8050 (HK), :8051 (Macau), :8052 (SG)"
echo "   ✅ Nova Corp Verifier:    http://localhost:4001"
echo ""
echo "🚀 Next: Start Flutter apps manually"
echo ""
echo "Governance Portals:"
echo "   make hk-gov              # HK Ministry (port 8050)"
echo "   make macau-gov           # Macau Ministry (port 8051)"
echo "   make sg-gov              # Singapore Ministry (port 8052)"
echo ""
echo "Verifier & Student App:"
echo "   make verifier            # Nova Corp Verifier (port 4000)"
echo "   make student-ios         # Student Vault App (iOS)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Ngrok Dashboard: http://localhost:4040"
echo "   (3 tunnels active: HK & Macau Universities + Education Ministries)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📄 Environment file: deployment/.env.ngrok (MODE=localhost-ngrok)"
echo ""
echo "To restart everything (new domains):"
echo "   make dev-down && make dev-up"
echo ""
echo "═══════════════════════════════════════════════════════════"
