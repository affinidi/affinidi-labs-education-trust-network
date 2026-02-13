# Verifier Portal - Makefile
# Simplifies running the Nova Corp verifier

.PHONY: help dev-up clean gen strings

help:
	@echo "Verifier Portal - Available Commands:"
	@echo ""
	@echo "  make dev-up          - Start both backend and frontend in development mode"
	@echo "  make clean           - Clean generated files and cache"
	@echo "  make gen             - Run code generation"
	@echo "  make strings         - Generate localized files"
	@echo ""

# Run both backend and frontend in development mode
dev-up:
	@echo "🚀 Starting Verifier Portal (Backend + Frontend)..."
	@if [ ! -f backend/.env ] && [ ! -f backend/.env.ngrok ]; then \
		echo "⚠️  No backend .env file found"; \
	fi
	@if [ ! -f frontend/.env ] && [ ! -f frontend/.env.ngrok ]; then \
		echo "⚠️  No frontend .env file found"; \
	fi
	@echo "📦 Installing dependencies..."
	@cd backend && dart pub get > /dev/null 2>&1 || true
	@cd frontend && flutter pub get > /dev/null 2>&1 || true
	@echo "✅ Dependencies ready"
	@echo ""
	@echo "🔧 Starting Backend (Port 4001)..."
	@cd backend && dart run lib/did_server.dart &
	@BACKEND_PID=$$!; \
	echo "   Backend PID: $$BACKEND_PID"
	@sleep 2
	@echo ""
	@echo "🎨 Starting Frontend (Port 4000)..."
	@cd frontend && flutter run -d chrome --web-port=4000 || (kill $$BACKEND_PID 2>/dev/null; exit 1)

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@cd backend && flutter clean 2>/dev/null || true
	@cd frontend && flutter clean
	@rm -rf backend/keys/*.json 2>/dev/null || true
	@rm -rf backend/data/* 2>/dev/null || true
	@rm -rf backend/build/ 2>/dev/null || true
	@rm -rf backend/.dart_tool/ 2>/dev/null || true
	@rm -rf frontend/build/
	@rm -rf frontend/.dart_tool/
	@echo "✅ Clean complete"

gen: 
	@echo "🔄 Running code generation..."
	@cd frontend && sh ../scripts/codegen.sh

strings: 
	@echo "🌐 Generating localized files..."
	@sh scripts/generate_localized_files.sh

