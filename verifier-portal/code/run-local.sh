#!/bin/bash

# NovaCorp Verifier Portal - Startup Script
# Properly starts the Flask development server on port 4000

set -e

cd "$(dirname "$0")"

echo "🏢 NovaCorp Verifier Portal - Startup"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found"
    echo "   Please run this script from verifier-portal/code directory"
    exit 1
fi

echo "✅ pubspec.yaml found"
echo ""

# Clean up any existing processes
echo "🧹 Cleaning up any existing Flutter processes..."
pkill -f "flutter run" 2>/dev/null || true
sleep 2

# Ensure dependencies are up to date
echo "📦 Ensuring dependencies are up to date..."
flutter pub get > /dev/null 2>&1 || {
    echo "❌ Failed to get dependencies"
    exit 1
}
echo "✅ Dependencies ready"
echo ""

# Start the app
echo "🚀 Starting app on http://localhost:4000"
echo "   (Press Ctrl+C to stop)"
echo ""

flutter run -d web-server --web-port 4000 --web-hostname 127.0.0.1

