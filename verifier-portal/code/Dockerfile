FROM ghcr.io/cirruslabs/flutter:stable

# Set workdir
WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code (including .env file if it exists)
COPY . .

# Remove any local .dart_tool directory that might interfere and get dependencies again
RUN rm -rf .dart_tool && flutter pub get

# Build web app
RUN flutter build web --release --web-renderer html

# Create keys directory for DID storage
RUN mkdir -p /app/keys && chmod 777 /app/keys

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i 's/\r$//' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

# Expose port 4000
EXPOSE 4000

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
