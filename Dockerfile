# Build stage: Flutter SDK image with the web toolchain available.
FROM ghcr.io/cirruslabs/flutter:3.35.4 AS build

WORKDIR /app

# Copy dependency manifests first to improve Docker layer caching.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get --enforce-lockfile

COPY . .

RUN flutter build web --release --no-pub --base-href / \
    --dart-define=flutter.inspector.structuredErrors=false \
    --dart-define=debugShowCheckedModeBanner=false

# Runtime stage: serve the compiled Flutter SPA with Nginx.
FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
