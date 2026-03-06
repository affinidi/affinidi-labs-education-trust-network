#!/bin/bash
# Cleanup script for Nexigen (All-Docker mode)
# Cross-platform: works on macOS, Linux, and Windows (Git Bash / WSL)
set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"
cd "$SCRIPT_DIR"

echo "🧹 Cleaning up Nexigen components (All-Docker mode)..."
echo ""
echo "📦 Note: Component code folders are part of the repository and will NOT be removed."
echo "   Only generated environment files, user configs, and data directories will be cleaned."
echo ""

# Stop ngrok tunnels if running
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Stopping ngrok tunnels..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -f "${PROJECT_ROOT}/deployment/ngrok.pid" ]; then
    echo "  Stopping ngrok via PID file..."
    NGROK_PID=$(cat "${PROJECT_ROOT}/deployment/ngrok.pid")
    kill "$NGROK_PID" 2>/dev/null || true
    rm -f "${PROJECT_ROOT}/deployment/ngrok.pid"
    echo "  ✅ Ngrok stopped"
fi
if command -v pkill >/dev/null 2>&1; then
    pkill -f ngrok 2>/dev/null || true
fi

# Clean ngrok log files
echo "  🗑️  Removing ngrok log files..."
rm -f /tmp/ngrok-*.log
rm -f ~/.config/ngrok/ngrok-nexigen.yml
echo "  ✅ Ngrok log files removed"

# Function to clean a directory
cleanup_directory() {
    local dir=$1
    local name=$2

    if [ -d "$dir" ]; then
        echo "  🗑️  Removing $name..."
        rm -rf "$dir"
        echo "  ✅ $name removed"
    else
        echo "  ⏭️  $name not found, skipping..."
    fi
}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Stopping ALL Docker containers..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Docker compose v2 detection
if docker compose version >/dev/null 2>&1; then
    DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    DC="docker-compose"
else
    DC="docker compose"
fi

# Stop unified docker-compose services
if [ -f "../docker/docker-compose.localhost.yml" ]; then
    echo "  Stopping all Docker services..."
    $DC -f ../docker/docker-compose.localhost.yml down 2>/dev/null || true
    echo "  ✅ Docker services stopped"
fi

# Also stop any legacy trust-registry docker-compose containers
if [ -f "../../trust-registry/docker-compose.yml" ]; then
    echo "  Stopping legacy Trust Registry containers..."
    cd ../../trust-registry && $DC down 2>/dev/null || true
    cd "$SCRIPT_DIR"
    echo "  ✅ Legacy Trust Registry containers stopped"
fi

# Remove Docker images from this project (including DID generation images)
echo "  Removing Docker images..."
docker images | grep -E 'nexigen|university-issuer|governance-portal|verifier|trust-registry|education-ministries|nexigen-did-gen|tr-did-gen' | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || echo "  Some images could not be removed (may be in use)"

# Remove named volumes
echo "  🗑️  Removing Docker volumes..."
docker volume rm verifier-backend-data verifier-backend-keys 2>/dev/null || true
echo "  ✅ Docker cleanup complete"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning Governance Portal files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "../../governance-portal/code" ]; then
    echo "  🗑️  Removing governance portal environment and config files..."
    rm -f ../../governance-portal/code/.env.hk.local-network
    rm -f ../../governance-portal/code/.env.macau.local-network
    rm -f ../../governance-portal/code/.env.sg.local-network
    rm -f ../../governance-portal/code/.env.hk.localhost
    rm -f ../../governance-portal/code/.env.macau.localhost
    rm -f ../../governance-portal/code/.env.sg.localhost
    rm -f ../../governance-portal/code/.env.hk.ngrok
    rm -f ../../governance-portal/code/.env.macau.ngrok
    rm -f ../../governance-portal/code/.env.sg.ngrok
    rm -f ../../governance-portal/code/.env.hk
    rm -f ../../governance-portal/code/.env.macau
    rm -f ../../governance-portal/code/.env.sg
    rm -f ../../governance-portal/code/.env.docker.hk
    rm -f ../../governance-portal/code/.env.docker.macau
    rm -f ../../governance-portal/code/.env.docker.sg
    rm -f ../../governance-portal/code/.mediator_config
    rm -f ../../governance-portal/code/assets/user_config.hk.json
    rm -f ../../governance-portal/code/assets/user_config.macau.json
    rm -f ../../governance-portal/code/assets/user_config.sg.json
    rm -f ../../governance-portal/code/assets/user_config.json
    echo "  ✅ Governance portal files removed"
fi

# Clean instance env files
rm -f ../../governance-portal/instances/hk-ministry/.env.ngrok
rm -f ../../governance-portal/instances/macau-ministry/.env.ngrok
rm -f ../../governance-portal/instances/sg-ministry/.env.ngrok

