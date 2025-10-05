# ==========================================
# Laravel Dockerfile for Render (fixed 403)
# ==========================================
FROM webdevops/php-nginx:8.2-alpine

# Use root for build
USER root

# Set working directory
WORKDIR /app

# Set Laravel public directory as web root
ENV WEB_DOCUMENT_ROOT=/app/public

# Copy your Laravel app
COPY ./app /app

# Install Composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader && \
    mkdir -p /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache || true

# Expose port 80 (Nginx)
EXPOSE 80

# Start Nginx + PHP-FPM
CMD ["/usr/bin/supervisord"]
