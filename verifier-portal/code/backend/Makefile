

gen: 
	sh ../scripts/codegen.sh; \

strings: 
	sh ../scripts/generate_localized_files.sh; \

dev-up:
	@if [ ! -f .env.ngrok ]; then \
		echo "⚠️  No frontend .env file found"; \
	fi
	@echo "📦 Installing dependencies..."
	@dart pub get > /dev/null 2>&1 || true
	@echo "✅ Dependencies ready"
	@echo ""
	@echo "🔧 Starting Backend (Port 4001)..."
	@dart run lib/did_server.dart
