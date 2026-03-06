#!/bin/bash
# Nexigen Demo - Stop All Services
# Cross-platform: works on macOS, Linux, and Windows (Git Bash / WSL)
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"
COMPOSE_FILE="${PROJECT_ROOT}/deployment/docker/docker-compose.localhost.yml"

# Docker compose v2 detection
if docker compose version >/dev/null 2>&1; then
    DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    DC="docker-compose"
else
    echo "Neither 'docker compose' nor 'docker-compose' found"
    exit 1
fi

echo ""
echo "Stopping Nexigen Demo..."
echo ""

# Stop Docker containers
if [ -f "$COMPOSE_FILE" ]; then
    echo "Stopping Docker containers..."
    cd "${PROJECT_ROOT}/deployment/docker"
    $DC -f docker-compose.localhost.yml down 2>/dev/null || true
    echo "✓ Docker containers stopped"
fi

# Stop ngrok
echo "Stopping ngrok..."
if [ -f "${PROJECT_ROOT}/deployment/ngrok.pid" ]; then
    NGROK_PID=$(cat "${PROJECT_ROOT}/deployment/ngrok.pid")
    kill "$NGROK_PID" 2>/dev/null || true
    rm -f "${PROJECT_ROOT}/deployment/ngrok.pid"
fi
# Fallback: try pkill if available
if command -v pkill >/dev/null 2>&1; then
    pkill -f ngrok 2>/dev/null || true
fi
echo "✓ ngrok stopped"

echo ""
echo "All services stopped."
echo "Run 'bash deployment/scripts/dev-up.sh' to restart."
echo ""
