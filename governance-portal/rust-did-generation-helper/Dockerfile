# syntax=docker/dockerfile:1
# Builds the generate-secrets binary for DID generation
# Used by setup scripts to avoid requiring Rust on the host
FROM rust:1.88-bookworm AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libdbus-1-dev && rm -rf /var/lib/apt/lists/*

# Copy Cargo files first for layer caching
COPY Cargo.toml Cargo.lock ./

# Copy source
COPY bin/ bin/

# Build with cargo cache mounts — registry + git deps + compiled artifacts persist
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/app/target \
    cargo build --bin generate-secrets --features="dev-tools" --release && \
    cp target/release/generate-secrets /usr/local/bin/generate-secrets

# Runtime stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libdbus-1-3 && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/generate-secrets /usr/local/bin/generate-secrets

WORKDIR /output

ENTRYPOINT ["generate-secrets"]
