.PHONY: help student-ios student-android \
        docker-ps docker-logs docker-logs-hk docker-logs-macau docker-logs-tr-hk docker-logs-edu \
        docker-logs-gov-hk docker-logs-gov-macau docker-logs-gov-sg docker-logs-verifier-backend docker-logs-verifier-frontend \
        docker-stop docker-restart docker-up docker-rebuild docker-rebuild-hk \
        docker-restart-quick docker-restart-hk dev-up dev-down cleanup

COMPOSE_FILE=deployment/docker/docker-compose.localhost.yml

# Default target - show help
help:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Nexigen Demo - All-Docker + Ngrok"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "ALL SERVICES RUN IN DOCKER (except ngrok + student mobile app)"
	@echo ""
	@echo "SETUP & TEARDOWN (single commands):"
	@echo "  make dev-up              - Full setup (ngrok + configs + Docker)"
	@echo "  make dev-down            - Stop everything (ngrok + Docker)"
	@echo "  make cleanup             - Full cleanup (stop + remove files)"
	@echo ""
	@echo "WINDOWS/WSL: Call scripts directly instead of make:"
	@echo "  bash deployment/scripts/dev-up.sh"
	@echo "  bash deployment/scripts/dev-down.sh"
	@echo "  bash deployment/scripts/cleanup.sh"
	@echo ""
	@echo "MOBILE APP:"
	@echo "  make student-ios         - Student Vault App (iOS)"
	@echo "  make student-android     - Student Vault App (Android)"
	@echo ""
	@echo "DOCKER MANAGEMENT:"
	@echo "  make docker-ps           - Container status"
	@echo "  make docker-logs         - All logs"
	@echo "  make docker-stop         - Stop all services"
	@echo "  make docker-restart      - Restart all services"
	@echo "  make docker-up           - Start all services"
	@echo "  make docker-rebuild      - Rebuild and restart all services"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MOBILE APP COMMANDS (still runs natively)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

student-ios:
	@echo "🚀 Starting Student Vault App (iOS)..."
	cd student-vault-app/code && make ios

student-android:
	@echo "📱 Starting Student Vault App (Android)..."
	@echo "⚠️  Note: Make sure to edit .env.local-network and replace '0.0.0.0' with '10.0.2.2' for Android emulator"
	cd student-vault-app/code && make android

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER MANAGEMENT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-ps:
	@echo "📊 Container status..."
	@docker-compose -f $(COMPOSE_FILE) ps

docker-logs:
	@echo "📋 All service logs..."
	docker-compose -f $(COMPOSE_FILE) logs -f

docker-logs-hk:
	docker logs hk-university-issuer -f

docker-logs-macau:
	docker logs macau-university-issuer -f

docker-logs-edu:
	docker logs education-ministries-did-hosting -f

docker-logs-tr-hk:
	docker logs trust-registry-hk -f

docker-logs-gov-hk:
	docker logs hk-governance-portal -f

docker-logs-gov-macau:
	docker logs macau-governance-portal -f

docker-logs-gov-sg:
	docker logs sg-governance-portal -f

docker-logs-verifier-backend:
	docker logs nova-verifier-backend -f

docker-logs-verifier-frontend:
	docker logs nova-verifier-frontend -f

docker-stop:
	@echo "🛑 Stopping all Docker services..."
	@docker-compose -f $(COMPOSE_FILE) down
	@echo "✅ All services stopped"

docker-restart:
	@echo "🔄 Restarting all Docker services..."
	docker-compose -f $(COMPOSE_FILE) restart

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER BUILD & DEPLOY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-up:
	@echo "🚀 Starting all services..."
	docker-compose -f $(COMPOSE_FILE) up -d

docker-rebuild:
	@echo "🔨 Rebuilding and restarting all services..."
	docker-compose -f $(COMPOSE_FILE) up -d --build

docker-rebuild-hk:
	@echo "🔨 Rebuilding HK University service..."
	docker-compose -f $(COMPOSE_FILE) up -d --build hk-university-issuer

docker-rebuild-gov:
	@echo "🔨 Rebuilding all Governance Portals..."
	docker-compose -f $(COMPOSE_FILE) up -d --build hk-governance-portal macau-governance-portal sg-governance-portal

docker-rebuild-verifier:
	@echo "🔨 Rebuilding Verifier Portal..."
	docker-compose -f $(COMPOSE_FILE) up -d --build nova-verifier-backend nova-verifier-frontend

docker-restart-quick:
	@echo "⚡ Quick restart without rebuild..."
	docker-compose -f $(COMPOSE_FILE) restart

docker-restart-hk:
	@echo "⚡ Restarting HK University service..."
	docker-compose -f $(COMPOSE_FILE) restart hk-university-issuer

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SETUP & CLEANUP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

dev-up:
	@echo "Starting All-Docker + Ngrok environment..."
	bash deployment/scripts/dev-up.sh

dev-down:
	@echo "Stopping all services..."
	bash deployment/scripts/dev-down.sh

cleanup:
	@echo "🧹 Running cleanup script..."
	bash deployment/scripts/cleanup.sh
