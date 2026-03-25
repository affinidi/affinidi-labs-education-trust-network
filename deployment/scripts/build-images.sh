#!/bin/bash
# Education Trust Network - Smart Docker Image Builder
#
# Builds Docker images with BuildKit caching and GitHub Actions artifacts
# for sharing pre-built images across the team. No 30-minute builds for new developers.
#
# Image resolution order (smart build):
#   1. Image already in local Docker? → Use it (instant)
#   2. Image in GHCR? → docker pull (fast, native Docker registry)
#   3. Image in CI artifacts? → Download + load (slower, via gh CLI)
#   4. Local .docker-cache/ tarball? → Load it (seconds)
#   5. None of the above? → Build from source (minutes, with BuildKit caching)
#
# Usage:
#   ./build-images.sh             # Smart build (download/load/build as needed)
#   ./build-images.sh --force     # Force rebuild all images from source
#   ./build-images.sh --pull      # Download all images from latest CI build
#   ./build-images.sh --save      # Save images to local .docker-cache/ tarballs
#   ./build-images.sh --load      # Load images from local .docker-cache/ tarballs
#   ./build-images.sh --status    # Show image status (Docker / CI / local cache)
#   ./build-images.sh --services  # Smart build service images only
#   ./build-images.sh --tools     # Smart build tool images only
#   ./build-images.sh --tag main  # Pull images tagged :main instead of :latest
#
# CI artifacts are produced by the "Build & Publish Docker Images" workflow.
# Public repo = gh CLI can download artifacts without push access.
# Artifacts auto-expire after the retention period set in the workflow.

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"
CACHE_DIR="${PROJECT_ROOT}/.docker-cache"

# Ensure BuildKit is enabled (required for --mount=type=cache in Dockerfiles)
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# ──────────────────────────────────────────────
# GitHub Configuration
# ──────────────────────────────────────────────
GH_REPO="affinidi/affinidi-labs-education-trust-network"
GH_REGISTRY="ghcr.io/affinidi"
CI_WORKFLOW="docker-publish.yml"

# ──────────────────────────────────────────────
# Image Definitions
# ──────────────────────────────────────────────
# Format: "local_tag|asset_name|build_context|dockerfile"
# - local_tag: used by docker-compose and local Docker
# - asset_name: tarball filename in GitHub Release (without .tar.gz)

SERVICE_IMAGES=(
    "etn-university-issuer:latest|etn-university-issuer|${PROJECT_ROOT}/university-issuance-service/code|Dockerfile"
    "etn-edu-ministries:latest|etn-edu-ministries|${PROJECT_ROOT}/education-ministries-did-hosting/code|Dockerfile"
    "trust-registry:local|etn-trust-registry|${PROJECT_ROOT}/trust-registry|Dockerfile.trust-registry"
    "etn-governance-portal:latest|etn-governance-portal|${PROJECT_ROOT}/governance-portal/code|Dockerfile"
    "etn-verifier-backend:latest|etn-verifier-backend|${PROJECT_ROOT}/verifier-portal/code/backend|Dockerfile"
    "etn-verifier-frontend:latest|etn-verifier-frontend|${PROJECT_ROOT}/verifier-portal/code/frontend|Dockerfile"
)

TOOL_IMAGES=(
    "etn-did-gen:latest|etn-did-gen|${PROJECT_ROOT}/governance-portal/rust-did-generation-helper|Dockerfile"
    "tr-did-gen:latest|etn-tr-did-gen|${PROJECT_ROOT}/trust-registry/affinidi-trust-registry-rs|${PROJECT_ROOT}/trust-registry/Dockerfile.did-gen"
)

mkdir -p "$CACHE_DIR"

# ──────────────────────────────────────────────
# Helper Functions
# ──────────────────────────────────────────────

image_exists() {
    docker image inspect "$1" >/dev/null 2>&1
}

tarball_path() {
    local asset_name=$1
    echo "${CACHE_DIR}/${asset_name}.tar.gz"
}

