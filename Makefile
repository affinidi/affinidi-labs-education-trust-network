.PHONY: help student-ios student-android student-web \
        docker-ps docker-logs docker-logs-hk docker-logs-macau docker-logs-tr-hk docker-logs-edu \
        docker-logs-gov-hk docker-logs-gov-macau docker-logs-gov-sg docker-logs-verifier-backend docker-logs-verifier-frontend \
        docker-stop docker-restart docker-up docker-rebuild docker-rebuild-hk \
        docker-restart-quick docker-restart-hk dev-up dev-down cleanup

COMPOSE_DIR=deployment/docker
DC=docker compose

# Default target - show help
help:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Education Trust Network Demo - All-Docker + Ngrok"
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
	@echo "  bash deployment/scripts/student-app.sh android"
	@echo "  bash deployment/scripts/student-app.sh ios"
	@echo "  bash deployment/scripts/student-app.sh web"
	@echo ""
	@echo "MOBILE APP:"
	@echo "  make student-ios         - Student Vault App (iOS)"
	@echo "  make student-android     - Student Vault App (Android)"
	@echo "  make student-web         - Student Vault App (Web)"
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
	bash deployment/scripts/student-app.sh ios

student-android:
	@echo "📱 Starting Student Vault App (Android)..."
	bash deployment/scripts/student-app.sh android

student-web:
	@echo "🌐 Starting Student Vault App (Web)..."
	bash deployment/scripts/student-app.sh web

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER MANAGEMENT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-ps:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  📊 Education Trust Network - Service Status"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  🎓 UNIVERSITIES"
	@docker ps --filter "label=etn.group=1-universities" --format "     {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
	@echo ""
	@echo "  🏛️  EDUCATION MINISTRIES"
	@docker ps --filter "label=etn.group=2-education-ministries" --format "     {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
	@echo ""
	@echo "  📋 TRUST REGISTRIES"
	@docker ps --filter "label=etn.group=3-trust-registries" --format "     {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
	@echo ""
	@echo "  🏢 GOVERNANCE PORTALS"
	@docker ps --filter "label=etn.group=4-governance-portals" --format "     {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
	@echo ""
	@echo "  🔍 VERIFIER PORTAL"
	@docker ps --filter "label=etn.group=5-verifier-portal" --format "     {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

docker-logs:
	@echo "📋 All service logs (use Ctrl+C to stop)..."
	@docker logs -f hk-university-issuer macau-university-issuer education-ministries-did-hosting trust-registry-hk trust-registry-macau trust-registry-sg hk-governance-portal macau-governance-portal sg-governance-portal nova-verifier-backend nova-verifier-frontend 2>&1 || true

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
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml down 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml down 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-trust-registries -f compose.trust-registries.yml down 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-edu-ministries -f compose.edu-ministries.yml down 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml down 2>/dev/null || true
	@docker network rm education-trust-network 2>/dev/null || true
	@echo "✅ All services stopped"

docker-restart:
	@echo "🔄 Restarting all Docker services..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-edu-ministries -f compose.edu-ministries.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-trust-registries -f compose.trust-registries.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml restart

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER BUILD & DEPLOY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

docker-up:
	@echo "🚀 Starting all services..."
	@docker network create education-trust-network 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-edu-ministries -f compose.edu-ministries.yml up -d
	@cd $(COMPOSE_DIR) && $(DC) -p etn-trust-registries -f compose.trust-registries.yml up -d
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml up -d
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml up -d
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml up -d

docker-rebuild:
	@echo "🔨 Rebuilding and restarting all services (dependency order)..."
	@docker network create education-trust-network 2>/dev/null || true
	@cd $(COMPOSE_DIR) && $(DC) -p etn-edu-ministries -f compose.edu-ministries.yml up -d --build
	@cd $(COMPOSE_DIR) && $(DC) -p etn-trust-registries -f compose.trust-registries.yml up -d --build
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml up -d --build
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml up -d --build
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml up -d --build

docker-rebuild-hk:
	@echo "🔨 Rebuilding HK University service..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml up -d --build hk-university-issuer

docker-rebuild-gov:
	@echo "🔨 Rebuilding Governance Portals..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml up -d --build

docker-rebuild-verifier:
	@echo "🔨 Rebuilding Verifier Portal..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml up -d --build

docker-restart-quick:
	@echo "⚡ Quick restart without rebuild..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-edu-ministries -f compose.edu-ministries.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-trust-registries -f compose.trust-registries.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-governance -f compose.governance.yml restart
	@cd $(COMPOSE_DIR) && $(DC) -p etn-nova-verifier -f compose.verifier.yml restart

docker-restart-hk:
	@echo "⚡ Restarting HK University service..."
	@cd $(COMPOSE_DIR) && $(DC) -p etn-universities -f compose.universities.yml restart hk-university-issuer

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
