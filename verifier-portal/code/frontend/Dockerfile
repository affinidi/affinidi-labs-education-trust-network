# Verifier Portal Frontend - Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

ENV FLUTTER_ALLOW_SUPERUSER=true

WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code (includes .env.ngrok which is declared as an asset in pubspec.yaml)
COPY . .

# Remove any local .dart_tool directory that might interfere
RUN rm -rf .dart_tool && flutter pub get

# Build web app
RUN flutter build web --release

# Production stage
FROM nginx:alpine

# Copy built web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Configure nginx to listen on port 4000
RUN sed -i "s/listen       80;/listen       4000;/g" /etc/nginx/conf.d/default.conf && \
    sed -i "s/listen  \[::]:80;/listen  [::]:4000;/g" /etc/nginx/conf.d/default.conf

EXPOSE 4000

CMD ["nginx", "-g", "daemon off;"]
