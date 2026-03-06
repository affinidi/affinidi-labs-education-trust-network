FROM ghcr.io/cirruslabs/flutter:stable AS build

ENV FLUTTER_ALLOW_SUPERUSER=true

ARG INSTANCE_ID=hk
ARG INSTANCE_PORT=8050

WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Copy instance-specific user_config as the active one
RUN if [ -f "assets/user_config.${INSTANCE_ID}.json" ]; then \
      cp assets/user_config.${INSTANCE_ID}.json assets/user_config.json; \
    fi

# Build web app with instance configuration
# .env.docker.${INSTANCE_ID} is created by the setup script before docker build
RUN if [ -f ".env.docker.${INSTANCE_ID}" ]; then \
      flutter build web --release --dart-define-from-file=.env.docker.${INSTANCE_ID}; \
    else \
      flutter build web --release; \
    fi

# Production stage
FROM nginx:alpine

ARG INSTANCE_PORT=8050

# Copy built web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Configure nginx to listen on the correct instance port
RUN sed -i "s/listen       80;/listen       ${INSTANCE_PORT};/g" /etc/nginx/conf.d/default.conf && \
    sed -i "s/listen  \[::]:80;/listen  [::]:${INSTANCE_PORT};/g" /etc/nginx/conf.d/default.conf

EXPOSE ${INSTANCE_PORT}

CMD ["nginx", "-g", "daemon off;"]
