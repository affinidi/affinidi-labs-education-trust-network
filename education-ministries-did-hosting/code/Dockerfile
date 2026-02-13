FROM dart:stable AS build

WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml ./

# Get dependencies (this will create pubspec.lock)
RUN dart pub get

# Copy source code
COPY . .

# Compile to executable
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copy compiled executable from build stage
COPY --from=build /app/bin/server /app/bin/server

# Create data directory
RUN mkdir -p /app/data

# Expose port
EXPOSE 3100

# Run server
CMD ["/app/bin/server"]
