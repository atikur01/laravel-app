# ==========================================
# Laravel Dockerfile (Render-compatible)
# ==========================================

FROM webdevops/php-nginx:8.2-alpine

# Use root commands safely in build stage
USER root

# Set working directory
WORKDIR /app

# Copy Laravel app files
COPY ./app /app

# Install dependencies and set permissions in one step
RUN composer install --no-interaction --no-dev --optimize-autoloader && \
    mkdir -p /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache || true

# Don’t switch users — Render runs as non-root automatically
# USER application  <-- REMOVE this

# Expose port 80
EXPOSE 80

# Use the built-in supervisor to start PHP-FPM + Nginx
CMD ["/usr/bin/supervisord"]
