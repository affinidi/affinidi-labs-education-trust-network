SHELL := /bin/bash

.PHONY: help ios android web gen strings clean

help:
	@echo "Student Vault App - Available Commands:"
	@echo ""
	@echo "  make ios         - Run on iOS Simulator"
	@echo "  make android     - Run on Android Emulator"
	@echo "  make web         - Run on Web (Chrome)"
	@echo "  make gen         - Generate code (freezed, riverpod, etc.)"
	@echo "  make strings     - Generate localized string files"
	@echo "  make clean       - Clean generated files and cache"
	@echo ""
	@echo "Note: For Android, ensure .env.local-network uses 10.0.2.2 instead of localhost"

# Run on iOS Simulator
ios:
	@echo "📱 Starting Student Vault App on iOS Simulator..."
	@if [ -f .env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run --dart-define-from-file=.env.ngrok; \
	elif [ -f .env.local-network ]; then \
		echo "   Using local network configuration"; \
		flutter run --dart-define-from-file=.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run --dart-define-from-file=.env.localhost; \
	fi

# Run on Android Emulator
android:
	@echo "📱 Starting Student Vault App on Android Emulator..."
	@if [ -f .env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run -d android --dart-define-from-file=.env.ngrok; \
	elif [ -f .env.local-network ]; then \
		echo "   Using local network configuration (10.0.2.2)"; \
		flutter run -d android --dart-define-from-file=.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run -d android --dart-define-from-file=.env.localhost; \
	fi

# Run on Web
web:
	@echo "🌐 Starting Student Vault App on Web (Chrome)..."
	@if [ -f .env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run -d chrome --dart-define-from-file=.env.ngrok; \
	elif [ -f .env.local-network ]; then \
		echo "   Using local network configuration"; \
		flutter run -d chrome --dart-define-from-file=.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run -d chrome --dart-define-from-file=.env.localhost; \
	fi

gen: 
	sh scripts/codegen.sh; \

strings: 
	sh scripts/generate_localized_files.sh; \

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	flutter clean
	@echo "✅ Clean complete"