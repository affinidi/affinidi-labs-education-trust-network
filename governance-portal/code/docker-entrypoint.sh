#!/bin/sh
# =============================================================================
# Governance Portal - Docker Entrypoint
# =============================================================================
# Generates runtime-config.js from environment variables, configures nginx port,
# then starts nginx. This allows a single Flutter web build to serve multiple
# instances with different configurations.
# =============================================================================

set -e

WEB_ROOT="/usr/share/nginx/html"

# Generate runtime config JavaScript from environment variables
cat > "${WEB_ROOT}/runtime-config.js" << EOF
window.__runtimeConfig = {
  "INSTANCE_ID": "${INSTANCE_ID:-}",
  "MINISTRY_NAME": "${MINISTRY_NAME:-}",
  "SERVICE_DID": "${GOVERNANCE_DID:-${SERVICE_DID:-}}",
  "TRUST_REGISTRY_URL": "${TRUST_REGISTRY_URL:-}",
  "TRUST_REGISTRY_DID": "${TRUST_REGISTRY_DID:-}",
  "ADMIN_DID": "${ADMIN_DID:-}",
  "MEDIATOR_DID": "${MEDIATOR_DID:-}",
  "MEDIATOR_URL": "${MEDIATOR_URL:-}",
  "USER_CONFIG_PATH": "${USER_CONFIG_PATH:-assets/user_config.json}",
  "KEY_STORE_PATH": "${KEY_STORE_PATH:-}",
  "DATA_PATH": "${DATA_PATH:-}"
};
EOF

echo "[entrypoint] Generated runtime-config.js for instance: ${INSTANCE_ID:-unknown}"

# Configure nginx to listen on the correct port (default 80)
PORT="${PORT:-80}"
sed -i "s/listen       80;/listen       ${PORT};/g" /etc/nginx/conf.d/default.conf
sed -i "s/listen  \[::]:80;/listen  [::]:${PORT};/g" /etc/nginx/conf.d/default.conf

echo "[entrypoint] Nginx configured on port ${PORT}"

exec "$@"
