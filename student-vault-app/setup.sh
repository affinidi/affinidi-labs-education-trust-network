#!/bin/bash
#!/bin/bash
# Mobile App setup script
set -e  # Exit on error

USE_LOCALHOST=false
PLATFORM="web"  # default

if [ "$1" = "--localhost" ] || [ "$1" = "--local-network" ]; then
    USE_LOCALHOST=true
    echo "🏠 Setting up in LOCAL NETWORK mode..."

    if [ -n "$2" ]; then
        PLATFORM="$2"
        echo "   Platform: $PLATFORM"
    else
        echo "   Platform: web (default)"
        echo "   Usage: ./setup.sh --local-network [web|ios|android]"
    fi
else
    echo "🌐 Setting up with NGROK (use --local-network for local mode)..."
fi

echo "🚀 Setting up Mobile App..."
echo "📦 Using code from included repository (student-vault-app/code/)"

sed_in_place() {
    # macOS sed requires an empty backup extension; GNU sed does not.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

pick_main_env_file() {
    local candidates=(
        "../deployment/.env.ngrok"
        "../deployment/.env.local-network"
        "../deployment/.env"
    )

    for candidate in "${candidates[@]}"; do
        if [ -f "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

# Verify code directory exists
if [ ! -d "code" ]; then
    echo "❌ Error: code directory not found at student-vault-app/code/"
    echo "   The repository should include the mobile app code."
    exit 1
fi

# Verify template file exists
if [ ! -f "code/templates/.example.env" ]; then
    echo "❌ Error: Template file not found at code/templates/.example.env"
    echo "   The code directory may be incomplete."
    exit 1
fi

echo "✓ Code directory verified"

MAIN_ENV_FILE="$(pick_main_env_file || true)"
if [ -z "$MAIN_ENV_FILE" ]; then
    echo "❌ Error: No deployment env file found. Expected one of:"
    echo "   - deployment/.env.ngrok (ngrok mode)"
    echo "   - deployment/.env.local-network (local network mode)"
    echo "   - deployment/.env (legacy)"
    echo "   Run: make dev-up (ngrok) or make setup (local network)"
    exit 1
fi

echo "📝 Loading environment variables from: $MAIN_ENV_FILE"
# shellcheck source=/dev/null
source "$MAIN_ENV_FILE"

# Create .env file from template
TEMPLATE_FILE="./code/templates/.example.env"
CONFIG_DIR="./code/configurations"
TARGET_ENV_FILE="$CONFIG_DIR/.env"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Error: Template file not found at $TEMPLATE_FILE"
    exit 1
fi

echo "📄 Creating .env file from template..."
mkdir -p "$CONFIG_DIR"
cp "$TEMPLATE_FILE" "$TARGET_ENV_FILE"

# Update .env file with values from main .env
echo "🔧 Updating .env file with configuration values..."

# Determine base URL based on mode and platform
if [ "$USE_LOCALHOST" = true ]; then
    if [ "$PLATFORM" = "android" ]; then
        # Android emulator uses 10.0.2.2 to reach host machine
        HK_UNIVERSITY_URL="http://10.0.2.2:3000"
        MACAU_UNIVERSITY_URL="http://10.0.2.2:3001"
        VERIFIER_URL="http://10.0.2.2:4000"
        echo "   Using Android emulator URLs (10.0.2.2)"
    else
        # Web and iOS simulator use localhost
        HK_UNIVERSITY_URL="http://localhost:3000"
        MACAU_UNIVERSITY_URL="http://localhost:3001"
        VERIFIER_URL="http://localhost:4000"
        echo "   Using localhost URLs"
    fi
    
    HK_UNIVERSITY_DID="did:web:localhost%3A3000:hongkong-university"
    MACAU_UNIVERSITY_DID="did:web:localhost%3A3001:macau-university"
    NOVA_CORP_DID="did:web:localhost%3A4000:nova-corp"
else
    # Use ngrok URLs from main .env
    HK_UNIVERSITY_URL="${HK_UNIVERSITY_SERVICE_URL}"
    MACAU_UNIVERSITY_URL="${MACAU_UNIVERSITY_SERVICE_URL}"
    VERIFIER_URL="${NOVA_CORP_SERVICE_URL}"
    HK_UNIVERSITY_DID="${HK_UNIVERSITY_SERVICE_DID}"
    MACAU_UNIVERSITY_DID="${MACAU_UNIVERSITY_SERVICE_DID}"
    NOVA_CORP_DID="${NOVA_CORP_SERVICE_DID}"
fi

# Update APP_VERSION_NAME
if [ -n "$APP_VERSION_NAME" ]; then
    sed_in_place "s|^APP_VERSION_NAME=.*|APP_VERSION_NAME=\"$APP_VERSION_NAME\"|g" "$TARGET_ENV_FILE"
fi

# Update SERVICE URLs and DIDs
sed_in_place "s|^HK_UNIVERSITY_SERVICE_URL=.*|HK_UNIVERSITY_SERVICE_URL=\"$HK_UNIVERSITY_URL\"|g" "$TARGET_ENV_FILE"
sed_in_place "s|^HK_UNIVERSITY_SERVICE_DID=.*|HK_UNIVERSITY_SERVICE_DID=\"$HK_UNIVERSITY_DID\"|g" "$TARGET_ENV_FILE"
sed_in_place "s|^MACAU_UNIVERSITY_SERVICE_URL=.*|MACAU_UNIVERSITY_SERVICE_URL=\"$MACAU_UNIVERSITY_URL\"|g" "$TARGET_ENV_FILE"
sed_in_place "s|^MACAU_UNIVERSITY_SERVICE_DID=.*|MACAU_UNIVERSITY_SERVICE_DID=\"$MACAU_UNIVERSITY_DID\"|g" "$TARGET_ENV_FILE"
sed_in_place "s|^NOVA_CORP_SERVICE_URL=.*|NOVA_CORP_SERVICE_URL=\"$VERIFIER_URL\"|g" "$TARGET_ENV_FILE"
sed_in_place "s|^NOVA_CORP_SERVICE_DID=.*|NOVA_CORP_SERVICE_DID=\"$NOVA_CORP_DID\"|g" "$TARGET_ENV_FILE"

# Update MEDIATOR_DID (DEFAULT_MEDIATOR_DID in template)
if [ -n "$MEDIATOR_DID" ]; then
    sed_in_place "s|^DEFAULT_MEDIATOR_DID=.*|DEFAULT_MEDIATOR_DID=\"$MEDIATOR_DID\"|g" "$TARGET_ENV_FILE"
    sed_in_place "s|^MEDIATOR_DID=.*|MEDIATOR_DID=\"$MEDIATOR_DID\"|g" "$TARGET_ENV_FILE"
fi

echo "✅ Mobile App environment configuration completed!"
echo "📍 Configuration file created at: $TARGET_ENV_FILE"

if [ "$USE_LOCALHOST" = true ]; then
    echo ""
    echo "🏠 LOCALHOST MODE configured for platform: $PLATFORM"
    if [ "$PLATFORM" = "android" ]; then
        echo "   Service URLs use 10.0.2.2 (Android emulator host access)"
    else
        echo "   Service URLs use localhost"
    fi
    echo ""
    echo "   To run for a different platform:"
    echo "   - Web/iOS: ./setup.sh --localhost web"
    echo "   - Android: ./setup.sh --localhost android"
fi

# Skip organizations.dart update for now - will be handled separately if needed

# Copy Firebase config files if they exist
if [ -f "configs/google-services.json" ]; then
    cp configs/google-services.json ./code/android/app/google-services.json
    echo "✅ Copied google-services.json"
else
    echo "⚠️  google-services.json not found, skipping..."
fi

if [ -f "configs/GoogleService-Info.plist" ]; then
    cp configs/GoogleService-Info.plist ./code/ios/Runner/GoogleService-Info.plist
    echo "✅ Copied GoogleService-Info.plist"
else
    echo "⚠️  GoogleService-Info.plist not found, skipping..."
fi

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
cd code || {
    echo "⚠️  Could not change to code directory, skipping dependency installation"
    echo "✅ Mobile App setup completed successfully!"
    exit 0
}

if command -v flutter >/dev/null 2>&1; then
    if flutter pub get >/dev/null 2>&1; then
        echo "✅ Dependencies installed successfully"
    else
        echo "⚠️  Failed to install dependencies, but continuing..."
    fi
else
    echo "⚠️  Flutter not found in PATH, skipping dependency installation"
fi
cd ..

echo "✅ Mobile App setup completed successfully!"