.PHONY: help dev-up dev-down logs clean

help:
	@echo "Education Ministries DID Hosting Service"
	@echo ""
	@echo "Available commands:"
	@echo "  make dev-up      - Start the service (local Dart)"
	@echo "  make dev-down    - Stop the service"
	@echo "  make docker-up   - Start via Docker"
	@echo "  make docker-down - Stop Docker container"
	@echo "  make logs        - Show service logs"
	@echo "  make clean       - Clean generated data"

dev-up:
	@echo "🚀 Starting Education Ministries DID Hosting Service..."
	@if [ ! -f "instance/.env.ngrok" ]; then \
		echo "❌ Error: instance/.env.ngrok not found"; \
		echo "   Run 'make dev-up' from project root first"; \
		exit 1; \
	fi
	@echo "📦 Installing dependencies..."
	@cd code && dart pub get > /dev/null 2>&1
	@echo "✅ Dependencies installed"
	@echo ""
	@echo "🌐 Starting server on port 3100..."
	@echo "   Press Ctrl+C to stop"
	@echo ""
	@cd code && dart run bin/server.dart --env-file=../instance/.env.ngrok

dev-down:
	@echo "🛑 Stopping Education Ministries service..."
	@pkill -f "dart run bin/server.dart" || true
	@echo "✅ Service stopped"

docker-up:
	@echo "🐳 Starting Education Ministries service via Docker..."
	@docker-compose up -d --build
	@echo "✅ Service started"
	@echo ""
	@echo "Check logs: make logs"

docker-down:
	@echo "🛑 Stopping Docker container..."
	@docker-compose down
	@echo "✅ Container stopped"

logs:
	@docker-compose logs -f education-ministries

clean:
	@echo "🧹 Cleaning generated data..."
	@rm -rf instance/data/*
	@rm -f code/.dart_tool/package_config.json
	@echo "✅ Clean complete"