save_image() {
    local image=$1
    local asset_name=$2
    local tarball
    tarball=$(tarball_path "$asset_name")
    echo "    💾 Saving $image → $(basename "$tarball")"
    docker save "$image" | gzip > "$tarball"
}

load_image() {
    local image=$1
    local asset_name=$2
    local tarball
    tarball=$(tarball_path "$asset_name")
    if [ -f "$tarball" ]; then
        echo "    📦 Loading $image from local cache..."
        gunzip -c "$tarball" | docker load -q >/dev/null 2>&1
        return 0
    fi
    return 1
}

# Pull image from GHCR and retag to local name
pull_ghcr_image() {
    local local_tag=$1
    local asset_name=$2
    local ghcr_image="${GH_REGISTRY}/${asset_name}:${GHCR_TAG}"

    echo "    ☁️  Pulling ${ghcr_image}..."
    if docker pull "$ghcr_image"; then
        docker tag "$ghcr_image" "$local_tag"
        echo "  ✅ $local_tag — pulled from GHCR (:${GHCR_TAG})"
        return 0
    fi
    return 1
}

# Resolve the latest successful CI run ID (cached for the session)
_CI_RUN_ID=""
get_ci_run_id() {
    if [ -n "$_CI_RUN_ID" ]; then
        echo "$_CI_RUN_ID"
        return 0
    fi
    _CI_RUN_ID=$(gh run list --repo "$GH_REPO" --workflow "$CI_WORKFLOW" \
        --status success --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)
    if [ -z "$_CI_RUN_ID" ] || [ "$_CI_RUN_ID" = "null" ]; then
        _CI_RUN_ID=""
        return 1
    fi
    echo "$_CI_RUN_ID"
}

# Download a single image tarball from CI artifacts and docker load it
download_ci_image() {
    local local_tag=$1
    local asset_name=$2
    local tarball
    tarball=$(tarball_path "$asset_name")

    local run_id
    run_id=$(get_ci_run_id) || return 1

    echo "    ☁️  Downloading ${asset_name} from CI run #${run_id}..."

    # Download with explicit run ID (avoids slow scan of all runs)
    if gh run download "$run_id" \
        --repo "$GH_REPO" \
        --name "$asset_name" \
        --dir "${CACHE_DIR}/${asset_name}"; then
        # gh run download extracts into a directory; find the tarball
        local downloaded="${CACHE_DIR}/${asset_name}/${asset_name}.tar.gz"
        if [ -f "$downloaded" ]; then
            mv "$downloaded" "$tarball"
            rm -rf "${CACHE_DIR:?}/${asset_name:?}"
            echo "    📦 Loading into Docker..."
            gunzip -c "$tarball" | docker load -q >/dev/null 2>&1
            return 0
        fi
        rm -rf "${CACHE_DIR:?}/${asset_name:?}"
    fi
    return 1
}

