#!/bin/bash
# Launch Chrome with CORS disabled for local development
# WARNING: Only use this for development! Never browse other sites with this Chrome instance!

set -e

echo "🚨 WARNING: Launching Chrome with web security disabled!"
echo "   Only use this for local development testing."
echo "   DO NOT browse other websites in this window!"
echo ""

# Determine the OS and launch Chrome accordingly
case "$(uname -s)" in
    Darwin*)
        # macOS
        echo "📱 Platform: macOS"
        CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
        
        if [ ! -f "$CHROME_PATH" ]; then
            echo "❌ Error: Chrome not found at $CHROME_PATH"
            echo "   Please install Google Chrome or update the path in this script."
            exit 1
        fi
        
        echo "🚀 Launching Chrome..."
        open -n -a "$CHROME_PATH" --args \
            --user-data-dir="/tmp/chrome_dev_cors_disabled" \
            --disable-web-security \
            --disable-site-isolation-trials \
            --disable-features=IsolateOrigins,site-per-process
        ;;
        
    Linux*)
        # Linux
        echo "📱 Platform: Linux"
        
        if command -v google-chrome &> /dev/null; then
            echo "🚀 Launching Chrome..."
            google-chrome \
                --user-data-dir="/tmp/chrome_dev_cors_disabled" \
                --disable-web-security \
                --disable-site-isolation-trials \
                --disable-features=IsolateOrigins,site-per-process \
                &
        elif command -v chromium &> /dev/null; then
            echo "🚀 Launching Chromium..."
            chromium \
                --user-data-dir="/tmp/chrome_dev_cors_disabled" \
                --disable-web-security \
                --disable-site-isolation-trials \
                --disable-features=IsolateOrigins,site-per-process \
                &
        else
            echo "❌ Error: Chrome or Chromium not found"
            echo "   Please install Google Chrome or Chromium."
            exit 1
        fi
        ;;
        
    MINGW*|MSYS*|CYGWIN*)
        # Windows
        echo "📱 Platform: Windows"
        echo "⚠️  Please run Chrome manually with:"
        echo '   chrome.exe --user-data-dir="C:\tmp\chrome_dev_cors_disabled" --disable-web-security'
        exit 0
        ;;
        
    *)
        echo "❌ Error: Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac

echo ""
echo "✅ Chrome launched with CORS disabled"
echo ""
echo "📝 Next steps:"
echo "   1. Wait for Chrome to fully open"
echo "   2. Navigate to your ngrok URL (e.g., https://f4e2856a7a42.ngrok-free.app)"
echo "   3. Test your application"
echo ""
echo "🧹 Cleanup: Close this Chrome window when done testing"
echo "   The temporary profile is at /tmp/chrome_dev_cors_disabled"
