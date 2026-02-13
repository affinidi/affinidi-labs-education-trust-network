SHELL := /bin/bash

.PHONY: help hk macau sg gen strings clean

help:
	@echo "Governance Portal - Available Commands:"
	@echo ""
	@echo "  make hk          - Run HK Ministry Governance Portal (Port 8050)"
	@echo "  make macau       - Run Macau Ministry Governance Portal (Port 8051)"
	@echo "  make sg          - Run Singapore Ministry Governance Portal (Port 8052)"
	@echo "  make gen         - Generate code (freezed, riverpod, etc.)"
	@echo "  make strings     - Generate localized string files"
	@echo "  make clean       - Clean generated files and cache"
	@echo ""

# Run HK Ministry Governance Portal
hk:
	@echo "🏛️  Starting HK Ministry Governance Portal on port 8050..."
	@rm -f assets/user_config.json
	@cp assets/user_config.hk.json assets/user_config.json
	@if [ -f ../instances/hk-ministry/.env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run -d web-server --web-port 8050 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/hk-ministry/.env.ngrok; \
	elif [ -f ../instances/hk-ministry/.env.local-network ]; then \
		echo "   Using local network configuration"; \
		flutter run -d web-server --web-port 8050 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/hk-ministry/.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run -d web-server --web-port 8050 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/hk-ministry/.env.localhost; \
	fi

# Run Macau Ministry Governance Portal
macau:
	@echo "🏛️  Starting Macau Ministry Governance Portal on port 8051..."
	@rm -f assets/user_config.json
	@cp assets/user_config.macau.json assets/user_config.json
	@if [ -f ../instances/macau-ministry/.env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run -d web-server --web-port 8051 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/macau-ministry/.env.ngrok; \
	elif [ -f ../instances/macau-ministry/.env.local-network ]; then \
		echo "   Using local network configuration"; \
		flutter run -d web-server --web-port 8051 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/macau-ministry/.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run -d web-server --web-port 8051 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/macau-ministry/.env.localhost; \
	fi

# Run Singapore Ministry Governance Portal
sg:
	@echo "🏛️  Starting Singapore Ministry Governance Portal on port 8052..."
	@rm -f assets/user_config.json
	@cp assets/user_config.sg.json assets/user_config.json
	@if [ -f ../instances/sg-ministry/.env.ngrok ]; then \
		echo "   Using ngrok configuration"; \
		flutter run -d web-server --web-port 8052 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/sg-ministry/.env.ngrok; \
	elif [ -f ../instances/sg-ministry/.env.local-network ]; then \
		echo "   Using local network configuration"; \
		flutter run -d web-server --web-port 8052 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/sg-ministry/.env.local-network; \
	else \
		echo "   Using localhost configuration"; \
		flutter run -d web-server --web-port 8052 --web-hostname 0.0.0.0 --dart-define-from-file=../instances/sg-ministry/.env.localhost; \
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