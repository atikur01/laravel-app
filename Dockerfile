# ==============================
# Laravel App Dockerfile
# Using WebDevOps PHP-Nginx base image
# ==============================

FROM webdevops/php-nginx:8.2-alpine

# Set working directory inside container
WORKDIR /app

# Copy Laravel app files into container
COPY ./app /app

# Copy environment file if needed (optional)
# COPY ./app/.env /app/.env

# Install Composer dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Set proper permissions for Laravel storage and cache
RUN chown -R application:application /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Expose the default Nginx port
EXPOSE 80

# Start Nginx and PHP-FPM (handled by base image’s supervisor)
CMD ["/usr/bin/supervisord"]
