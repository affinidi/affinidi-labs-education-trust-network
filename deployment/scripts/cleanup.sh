#!/bin/bash
# Cleanup script for Certizen
set -e  # Exit on error

echo "🧹 Cleaning up Certizen components..."
echo ""
echo "📦 Note: Component code folders (governance-portal, university-issuance-service,"
echo "   verifier-portal, trust-registry, student-vault-app) are part of the repository and will NOT be removed"
echo "   Only generated environment files, user configs, and data directories will be cleaned"
echo ""

# Stop ngrok tunnels if running
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Stopping ngrok tunnels..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if pgrep -f ngrok > /dev/null; then
    echo "  🛑 Stopping ngrok processes..."
    pkill -f ngrok || true
    echo "  ✅ Ngrok tunnels stopped"
else
    echo "  ⏭️  No ngrok processes running"
fi

# Clean ngrok log files
echo "  🗑️  Removing ngrok log files..."
rm -f /tmp/ngrok-*.log
rm -f ~/.config/ngrok/ngrok-certizen.yml
echo "  ✅ Ngrok log files removed"

# Clean ngrok token from .env files
echo "  🗑️  Removing ngrok token from .env files..."
if [ -f "../../deployment/.env.ngrok" ]; then
    sed -i.bak '/^NGROK_AUTH_TOKEN=/d' ../../deployment/.env.ngrok
    rm -f ../../deployment/.env.ngrok.bak
fi
if [ -f "../../deployment/.env.local-network" ]; then
    sed -i.bak '/^NGROK_AUTH_TOKEN=/d' ../../deployment/.env.local-network
    rm -f ../../deployment/.env.local-network.bak
fi
echo "  ✅ Ngrok token removed"

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
echo "Cleaning Governance Portal environment files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clean environment files created by setup scripts
if [ -d "../../governance-portal/code" ]; then
    echo "  🗑️  Removing governance portal environment files..."
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
    rm -f ../../governance-portal/code/.mediator_config
    rm -f ../../governance-portal/code/assets/user_config.hk.json
    rm -f ../../governance-portal/code/assets/user_config.macau.json
    rm -f ../../governance-portal/code/assets/user_config.sg.json
    rm -f ../../governance-portal/code/assets/user_config.json
    echo "  ✅ Governance portal environment files removed"
else
    echo "  ⏭️  Governance portal code directory not found, skipping..."
fi

# Clean Rust DID generation helper temporary files
if [ -d "../../governance-portal/rust-did-generation-helper" ]; then
    echo "  🗑️  Removing Rust DID generation helper temporary files..."
    rm -f ../../governance-portal/rust-did-generation-helper/.env.test
    rm -f ../../governance-portal/rust-did-generation-helper/.env
    echo "  ✅ Rust DID generation helper temporary files removed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning Trust Registry Docker containers..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "../../trust-registry" ]; then
    cd ../../trust-registry
    if [ -f "docker-compose.yml" ]; then
        echo "  🛑 Stopping Trust Registry containers..."
        docker-compose down 2>/dev/null || true
        echo "  ✅ Trust Registry containers stopped"
    fi
    
    # Clean generated config and data
    echo "  🗑️  Removing Trust Registry data and configs..."
    rm -rf hk/config/*.json
    rm -rf macau/config/*.json
    rm -rf sg/config/*.json
    rm -f .env
    
    # Remove cloned repository
    if [ -d "affinidi-trust-registry-rs" ]; then
        echo "  🗑️  Removing cloned Trust Registry repository..."
        rm -rf affinidi-trust-registry-rs
    fi
    
    # Reset CSV files to empty state with proper header only
    echo "entity_id,authority_id,action,resource,context" > hk/data/data.csv
    echo "entity_id,authority_id,action,resource,context" > macau/data/data.csv
    echo "entity_id,authority_id,action,resource,context" > sg/data/data.csv
    
    cd ../deployment/scripts
    echo "  ✅ Trust Registry files cleaned"
else
    echo "  ⏭️  Trust Registry directory not found, skipping..."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning Governance Portal data..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cleanup_directory "../../governance-portal/data" "Governance Portal data"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning generated data directories..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cleanup_directory "../../verifier-portal/data" "Verifier Portal data"
cleanup_directory "../../hk-issuance-service/data" "HK Issuance Service data"
cleanup_directory "../../macau-issuance-service/data" "Macau Issuance Service data"


cp "../../student-vault-app/configs/organizations.dart" "../../student-vault-app/code/lib/core/infrastructure/repositories/organizations_repository/organizations.dart"

# echo ""
# echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# echo "Cleaning ngrok domains..."
# echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
# if [ -f "ngrok/domains.json" ]; then
#     echo "  🗑️  Removing domains.json..."
#     rm -f "ngrok/domains.json"
#     echo "  ✅ domains.json removed"
# else
#     echo "  ⏭️  domains.json not found, skipping..."
# fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning Docker containers and volumes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Stop localhost Docker services
if [ -f "../docker/docker-compose.localhost.yml" ]; then
    echo "  🛑 Stopping localhost Docker services..."
    docker-compose -f ../docker/docker-compose.localhost.yml down 2>/dev/null || true
    echo "  ✅ Localhost Docker services stopped"
fi

# Stop ngrok Docker services
if docker compose ps -q 2>/dev/null | grep -q .; then
    echo "  🛑 Stopping ngrok Docker containers..."
    docker compose down 2>/dev/null || true
    echo "  ✅ Ngrok Docker containers stopped"
else
    echo "  ⏭️  No running ngrok containers found"
fi

# Remove Docker images from this project
echo "  🗑️  Removing Docker images..."
docker images | grep -E 'certizen|university-issuer' | awk '{print $3}' | xargs -r docker rmi 2>/dev/null || echo "  ⚠️  Some images could not be removed (may be in use)"
echo "  ✅ Docker images cleaned"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning university service data..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clean university instances
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
echo "Cleaning verifier and student app environment files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

rm -f ../../verifier-portal/code/.env.local-network
rm -f ../../verifier-portal/code/.env.localhost
rm -f ../../verifier-portal/code/.env.ngrok
rm -f ../../student-vault-app/code/.env.local-network
rm -f ../../student-vault-app/code/.env.localhost
rm -f ../../student-vault-app/code/.env.ngrok

echo "  ✅ Environment files cleaned"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleaning main .env file..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "../.env" ]; then
    # rm -f ../.env
    echo "  ✅ Main .env file removed"
fi

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "To set up again, run:"
echo "  make setup"