build_image() {
    local image=$1
    local context=$2
    local dockerfile=$3

    echo "    🔨 Building $image ..."

    if [ ! -d "$context" ]; then
        echo "    ⚠️  Build context not found: $context (skipping)"
        return 1
    fi

    if [[ "$dockerfile" == /* ]]; then
        docker build -t "$image" -f "$dockerfile" "$context" --quiet
    else
        docker build -t "$image" -f "${context}/${dockerfile}" "$context" --quiet
    fi
}

# Smart process: Docker → CI artifact → local tarball → build
process_image() {
    local entry=$1
    local force=$2
    IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"

    if [ "$force" != "true" ] && image_exists "$local_tag"; then
        echo "  ✅ $local_tag — already exists"
        return 0
    fi

    # Try pulling from GHCR (fastest — native Docker pull)
    if [ "$force" != "true" ] && pull_ghcr_image "$local_tag" "$asset_name"; then
        return 0
    fi

    # Try downloading from CI artifacts (fallback)
    if [ "$force" != "true" ] && command -v gh >/dev/null 2>&1; then
        echo "    ☁️  Trying CI artifact: ${asset_name} ..."
        if download_ci_image "$local_tag" "$asset_name"; then
            echo "  ✅ $local_tag — downloaded from CI"
            return 0
        fi
    fi

    # Try local tarball cache
    if [ "$force" != "true" ] && load_image "$local_tag" "$asset_name" 2>/dev/null; then
        echo "  ✅ $local_tag — loaded from local cache"
        return 0
    fi

    # Build from source
    if build_image "$local_tag" "$context" "$dockerfile"; then
        echo "  ✅ $local_tag — built from source"
        return 0
    else
        echo "  ❌ $local_tag — build failed"
        return 1
    fi
}

# ──────────────────────────────────────────────
# Command Dispatch
# ──────────────────────────────────────────────

# Parse --tag option from any position
GHCR_TAG="latest"
ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --tag)
            GHCR_TAG="${2:-latest}"
            shift 2
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done
MODE="${ARGS[0]:-smart}"

case "$MODE" in
    --status)
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Docker Image Status"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        # Check latest CI run
        CI_STATUS="❌ no successful run"
        CI_RUN_URL=""
        if command -v gh >/dev/null 2>&1; then
            CI_INFO=$(gh run list --repo "$GH_REPO" --workflow "$CI_WORKFLOW" --status success --limit 1 --json databaseId,updatedAt,headBranch 2>/dev/null || true)
            if [ -n "$CI_INFO" ] && [ "$CI_INFO" != "[]" ]; then
                CI_DATE=$(echo "$CI_INFO" | grep -o '"updatedAt":"[^"]*"' | head -1 | cut -d'"' -f4)
                CI_ID=$(echo "$CI_INFO" | grep -o '"databaseId":[0-9]*' | head -1 | cut -d: -f2)
                CI_STATUS="✅ run #${CI_ID} (${CI_DATE})"
                CI_RUN_URL="https://github.com/${GH_REPO}/actions/runs/${CI_ID}"
            fi
        fi
        echo "  CI Workflow: ${CI_WORKFLOW}"
        echo "  Latest build: ${CI_STATUS}"
        [ -n "$CI_RUN_URL" ] && echo "  URL: ${CI_RUN_URL}"
        echo ""

        echo "  SERVICE IMAGES:"
        for entry in "${SERVICE_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            docker_status="❌ missing"
            image_exists "$local_tag" && docker_status="✅ exists"
            cache_status="❌"
            tarball=$(tarball_path "$asset_name")
            [ -f "$tarball" ] && cache_status="📦 $(du -h "$tarball" | cut -f1)"
            printf "    %-35s Docker=%-12s Local=%s\n" "$local_tag" "$docker_status" "$cache_status"
        done
        echo ""
        echo "  TOOL IMAGES:"
        for entry in "${TOOL_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            docker_status="❌ missing"
            image_exists "$local_tag" && docker_status="✅ exists"
            cache_status="❌"
            tarball=$(tarball_path "$asset_name")
            [ -f "$tarball" ] && cache_status="📦 $(du -h "$tarball" | cut -f1)"
            printf "    %-35s Docker=%-12s Local=%s\n" "$local_tag" "$docker_status" "$cache_status"
        done
        echo ""
        exit 0
        ;;

    --push)
        echo ""
        echo "💾 Saving all Docker images to local cache + uploading as CI artifacts..."
        echo ""
        echo "   Note: Pre-built images are normally produced by CI on merge to main."
        echo "   This command saves local images and triggers a CI build."
        echo ""

        if ! command -v gh >/dev/null 2>&1; then
            echo "  ❌ GitHub CLI (gh) is required. Install: brew install gh && gh auth login"
            exit 1
        fi

        # Save all images locally first
        for entry in "${SERVICE_IMAGES[@]}" "${TOOL_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            if image_exists "$local_tag"; then
                save_image "$local_tag" "$asset_name"
            else
                echo "    ⚠️  $local_tag not found in Docker — skipping"
            fi
        done
        echo ""
        echo "✅ Images saved to: $CACHE_DIR"
        echo "   Total cache size: $(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)"
        echo ""
        echo "   To publish images for the team, trigger CI:"
        echo "     gh workflow run ${CI_WORKFLOW} --repo ${GH_REPO}"
        echo ""
        echo "   Or push your changes to main — CI runs automatically."
        echo ""
        exit 0
        ;;

    --pull)
        echo ""
        echo "☁️  Downloading Docker images from GHCR (tag: ${GHCR_TAG})..."
        echo "   Registry: ${GH_REGISTRY}"
        echo ""

        pulled=0
        skipped=0
        failed=0
        for entry in "${SERVICE_IMAGES[@]}" "${TOOL_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            if image_exists "$local_tag"; then
                echo "  ✅ $local_tag — already in Docker"
                ((skipped++))
            elif pull_ghcr_image "$local_tag" "$asset_name"; then
                ((pulled++))
            else
                echo "    ☁️  Trying CI artifact fallback for ${asset_name}..."
                if command -v gh >/dev/null 2>&1 && download_ci_image "$local_tag" "$asset_name"; then
                    echo "  ✅ $local_tag — loaded from CI artifact"
                    ((pulled++))
                else
                    echo "  ⚠️  $local_tag — not available (build needed)"
                    ((failed++))
                fi
            fi
        done
        echo ""
        echo "✅ Done: $pulled downloaded, $skipped skipped, $failed unavailable"
        echo ""
        exit 0
        ;;

    --save)
        echo ""
        echo "💾 Saving all Docker images to local cache..."
        echo ""
        for entry in "${SERVICE_IMAGES[@]}" "${TOOL_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            if image_exists "$local_tag"; then
                save_image "$local_tag" "$asset_name"
            else
                echo "    ⚠️  $local_tag not found in Docker — skipping"
            fi
        done
        echo ""
        echo "✅ Images saved to: $CACHE_DIR"
        echo "   Total cache size: $(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)"
        echo ""
        exit 0
        ;;

    --load)
        echo ""
        echo "📦 Loading Docker images from local cache..."
        echo ""
        loaded=0
        skipped=0
        missing=0
        for entry in "${SERVICE_IMAGES[@]}" "${TOOL_IMAGES[@]}"; do
            IFS="|" read -r local_tag asset_name context dockerfile <<< "$entry"
            if image_exists "$local_tag"; then
                echo "  ✅ $local_tag — already in Docker"
                ((skipped++))
            elif load_image "$local_tag" "$asset_name"; then
                echo "  ✅ $local_tag — loaded"
                ((loaded++))
            else
                echo "  ⚠️  $local_tag — no local cache tarball"
                ((missing++))
            fi
        done
        echo ""
        echo "✅ Done: $loaded loaded, $skipped already existed, $missing not cached"
        echo ""
        exit 0
        ;;

    --force)
        echo ""
        echo "🔨 Force rebuilding ALL Docker images..."
        echo "(BuildKit cache mounts still speed up dependency resolution)"
        echo ""
        FORCE=true
        ;;

    --tools)
        echo ""
        echo "🔧 Building tool images only..."
        echo ""
        for entry in "${TOOL_IMAGES[@]}"; do
            process_image "$entry" "false" || true
        done
        echo ""
        exit 0
        ;;

    --services)
        echo ""
        echo "📦 Building service images only..."
        echo ""
        for entry in "${SERVICE_IMAGES[@]}"; do
            process_image "$entry" "false" || true
        done
        echo ""
        exit 0
        ;;

    *)
        echo ""
        echo "⚡ Smart build: checking for existing images..."
        echo "(Tries: Docker → CI artifacts → local cache → build from source)"
        echo ""
        FORCE=false
        ;;
esac

# ──────────────────────────────────────────────
# Build All Images
# ──────────────────────────────────────────────

echo "  SERVICE IMAGES:"
for entry in "${SERVICE_IMAGES[@]}"; do
    process_image "$entry" "${FORCE}" || true
done

echo ""
echo "  TOOL IMAGES:"
for entry in "${TOOL_IMAGES[@]}"; do
    process_image "$entry" "${FORCE}" || true
done

echo ""
echo "✅ Image preparation complete"
echo ""