# Clean Rust DID generation helper temporary files
if [ -d "../../governance-portal/rust-did-generation-helper" ]; then
    echo "  Removing Rust DID generation helper temporary files..."
    rm -f ../../governance-portal/rust-did-generation-helper/.env.test
    rm -f ../../governance-portal/rust-did-generation-helper/.env
    rm -rf ../../governance-portal/rust-did-generation-helper/output_tmp
    echo "  ✅ Rust DID generation helper temporary files removed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning Trust Registry files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "../../trust-registry" ]; then
    echo "  🗑️  Removing Trust Registry data, configs, and env files..."
    rm -rf ../../trust-registry/hk/config/*.json
    rm -rf ../../trust-registry/macau/config/*.json
    rm -rf ../../trust-registry/sg/config/*.json
    rm -f ../../trust-registry/.env
    rm -f ../../trust-registry/hk/docker.env
    rm -f ../../trust-registry/macau/docker.env
    rm -f ../../trust-registry/sg/docker.env
    
    # Remove cloned repository
    if [ -d "../../trust-registry/affinidi-trust-registry-rs" ]; then
        echo "  🗑️  Removing cloned Trust Registry repository..."
        rm -rf ../../trust-registry/affinidi-trust-registry-rs
    fi
    
    # Reset CSV files to empty state with proper header
    echo "entity_id,authority_id,action,resource,recognized,authorized,context,record_type" > ../../trust-registry/hk/data/data.csv
    echo "entity_id,authority_id,action,resource,recognized,authorized,context,record_type" > ../../trust-registry/macau/data/data.csv
    echo "entity_id,authority_id,action,resource,recognized,authorized,context,record_type" > ../../trust-registry/sg/data/data.csv
    
    echo "  ✅ Trust Registry files cleaned"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning university service files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cleanup_directory "../../university-issuance-service/instances/hk-university/data" "HK University data"
cleanup_directory "../../university-issuance-service/instances/hk-university/keys" "HK University keys"
cleanup_directory "../../university-issuance-service/instances/macau-university/data" "Macau University data"
cleanup_directory "../../university-issuance-service/instances/macau-university/keys" "Macau University keys"

# Clean environment files
rm -f ../../university-issuance-service/instances/hk-university/.env.local-network
rm -f ../../university-issuance-service/instances/hk-university/.env.localhost
rm -f ../../university-issuance-service/instances/hk-university/.env.ngrok
rm -f ../../university-issuance-service/instances/macau-university/.env.local-network
rm -f ../../university-issuance-service/instances/macau-university/.env.localhost
rm -f ../../university-issuance-service/instances/macau-university/.env.ngrok
rm -f ../../university-issuance-service/code/.env.hk.local-network
rm -f ../../university-issuance-service/code/.env.hk.localhost
rm -f ../../university-issuance-service/code/.env.hk.ngrok
rm -f ../../university-issuance-service/code/.env.macau.local-network
rm -f ../../university-issuance-service/code/.env.macau.localhost
rm -f ../../university-issuance-service/code/.env.macau.ngrok
echo "  ✅ University service files cleaned"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning verifier, education ministries, and student app files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verifier portal
rm -f ../../verifier-portal/code/.env.local-network
rm -f ../../verifier-portal/code/.env.localhost
rm -f ../../verifier-portal/code/.env.ngrok
rm -f ../../verifier-portal/code/backend/.env.ngrok
rm -f ../../verifier-portal/code/backend/.env
rm -f ../../verifier-portal/code/frontend/.env.ngrok
cleanup_directory "../../verifier-portal/code/backend/data" "Verifier backend data"
cleanup_directory "../../verifier-portal/code/backend/keys" "Verifier backend keys"

# Education ministries
rm -f ../../education-ministries-did-hosting/instance/.env.ngrok
cleanup_directory "../../education-ministries-did-hosting/instance/data" "Education Ministries data"

# Student vault app
rm -f ../../student-vault-app/code/.env.local-network
rm -f ../../student-vault-app/code/.env.localhost
rm -f ../../student-vault-app/code/.env.ngrok

# Reset organizations.json
if [ -f "../../student-vault-app/configs/organizations.dart" ]; then
    cp "../../student-vault-app/configs/organizations.dart" \
       "../../student-vault-app/code/lib/core/infrastructure/repositories/organizations_repository/organizations.dart"
fi

echo "  ✅ Environment files cleaned"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning deployment env files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

rm -f ../../deployment/.env.ngrok
rm -f ../../deployment/.env.local-network
rm -f ../../deployment/ngrok.pid
echo "  ✅ Deployment env files cleaned"

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "To set up again, run:"
echo "  bash deployment/scripts/dev-up.sh"