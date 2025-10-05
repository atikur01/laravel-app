# Use WebDevOps PHP Apache image
FROM webdevops/php-apache:8.2

# Set working directory
WORKDIR /app

# Enable SQLite PDO extension
RUN /usr/local/bin/docker-php-ext-enable pdo_sqlite

# Copy composer files first for better caching
COPY composer.json composer.lock ./

# Install Composer and dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

# Copy the rest of the application
COPY . .

# Set permissions for Laravel
RUN chown -R application:application /app \
    && chmod -R 755 /app/storage /app/bootstrap/cache

# Expose port 80 (Apache)
EXPOSE 80

# Start Apache in foreground (WebDevOps default entrypoint)
CMD ["supervisord"]
