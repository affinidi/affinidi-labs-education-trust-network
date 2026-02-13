# University Issuance Service - Makefile
# Simplifies running different university instances

.PHONY: help hk macau clean

help:
	@echo "University Issuance Service - Available Commands:"
	@echo ""
	@echo "  make hk          - Run Hong Kong University Issuer (Port 3000)"
	@echo "  make macau       - Run Macau University Issuer (Port 3001)"
	@echo "  make clean       - Clean generated files and cache"
	@echo ""

# Run HK University Issuer
hk:
	@echo "🏛️  Starting Hong Kong University Issuer on port 3000..."
	dart run bin/server.dart --env-file=.env.hk.localhost

# Run Macau University Issuer
macau:
	@echo "🏛️  Starting Macau University Issuer on port 3001..."
	dart run bin/server.dart --env-file=.env.macau.localhost

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	rm -rf .dart_tool/
	rm -rf build/
	@echo "✅ Clean complete"
