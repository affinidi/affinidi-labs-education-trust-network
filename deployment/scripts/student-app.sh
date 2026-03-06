#!/bin/bash
# Student Vault App - Cross-platform launcher
# Works on macOS, Linux, and Windows (Git Bash / WSL)
#
# Usage:
#   bash deployment/scripts/student-app.sh android
#   bash deployment/scripts/student-app.sh ios
#   bash deployment/scripts/student-app.sh web
#
set -e

PLATFORM="${1:-android}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR/../.." && pwd )"
APP_DIR="$ROOT_DIR/student-vault-app/code"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Student Vault App - ${PLATFORM}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found in PATH."
    echo "   Install Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Verify app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Student app code not found at: $APP_DIR"
    exit 1
fi

cd "$APP_DIR"

# Determine which env file to use (priority: .env.ngrok > .env.local-network > .env.localhost)
ENV_FILE=""
if [ -f ".env.ngrok" ]; then
    ENV_FILE=".env.ngrok"
elif [ -f ".env.local-network" ]; then
    ENV_FILE=".env.local-network"
elif [ -f ".env.localhost" ]; then
    ENV_FILE=".env.localhost"
fi

if [ -z "$ENV_FILE" ]; then
    echo "❌ No .env file found in $APP_DIR"
    echo "   Expected one of: .env.ngrok, .env.local-network, .env.localhost"
    echo "   Run 'make dev-up' or student-vault-app/setup.sh first."
    exit 1
fi

echo "📄 Using config: $ENV_FILE"

# For Android in local-network mode, remind about 10.0.2.2
if [ "$PLATFORM" = "android" ] && [ "$ENV_FILE" = ".env.local-network" ]; then
    echo "⚠️  Note: Ensure .env.local-network uses 10.0.2.2 instead of localhost for Android emulator"
fi

# Build the flutter run command
case "$PLATFORM" in
    ios)
        echo "📱 Starting on iOS Simulator..."
        flutter run --dart-define-from-file="$ENV_FILE"
        ;;
    android)
        echo "📱 Starting on Android Emulator..."
        flutter run -d android --dart-define-from-file="$ENV_FILE"
        ;;
    web)
        echo "🌐 Starting on Web (Chrome)..."
        flutter run -d chrome --dart-define-from-file="$ENV_FILE"
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        echo "   Supported: android, ios, web"
        exit 1
        ;;
esac
