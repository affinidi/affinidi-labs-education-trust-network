

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
	@echo "🎨 Starting Frontend (Port 4000)..."
	@flutter run -d chrome --web-port=4000
