#!/bin/bash
# Nexigen Demo - Start All Services
# Cross-platform: works on macOS, Linux, and Windows (Git Bash / WSL)
#
# This is the single entry point to start the entire demo.
# It calls setup_ngrok.sh which handles:
#   - ngrok tunnel setup
#   - DID generation (in Docker - no Rust/Dart needed)
#   - Config generation
#   - Docker Compose startup
#
# Host requirements: ngrok, docker, docker-compose, jq, curl, git, bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "Starting Nexigen Demo (All-Docker + Ngrok)..."
echo ""

# Run the main setup script
bash "${SCRIPT_DIR}/setup_ngrok.sh"
