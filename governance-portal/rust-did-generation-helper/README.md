# Rust DID Generation Helper

Self-contained Rust tool for generating DID (Decentralized Identifier) credentials for the Governance Portal.

## Overview

This tool generates `did:peer:2` DIDs with P-256 and secp256k1 keys for secure DIDComm communication. It creates unique user configurations for each governance portal instance (Hong Kong, Macau, Singapore).

## Key Features

- ✅ **Self-contained**: All dependencies managed via Cargo.toml
- ✅ **No external repos needed**: Previously required affinidi-trust-registry-rs
- ✅ **Minimal dependencies**: Only 9 core packages (removed AWS SDK, web server, Redis, etc.)
- ✅ **Locked dependencies**: Uses Cargo.lock for reproducible builds
- ✅ **Standalone binary**: No library code needed

## Dependencies

The tool uses these minimal dependencies:

```toml
affinidi-tdk = "=0.2.7"              # Affinidi Trust Development Kit
affinidi-did-key = "0.1.4"           # DID Key generation (optional)
did-peer = "0.7.5"                   # DID Peer protocol (optional)
serde = "1.0.136"                    # Serialization
serde_json = "1.0"                   # JSON handling
tokio = "1.47" (features = ["full"]) # Async runtime
anyhow = "1.0.71"                    # Error handling
dotenvy = "0.15.7"                   # Environment variables
sha256 = "1.6"                       # Hashing
```

## Building

The tool is automatically built by `setup.sh`, but you can build manually:

```bash
cargo build --bin generate-secrets --features="dev-tools"
```

The binary will be created at: `target/debug/generate-secrets`

## Usage

### Via Setup Script (Recommended)

The tool is designed to be called by `../setup.sh`:

```bash
cd ../
./setup.sh
```

### Manual Usage

```bash
MEDIATOR_URL="https://apse1.mediator.affinidi.io" \
MEDIATOR_DID="did:web:apse1.mediator.affinidi.io:.well-known" \
cargo run --bin generate-secrets --features="dev-tools"
```

This generates `.env.test` with:
- `CLIENT_DID`: Generated did:peer:2 identifier
- `CLIENT_SECRETS`: JWK private keys for authentication and encryption

## Architecture

### What Changed

**Before**: 
- Required external affinidi-trust-registry-rs repository
- Used workspace dependencies
- Had 40+ dependencies (AWS SDK, axum web server, Redis, etc.)
- Included full trust-registry library code

**After**:
- Self-contained in governance-portal/rust-did-generation-helper
- Standalone Cargo.toml (no workspace)
- Minimal 9 core dependencies
- Removed unnecessary AWS, web server, and database code
- Binary-only (removed src/ directory)

### File Structure

```
rust-did-generation-helper/
├── Cargo.toml          # Standalone project configuration
├── Cargo.lock          # Locked dependencies (committed)
├── bin/
│   └── generate_secrets.rs  # DID generation binary
├── .gitignore          # Excludes target/ only
└── README.md           # This file
```

### Why Cargo.lock is Committed

Unlike library crates, binary projects should commit `Cargo.lock` to ensure reproducible builds. We use the lock file from affinidi-trust-registry-rs to avoid version conflicts in the affinidi-tdk ecosystem.

## Technical Details

### DID Format

Generates `did:peer:2` identifiers with:
- P-256 verification key (for signing)
- secp256k1 encryption key (for encryption)
- Mediator service endpoint
- Authentication endpoint

### Output Format

The generated `.env.test` contains:

```env
CLIENT_DID=did:peer:2.VzDnaex...
CLIENT_SECRETS="[{\"id\":\"#key-1\",\"type\":\"JsonWebKey2020\",\"privateKeyJwk\":{...}}]"
```

This is then transformed into `user_config.json`:

```json
{
  "did:peer:2.VzDnaex...": {
    "alias": "Hong Kong Ministry of Education",
    "secrets": [
      {
        "id": "#key-1",
        "type": "JsonWebKey2020",
        "privateKeyJwk": { ... }
      }
    ]
  }
}
```

## Troubleshooting

### Build Failures

If you get dependency resolution errors:

1. **Ensure Cargo.lock exists**: 
   ```bash
   # Should be committed in git
   git status Cargo.lock
   ```

2. **Clean and rebuild**:
   ```bash
   cargo clean
   cargo build --bin generate-secrets --features="dev-tools"
   ```

3. **Check Rust version**:
   ```bash
   rustc --version  # Should be 1.88.0 or compatible
   ```

### Runtime Errors

If the binary fails to run:

1. **Check environment variables**:
   ```bash
   echo $MEDIATOR_URL
   echo $MEDIATOR_DID
   ```

2. **Verify mediator is accessible**:
   ```bash
   curl https://apse1.mediator.affinidi.io
   ```

## Maintenance

### Updating Dependencies

To update to newer versions:

1. **Check for updates**:
   ```bash
   cargo outdated
   ```

2. **Update Cargo.toml** with new versions

3. **Test build**:
   ```bash
   cargo build --bin generate-secrets --features="dev-tools"
   ```

4. **Commit new Cargo.lock** if successful

### Syncing from Upstream

If you need to sync with affinidi-trust-registry-rs:

```bash
# From POCs directory
cp affinidi-trust-registry-rs/trust-registry/bin/generate_secrets.rs \
   certizen-demo/governance-portal/rust-did-generation-helper/bin/

# Don't copy Cargo.toml or src/ - we use minimal standalone versions
```

## Security Notes

⚠️ **IMPORTANT**:
- Never commit generated `.env.test` files
- Never commit `user_config.json` files with real keys
- The generated secrets contain private keys - treat them as passwords
- Always use `.gitignore` to exclude secret files

## Integration

This tool integrates with:
- **setup.sh**: Parent script that orchestrates DID generation
- **Affinidi Mediator**: Cloud service for DIDComm message routing
- **Flutter App**: Governance portal instances that use the generated configs

## Source

Originally copied from: `affinidi-trust-registry-rs/trust-registry`

Simplified to remove:
- Web server components (axum, tower-http)
- Database adapters (AWS DynamoDB, Redis)
- API layer
- Storage layer
- Full trust-registry library

Kept only the DID generation binary.

## License

Apache-2.0 (inherited from affinidi-trust-registry-rs)

## Related Documentation

- [../NEW_DID_INFO.md](../NEW_DID_INFO.md) - Overview of DID generation approach
- [../SETUP_AUTOMATION.md](../SETUP_AUTOMATION.md) - Smart regeneration logic
- [../setup.sh](../setup.sh) - Parent setup script

