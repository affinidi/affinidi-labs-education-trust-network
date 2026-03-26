# syntax=docker/dockerfile:1
# Verifier Portal Backend - Dart DID/API Server
FROM dart:stable AS build

WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.* ./

# Get dependencies — cache mount persists pub packages across builds
RUN --mount=type=cache,target=/root/.pub-cache \
    dart pub get

# Copy source code
COPY . .

# Re-resolve deps and compile — cache mount makes pub get instant
RUN --mount=type=cache,target=/root/.pub-cache \
    rm -rf .dart_tool && dart pub get && \
    mkdir -p bin && dart compile exe lib/did_server.dart -o bin/did_server

# Runtime stage
FROM debian:stable-slim

# Create non-root user
RUN groupadd -r dartapp && useradd -r -g dartapp dartapp

# Copy compiled binary
COPY --from=build /app/bin/did_server /app/bin/did_server

# Copy entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i 's/\r$//' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

# Create data and keys directories
RUN mkdir -p /app/data /app/keys && chown -R dartapp:dartapp /app

USER dartapp
WORKDIR /app

EXPOSE 4001

ENTRYPOINT ["/docker-entrypoint.sh"]
