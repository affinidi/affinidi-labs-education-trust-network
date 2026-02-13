#!/bin/bash

# Governance Portal Setup Script

set -e

echo "🚀 Setting up Governance Portal..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter SDK first."
    exit 1
fi

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

echo "✅ Governance Portal setup complete!"
echo ""
echo "To run locally:"
echo "  flutter run -d chrome"
echo ""
echo "To build for production:"
echo "  flutter build web --release"
