FROM webdevops/php-nginx:8.2

WORKDIR /app
COPY ./app /app

ENV WEB_DOCUMENT_ROOT=/app/public
ENV APP_ENV=prod


RUN composer install --no-interaction --no-progress --prefer-dist --no-scripts