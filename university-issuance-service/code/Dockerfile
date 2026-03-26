# syntax=docker/dockerfile:1
# Use official Dart SDK image
FROM dart:stable AS build

# Set workdir
WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies — cache mount persists pub packages across builds
RUN --mount=type=cache,target=/root/.pub-cache \
    dart pub get

# Copy source code (exclude .pub-cache and other build artifacts)
COPY . .

# Re-resolve deps for full source tree, then compile
# Cache mount ensures packages are already downloaded — only resolution + compile runs
RUN --mount=type=cache,target=/root/.pub-cache \
    rm -rf .dart_tool && dart pub get && \
    dart compile exe bin/server.dart -o bin/server

# Runtime image - use debian slim instead of scratch for user management
FROM debian:stable-slim

# Create a non-root user
RUN groupadd -r dartapp && useradd -r -g dartapp dartapp

# Copy runtime and app from build stage
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/public /app/public

# Create app directory and set ownership
RUN mkdir -p /app && chown -R dartapp:dartapp /app

# Switch to non-root user
USER dartapp
WORKDIR /app

# Expose port (will be set by env var at runtime)
EXPOSE 3000
EXPOSE 3001
ENTRYPOINT ["/app/bin/server"]
