# Use official PHP image
FROM php:8.3.10-fpm

# Install system dependencies
RUN apt-get update -y && \
    apt-get install -y \
    libpq-dev \
    git \
    unzip \
    zip \
    curl \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_pgsql mbstring bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install PHP dependencies via Composer
RUN composer install --no-dev --optimize-autoloader

# Expose port 80
EXPOSE 80

# Start PHP-FPM
CMD ["php-fpm"]
