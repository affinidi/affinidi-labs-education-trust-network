.PHONY: help hk-gov macau-gov sg-gov verifier student-ios student-android \
        hk-university macau-university education-ministries \
        docker-ps docker-logs docker-logs-hk docker-logs-macau docker-logs-tr-hk docker-logs-edu \
        docker-stop docker-restart docker-up docker-rebuild docker-rebuild-hk \
        docker-restart-quick docker-restart-hk setup dev-up dev-down cleanup

# Default target - show help
help:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "📚 Nexigen Demo - Makefile Commands"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "🚀 APPLICATION COMMANDS:"
	@echo "  make hk-gov              - Start HK Governance Portal"
	@echo "  make macau-gov           - Start Macau Governance Portal"
	@echo "  make sg-gov              - Start Singapore Governance Portal"
	@echo "  make verifier            - Start Nova Corp Verifier Portal"
	@echo "  make student-ios         - Start Student Vault App (iOS)"
	@echo "  make student-android     - Start Student Vault App (Android)"
	@echo ""
	@echo "🎓 BACKEND SERVICES (Local Dev):"
	@echo "  make hk-university       - Start HK University Issuer (local Dart)"
	@echo "  make macau-university    - Start Macau University Issuer (local Dart)"
	@echo "  make education-ministries - Start Education Ministries DID hosting (local Dart)"
	@echo ""
	@echo "🐳 DOCKER MANAGEMENT:"
	@echo "  make docker-ps           - Check container status"
	@echo "  make docker-logs         - View logs (all services)"
	@echo "  make docker-logs-hk      - View HK University Issuer logs"
	@echo "  make docker-logs-macau   - View Macau University Issuer logs"
	@echo "  make docker-logs-tr-hk   - View HK Trust Registry logs"
	@echo "  make docker-logs-edu     - View Education Ministries logs"
	@echo "  make docker-stop         - Stop all services"
	@echo "  make docker-restart      - Restart all services"
	@echo ""
	@echo "🔄 DOCKER BUILD & DEPLOY:"
	@echo "  make docker-up           - Start all services"
	@echo "  make docker-rebuild      - Rebuild and restart all services"
	@echo "  make docker-rebuild-hk   - Rebuild HK University service"
	@echo "  make docker-restart-quick - Quick restart without rebuild"
	@echo "  make docker-restart-hk   - Restart HK University service"
	@echo ""
	@echo "⚙️  SETUP & CLEANUP:"
	@echo "  make setup               - Run localhost setup script"
	@echo "  make dev-up              - Start ngrok environment (tunnels + configs + Docker)"
	@echo "  make dev-down            - Stop ngrok tunnels and Docker services"
	@echo "  make cleanup             - Run cleanup script"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# APPLICATION COMMANDS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

hk-gov:
	@echo "🚀 Starting HK Governance Portal..."
	cd governance-portal/code && make hk

macau-gov:
	@echo "🚀 Starting Macau Governance Portal..."
	cd governance-portal/code && make macau

sg-gov:
	@echo "🚀 Starting Singapore Governance Portal..."
	cd governance-portal/code && make sg

verifier:
	@echo "🚀 Starting Nova Corp Verifier Portal..."
	cd verifier-portal/code && make dev-up

student-ios:
	@echo "🚀 Starting Student Vault App (iOS)..."
	cd student-vault-app/code && make ios

student-android:
	@echo "📱 Starting Student Vault App (Android)..."
	@echo "⚠️  Note: Make sure to edit .env.local-network and replace '0.0.0.0' with '10.0.2.2' for Android emulator"
	cd student-vault-app/code && make android

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# BACKEND SERVICES (Local Development)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

hk-university:
	@echo "🚀 Starting HK University Issuer (local Dart)..."
	cd university-issuance-service && make hk-university

macau-university:
	@echo "🚀 Starting Macau University Issuer (local Dart)..."
	cd university-issuance-service && make macau-university

education-ministries:
	@echo "🚀 Starting Education Ministries DID Hosting (local Dart)..."
	cd education-ministries-did-hosting && make dev-up

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER MANAGEMENT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-ps:
	@echo "📊 Checking container status..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml ps

docker-logs:
	@echo "📋 Viewing logs (all services)..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml logs -f

docker-logs-hk:
	@echo "📋 Viewing HK University Issuer logs..."
	docker logs hk-university-issuer -f

docker-logs-macau:
	@echo "📋 Viewing Macau University Issuer logs..."
	docker logs macau-university-issuer -f

docker-logs-tr-hk:
	@echo "📋 Viewing HK Trust Registry logs..."
	docker logs hk-trust-registry -f

docker-logs-edu:
	@echo "📋 Viewing Education Ministries logs..."
	docker logs education-ministries-did-hosting -f

docker-stop:
	@echo "🛑 Stopping all services..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml down

docker-restart:
	@echo "🔄 Restarting all services..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml restart

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER BUILD & DEPLOY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-up:
	@echo "🚀 Starting all services..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml up -d

docker-rebuild:
	@echo "🔨 Rebuilding and restarting all services..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml up -d --build

docker-rebuild-hk:
	@echo "🔨 Rebuilding HK University service..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml up -d --build hk-university-issuer

docker-restart-quick:
	@echo "⚡ Quick restart without rebuild..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml restart

docker-restart-hk:
	@echo "⚡ Restarting HK University service..."
	docker-compose -f deployment/docker/docker-compose.localhost.yml restart hk-university-issuer

docker-tr-rebuild:
	@echo "🔨 Rebuilding Trust Registry..."
	cd trust-registry && docker-compose up -d --build

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SETUP & CLEANUP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

setup:
	@echo "🔧 Running localhost setup..."
	bash deployment/scripts/setup.sh

dev-up:
	@echo "🌐 Starting complete localhost + ngrok environment..."
	@echo "This will:"
	@echo "  • Start 3 ngrok tunnels (2 Universities + Education Ministries)"
	@echo "  • Use localhost for governance portals, verifier, and local TRs"
	@echo "  • Capture dynamic domains"
	@echo "  • Regenerate all configs & DIDs"
	@echo "  • Launch Docker containers"
	@echo ""
	bash deployment/scripts/setup_ngrok.sh

dev-down:
	@echo "🛑 Stopping ngrok tunnels and Docker services..."
	@pkill -f ngrok || true
	@docker-compose -f deployment/docker/docker-compose.localhost.yml down || true
	@cd trust-registry && docker-compose down || true
	@echo "✅ Services stopped"

cleanup:
	@echo "🧹 Running cleanup script..."
	bash deployment/scripts/cleanup.sh
