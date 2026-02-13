#!/bin/bash
# Trust Registry Setup Script
# Sets up and deploys 3 Trust Registry instances for HK, Macau, and Singapore
set -e

echo "🏛️  Setting up Trust Registry instances..."
echo ""

# Check if we're in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if trust registry user_config files exist
if [ ! -f "hk/config/user_config.hk.json" ]; then
    echo "❌ Error: Trust registry user_config.hk.json not found"
    echo "   Please run trust-registry/generate-trust-registry-dids.sh first"
    exit 1
fi

if [ ! -f "macau/config/user_config.macau.json" ]; then
    echo "❌ Error: Trust registry user_config.macau.json not found"
    echo "   Please run trust-registry/generate-trust-registry-dids.sh first"
    exit 1
fi

if [ ! -f "sg/config/user_config.sg.json" ]; then
    echo "❌ Error: Trust registry user_config.sg.json not found"
    echo "   Please run trust-registry/generate-trust-registry-dids.sh first"
    exit 1
fi

echo "✅ Trust registry user_config files found"
echo ""

# Extract Admin DIDs from governance portal user_config files
echo "🔑 Extracting Admin DIDs from governance portal configs..."
HK_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.hk.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')
MACAU_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.macau.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')
SG_ADMIN_DID=$(cat ../governance-portal/code/assets/user_config.sg.json | grep -o '"did:peer:2[^"]*"' | head -1 | tr -d '"')

echo "  HK Admin DID: ${HK_ADMIN_DID:0:60}..."
echo "  Macau Admin DID: ${MACAU_ADMIN_DID:0:60}..."
echo "  SG Admin DID: ${SG_ADMIN_DID:0:60}..."
echo ""

# Extract Trust Registry profile configs (these are JSON objects, not just DIDs)
# Compress to single line for use as environment variables
echo "🔑 Extracting Trust Registry profile configs..."
HK_PROFILE_CONFIG=$(cat hk/config/user_config.hk.json | tr -d '\n' | tr -d ' ')
MACAU_PROFILE_CONFIG=$(cat macau/config/user_config.macau.json | tr -d '\n' | tr -d ' ')
SG_PROFILE_CONFIG=$(cat sg/config/user_config.sg.json | tr -d '\n' | tr -d ' ')
echo ""

# Check if mediator configuration exists in main .env (try .env.ngrok first, then .env.local-network)
ENV_FILE=""
if [ -f "../deployment/.env.ngrok" ]; then
    ENV_FILE="../deployment/.env.ngrok"
elif [ -f "../deployment/.env.local-network" ]; then
    ENV_FILE="../deployment/.env.local-network"
elif [ -f "../deployment/.env" ]; then
    ENV_FILE="../deployment/.env"
else
    echo "❌ Error: No environment file found"
    echo "   Expected: ../deployment/.env.ngrok or ../deployment/.env.local-network"
    echo "   Please run setup_localhost.sh or setup_ngrok.sh first"
    exit 1
fi

echo "📄 Using environment file: $ENV_FILE"

# Extract mediator info from .env
MEDIATOR_DID=$(grep "^MEDIATOR_DID=" "$ENV_FILE" | cut -d'=' -f2- | tr -d '"')
MEDIATOR_URL=$(grep "^MEDIATOR_URL=" "$ENV_FILE" | cut -d'=' -f2- | tr -d '"')

if [ -z "$MEDIATOR_DID" ] || [ -z "$MEDIATOR_URL" ]; then
    echo "❌ Error: MEDIATOR_DID or MEDIATOR_URL not found in $ENV_FILE"
    echo "   Please run setup_localhost.sh first"
    exit 1
fi

echo "📡 Mediator Configuration:"
echo "  URL: $MEDIATOR_URL"
echo "  DID: ${MEDIATOR_DID:0:60}..."
echo ""

# Create .env file for docker-compose
cat > .env << EOF
# Trust Registry Docker Configuration
# Generated on $(date)

# Mediator Configuration (shared by all instances)
HK_MEDIATOR_DID=${MEDIATOR_DID}
MACAU_MEDIATOR_DID=${MEDIATOR_DID}
SG_MEDIATOR_DID=${MEDIATOR_DID}

# Admin DIDs (from user_config files)
HK_ADMIN_DID=${HK_ADMIN_DID}
MACAU_ADMIN_DID=${MACAU_ADMIN_DID}
SG_ADMIN_DID=${SG_ADMIN_DID}

# Profile Configs (JSON strings for PROFILE_CONFIG environment variable)
HK_PROFILE_CONFIG=${HK_PROFILE_CONFIG}
MACAU_PROFILE_CONFIG=${MACAU_PROFILE_CONFIG}
SG_PROFILE_CONFIG=${SG_PROFILE_CONFIG}
EOF

echo "✅ Docker environment file created"
echo ""

# Create empty CSV files for trust registry data storage
echo "📁 Creating data directories and CSV files..."
mkdir -p hk/data macau/data sg/data

# Create empty CSV files with headers
cat > hk/data/data.csv << EOF
entity_id,authority_id,action,resource,recognized,authorized,context,record_type
EOF

cat > macau/data/data.csv << EOF
entity_id,authority_id,action,resource,recognized,authorized,context,record_type
EOF

cat > sg/data/data.csv << EOF
entity_id,authority_id,action,resource,recognized,authorized,context,record_type
EOF

echo "✅ Data CSV files created"
echo ""

# Clone the trust registry repository if not already present
if [ ! -d "affinidi-trust-registry-rs" ]; then
    echo "📥 Cloning Trust Registry repository..."
    git clone https://github.com/affinidi/affinidi-trust-registry-rs.git
    echo "✅ Repository cloned"
    echo ""
else
    echo "✓ Trust Registry repository already exists"
    echo ""
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running"
    echo "   Please start Docker Desktop and try again"
    exit 1
fi

echo "🐳 Building and starting Trust Registry containers..."
echo "   (This may take several minutes on first run)"
echo ""

# Stop any existing containers
docker-compose down 2>/dev/null || true

# Build and start the containers
docker-compose up --build -d

echo ""
echo "✅ Trust Registry instances started!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Trust Registry Endpoints"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🇭🇰 Hong Kong Trust Registry:"
echo "   URL: http://localhost:3232"
echo "   DID: Will be created by the container"
echo ""
echo "🇲🇴 Macau Trust Registry:"
echo "   URL: http://localhost:3233"
echo "   DID: Will be created by the container"
echo ""
echo "🇸🇬 Singapore Trust Registry:"
echo "   URL: http://localhost:3234"
echo "   DID: Will be created by the container"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Wait for containers to be healthy (check with: docker-compose ps)"
echo ""
echo "2. Test the endpoints:"
echo "   curl http://localhost:3232/health"
echo "   curl http://localhost:3233/health"
echo "   curl http://localhost:3234/health"
echo ""
echo "3. View logs:"
echo "   docker-compose logs -f trust-registry-hk"
echo "   docker-compose logs -f trust-registry-macau"
echo "   docker-compose logs -f trust-registry-sg"
echo ""
echo "4. Stop all instances:"
echo "   docker-compose down"
echo ""
