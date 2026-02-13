#!/bin/bash
# Verification script for environment file restructuring
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Verifying Environment File Restructuring"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"

PASS=0
FAIL=0

check_file_contains() {
    local file=$1
    local pattern=$2
    local description=$3
    
    if [ ! -f "$file" ]; then
        echo "❌ FAIL: File not found - $file"
        ((FAIL++))
        return 1
    fi
    
    if grep -q "$pattern" "$file"; then
        echo "✅ PASS: $description"
        ((PASS++))
        return 0
    else
        echo "❌ FAIL: $description"
        echo "   Expected pattern: $pattern"
        echo "   In file: $file"
        ((FAIL++))
        return 1
    fi
}

check_file_not_contains() {
    local file=$1
    local pattern=$2
    local description=$3
    
    if [ ! -f "$file" ]; then
        echo "❌ FAIL: File not found - $file"
        ((FAIL++))
        return 1
    fi
    
    if ! grep -q "$pattern" "$file"; then
        echo "✅ PASS: $description"
        ((PASS++))
        return 0
    else
        echo "❌ FAIL: $description"
        echo "   Should NOT contain: $pattern"
        echo "   In file: $file"
        ((FAIL++))
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Checking setup_localhost.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_localhost.sh" \
    'deployment/.env.local-network' \
    "setup_localhost.sh uses .env.local-network"

check_file_not_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_localhost.sh" \
    'deployment/.env"' \
    "setup_localhost.sh doesn't use plain .env"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Checking setup_ngrok.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_ngrok.sh" \
    'deployment/.env.ngrok' \
    "setup_ngrok.sh uses .env.ngrok"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_ngrok.sh" \
    'STEP 4: START NGROK TUNNELS' \
    "setup_ngrok.sh starts tunnels at Step 4"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_ngrok.sh" \
    'STEP 5: CAPTURE NGROK DOMAINS' \
    "setup_ngrok.sh captures domains at Step 5"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_ngrok.sh" \
    'STEP 6: CREATE .env.ngrok WITH CAPTURED DOMAINS' \
    "setup_ngrok.sh creates .env.ngrok at Step 6"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/setup_ngrok.sh" \
    'STEP 7: GENERATE ADMIN DIDs' \
    "setup_ngrok.sh generates Admin DIDs at Step 7 (after domains)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Checking cleanup.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/cleanup.sh" \
    'deployment/.env.ngrok' \
    "cleanup.sh handles .env.ngrok"

check_file_contains \
    "${PROJECT_ROOT}/deployment/scripts/cleanup.sh" \
    'deployment/.env.local-network' \
    "cleanup.sh handles .env.local-network"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Checking governance-portal makefile"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/governance-portal/code/makefile" \
    '.env.hk.ngrok' \
    "governance makefile checks for .env.hk.ngrok"

check_file_contains \
    "${PROJECT_ROOT}/governance-portal/code/makefile" \
    '.env.hk.local-network' \
    "governance makefile checks for .env.hk.local-network"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Checking verifier-portal makefile"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/verifier-portal/code/makefile" \
    '.env.ngrok' \
    "verifier makefile checks for .env.ngrok"

check_file_contains \
    "${PROJECT_ROOT}/verifier-portal/code/makefile" \
    '.env.local-network' \
    "verifier makefile checks for .env.local-network"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Checking student-vault-app makefile"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file_contains \
    "${PROJECT_ROOT}/student-vault-app/code/makefile" \
    '.env.ngrok' \
    "student-vault-app makefile checks for .env.ngrok"

check_file_contains \
    "${PROJECT_ROOT}/student-vault-app/code/makefile" \
    '.env.local-network' \
    "student-vault-app makefile checks for .env.local-network"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Verification Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ PASSED: $PASS tests"
echo "❌ FAILED: $FAIL tests"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "═══════════════════════════════════════════════════════════"
    echo "✅ ALL CHECKS PASSED!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Environment file restructuring is complete and verified."
    echo ""
    echo "Next steps:"
    echo "  1. Test local network: make cleanup && make setup"
    echo "  2. Test ngrok: make cleanup && make dev-up"
    echo "  3. Test app launches: make student-ios"
    echo ""
    exit 0
else
    echo "═══════════════════════════════════════════════════════════"
    echo "❌ SOME CHECKS FAILED"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Please review the failed checks above and fix the issues."
    echo ""
    exit 1
fi
