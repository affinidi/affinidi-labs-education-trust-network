#!/bin/bash
# Education Ministries DID Hosting - Setup Script
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "========================================="
echo "Education Ministries DID Hosting - Setup"
echo "========================================="
echo ""

# Check if .env.ngrok exists
if [ ! -f "instance/.env.ngrok" ]; then
    echo "❌ Error: instance/.env.ngrok not found"
    echo "   This file should be created by the main setup_ngrok.sh script"
    exit 1
fi

echo "✓ Configuration file found: instance/.env.ngrok"

# Create data directory
mkdir -p instance/data
echo "✓ Data directory created"

# Install Dart dependencies
echo ""
echo "Installing Dart dependencies..."
cd code
dart pub get > /dev/null 2>&1
echo "✓ Dependencies installed"

cd "$SCRIPT_DIR"
echo ""
echo "✅ Education Ministries service setup complete"
echo ""
