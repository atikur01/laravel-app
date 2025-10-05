# ==========================================
# Laravel + WebDevOps Dockerfile (Render fix)
# ==========================================
FROM webdevops/php-nginx:8.2-alpine

# --- Work as root for build steps
USER root

# --- Set working directory
WORKDIR /app

# --- Tell Nginx to use Laravel's public directory
ENV WEB_DOCUMENT_ROOT=/app/public

# --- Copy Laravel application
COPY ./app /app

# --- Install dependencies and fix permissions
RUN composer install --no-interaction --no-dev --optimize-autoloader && \
    mkdir -p /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache || true

# --- Expose Nginx port
EXPOSE 80

# --- Start the built-in supervisor (runs Nginx + PHP-FPM)
CMD ["/usr/bin/supervisord"]
