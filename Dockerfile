# ==============================
# Laravel App Dockerfile (fixed)
# Using WebDevOps PHP-Nginx base image
# ==============================

FROM webdevops/php-nginx:8.2-alpine

# Switch to root to run privileged commands
USER root

# Set working directory
WORKDIR /app

# Copy Laravel app
COPY ./app /app

# Install Composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Fix permissions for Laravel storage and cache
RUN mkdir -p /app/storage /app/bootstrap/cache && \
    chown -R application:application /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Switch back to unprivileged user for runtime
USER application

# Expose port 80 (Nginx)
EXPOSE 80

# Start Nginx and PHP-FPM via supervisor
CMD ["/usr/bin/supervisord"]
