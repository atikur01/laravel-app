# ==========================================
# Laravel + WebDevOps Dockerfile (Render fix)
# ==========================================
FROM webdevops/php-nginx:8.2-alpine

# --- Work as root for setup
USER root

# --- Set working directory
WORKDIR /app

# --- Tell Nginx to use Laravel's public directory
ENV WEB_DOCUMENT_ROOT=/app/public

# --- Copy your Laravel app
COPY ./app /app

# --- Install composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# --- Create and fix permissions for Laravel writable directories
RUN mkdir -p /app/storage /app/bootstrap/cache && \
    chmod -R 775 /app/storage /app/bootstrap/cache && \
    chown -R application:application /app/storage /app/bootstrap/cache

# --- Switch back to the webdevops "application" user
USER application

# --- Expose the port
EXPOSE 80

# --- Start supervisord (runs nginx + php-fpm)
CMD ["/usr/bin/supervisord"]
