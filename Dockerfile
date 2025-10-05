# Stage 1: Build stage
FROM laravelphp/php-fpm:8.2-fpm-alpine AS builder

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apk add --no-cache \
    bash \
    git \
    unzip \
    sqlite \
    libzip-dev \
    oniguruma-dev \
    curl \
    && docker-php-ext-install pdo pdo_sqlite zip mbstring

# Copy composer and install dependencies
COPY composer.json composer.lock ./
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN composer install --no-dev --optimize-autoloader

# Copy the rest of the application
COPY . .

# Stage 2: Production stage
FROM laravelphp/php-fpm:8.2-fpm-alpine

WORKDIR /var/www/html

# Install runtime dependencies
RUN apk add --no-cache sqlite libzip oniguruma

# Copy built application from builder
COPY --from=builder /var/www/html /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Expose port (optional if using with reverse proxy)
EXPOSE 9000

CMD ["php-fpm"]
