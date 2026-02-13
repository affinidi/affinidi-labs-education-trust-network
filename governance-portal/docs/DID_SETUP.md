# Governance Portal DID Setup Guide

## Overview

The governance portal uses an automated DID generation system that creates unique DID credentials for each country's ministry during setup. Each instance (Hong Kong, Macau, Singapore) gets its own DID with independent key material.

## Automated Setup

### Quick Start

From the certizen-demo directory:

```bash
# Start the complete environment (includes DID generation)
make dev-up
```

The setup process will:
1. Check for Rust/Cargo installation
2. Build the local Rust DID generation tool
3. Check if regeneration is needed (mediator change or missing files)
4. Generate 3 unique DIDs (one per ministry)
5. Create country-specific user_config files
6. Update environment files with the generated DIDs
7. Display the DIDs for Trust Registry registration

### Smart Regeneration

The system automatically detects when DID regeneration is needed:

✅ **Regenerates when:**
- Mediator URL or DID changes
- Any user_config file is missing
- Force regeneration is requested

⏭️ **Skips regeneration when:**
- All files exist and mediator config unchanged (faster re-runs)

## Country-Specific Configuration

Each ministry instance automatically loads its own DID configuration:

| Ministry | Config File | Port | Command |
|----------|-------------|------|---------|
| 🇭🇰 Hong Kong | user_config.hk.json | 8050 | `make hk` |
| 🇲🇴 Macau | user_config.macau.json | 8051 | `make macau` |
| 🇸🇬 Singapore | user_config.sg.json | 8052 | `make sg` |

## Key Material

Each generated DID includes:
- **Verification Key (key-1)**: P-256 elliptic curve
- **Encryption Key (key-2)**: secp256k1 elliptic curve
- **DID Format**: did:peer:2 with embedded keys

The DID structure `did:peer:2.VzDnaeq...EzQ3sha...` encodes:
- `VzDnaeq...` = X25519 key agreement key (multibase encoded)
- `EzQ3sha...` = Ed25519 authentication key (multibase encoded)

## Trust Registry Registration

After setup, register the generated DIDs with your Trust Registry:

```bash
# Setup output will show:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Generated Admin DIDs (Register These)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🇭🇰 Hong Kong Ministry:
  did:peer:2.VzDnae...

🇲🇴 Macau Ministry:
  did:peer:2.VzDnae...

🇸🇬 Singapore Ministry:
  did:peer:2.VzDnae...
```

**Add ALL THREE DIDs to your Trust Registry's ADMIN_DIDS configuration:**

```bash
# In your Trust Registry .env file
ADMIN_DIDS=did:peer:2.VzDnae...,did:peer:2.VzDnae...,did:peer:2.VzDnae...
```

Then restart your Trust Registry service.

## Security

### Protect Generated Files

⚠️ **IMPORTANT**: The user_config files contain private keys!

```bash
# Set restrictive permissions
chmod 600 code/assets/user_config.*.json

# Never commit to git (already in .gitignore)
```

### Git Protection

The following entries ensure private keys are never committed:

```gitignore
# In code/.gitignore:
assets/user_config.json
assets/user_config.*.json
!assets/user_config.*.json.example
```

## Regenerating DIDs

### Automatic Regeneration

DIDs are regenerated automatically when:
- Mediator configuration changes
- Any user_config file is missing

### Force Regeneration

To force regeneration (e.g., for key rotation):

```bash
# Remove existing config files
rm governance-portal/code/assets/user_config.*.json

# Optionally remove mediator cache
rm governance-portal/code/.mediator_config

# Run setup again
make cleanup
make dev-up
```

Remember to update your Trust Registry's ADMIN_DIDS list with the new DIDs.

### Change Mediator

If you need to switch mediators:

```bash
# Update your .env.ngrok with new:
# - MEDIATOR_URL
# - MEDIATOR_DID

# Run setup again - auto-detects the change
make cleanup
make dev-up
```

The script will automatically:
1. Detect mediator configuration changed
2. Remove old user_config files
3. Generate new DIDs with the new mediator
4. Update .mediator_config cache

## Troubleshooting

### Key Agreement Error

**Problem**: `Exception: No matching key agreement keys found for the mediator and the recipient.`

**Root Cause**: The user_config.json contains a did:peer:2 DID with X25519 keys encoded in the DID, but the secrets array only includes P-256 and secp256k1 private keys (no X25519 private key).

**Solution**: Regenerate the configuration:

```bash
# Remove old config files
rm governance-portal/code/assets/user_config.*.json

# Run setup to regenerate with correct keys
make cleanup
make dev-up
```

Make sure the setup script:
1. Generates did:peer:2 with X25519 + Ed25519 keys
2. Saves X25519 private key in secrets
3. Saves Ed25519 private key in secrets

### Rust Not Found

**Problem**: Setup skips DID generation because Rust is not installed.

**Solution**: Install Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

Then run setup again.

### Missing Config Files

**Problem**: App fails to find user_config.*.json files.

**Solution**: Run the setup script:

```bash
make cleanup
make dev-up
```

## Manual Generation (Advanced)

If you need to generate DIDs manually:

```bash
cd governance-portal/rust-did-generation-helper

# Build the tool
cargo build --bin generate-secrets --features="dev-tools"

# Generate a DID
./target/debug/generate-secrets \
  --mediator-url "https://apse1.mediator.affinidi.io/.well-known" \
  --mediator-did "did:web:apse1.mediator.affinidi.io:.well-known" \
  > user_config.json
```

## How It Works

### Self-Contained Tool

The `rust-did-generation-helper/` directory contains:
- Local copy of Rust trust-registry code
- Minimal code needed for `generate-secrets` binary
- No external repository dependencies

### Setup Process

1. **Checks Prerequisites**: Verifies Rust/Cargo is installed
2. **Builds Local Tool**: Compiles `generate-secrets` binary (cached after first build)
3. **Smart Regeneration Check**: Compares current mediator config with saved config
4. **Generates DIDs**: Creates 3 separate did:peer:2 DIDs with full key material
5. **Saves State**: Writes current mediator config for future change detection

### Runtime Config Selection

Each ministry instance loads its specific config:

```dart
// code/lib/core/infrastructure/config/user_config.dart
static String getDefaultPath() {
  final ministryCode = AppConfig.ministryCode;
  
  switch (ministryCode) {
    case 'hk-ministry':
      return 'assets/user_config.hk.json';
    case 'macau-ministry':
      return 'assets/user_config.macau.json';
    case 'sg-ministry':
      return 'assets/user_config.sg.json';
    default:
      return 'assets/user_config.json';
  }
}
```

The `MINISTRY_CODE` environment variable in each `.env.*.localhost` file controls which config is loaded.

## See Also

- [Governance Portal README](../README.md) - Main documentation
- [Code Architecture](../code/ARCHITECTURE.md) - System design
- [Trust Registry Setup](../../docs/trust-registry.md) - Trust registry configuration
