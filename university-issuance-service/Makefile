.PHONY: help hk-university macau-university hk-dev macau-dev docker-up docker-down logs clean

help:
	@echo "University Issuance Service"
	@echo ""
	@echo "Available commands:"
	@echo "  make hk-university    - Start HK University (local Dart)"
	@echo "  make macau-university - Start Macau University (local Dart)"
	@echo "  make docker-up        - Start both universities via Docker"
	@echo "  make docker-down      - Stop Docker containers"
	@echo "  make logs             - Show Docker logs"
	@echo "  make clean            - Clean generated data"

hk-university: hk-dev

macau-university: macau-dev

hk-dev:
	@echo "🚀 Starting Hong Kong University Issuance Service..."
	@if [ ! -f "instances/hk-university/.env.ngrok" ]; then \
		echo "❌ Error: instances/hk-university/.env.ngrok not found"; \
		echo "   Run 'make dev-up' from project root first"; \
		exit 1; \
	fi
	@echo "📦 Installing dependencies..."
	@cd code && dart pub get > /dev/null 2>&1
	@echo "✅ Dependencies installed"
	@echo ""
	@echo "🇭🇰 Starting HK University on port 3000..."
	@echo "   Press Ctrl+C to stop"
	@echo ""
	@cd code && dart run bin/server.dart --env-file=../instances/hk-university/.env.ngrok

macau-dev:
	@echo "🚀 Starting Macau University Issuance Service..."
	@if [ ! -f "instances/macau-university/.env.ngrok" ]; then \
		echo "❌ Error: instances/macau-university/.env.ngrok not found"; \
		echo "   Run 'make dev-up' from project root first"; \
		exit 1; \
	fi
	@echo "📦 Installing dependencies..."
	@cd code && dart pub get > /dev/null 2>&1
	@echo "✅ Dependencies installed"
	@echo ""
	@echo "🇲🇴 Starting Macau University on port 3001..."
	@echo "   Press Ctrl+C to stop"
	@echo ""
	@cd code && dart run bin/server.dart --env-file=../instances/macau-university/.env.ngrok

docker-up:
	@echo "🐳 Starting both universities via Docker..."
	@cd ../deployment/docker && docker-compose -f docker-compose.localhost.yml up -d --build
	@echo "✅ Universities started"
	@echo ""
	@echo "Check logs: make logs"

docker-down:
	@echo "🛑 Stopping Docker containers..."
	@cd ../deployment/docker && docker-compose -f docker-compose.localhost.yml down
	@echo "✅ Containers stopped"

logs:
	@cd ../deployment/docker && docker-compose -f docker-compose.localhost.yml logs -f

clean:
	@echo "🧹 Cleaning generated data..."
	@rm -rf instances/hk-university/data/*
	@rm -rf instances/macau-university/data/*
	@rm -f code/.dart_tool/package_config.json
	@echo "✅ Clean complete"
