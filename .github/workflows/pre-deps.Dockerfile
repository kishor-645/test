FROM --platform=linux/amd64 php:8.1-fpm-bookworm

WORKDIR /var/www/html

# Install necessary packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
    libcurl4-openssl-dev libssl-dev libonig-dev libsodium-dev \
    libxml2-dev zlib1g-dev libzip-dev libjpeg-dev libpng-dev \
    libfreetype6-dev libxslt1-dev libjpeg62-turbo-dev autoconf \
    libx11-6 libx11-dev libgconf-2-4 libnss3 libatk-bridge2.0-0 \
    libxcomposite1 libxrandr2 libgbm1 libasound2 libpangocairo-1.0-0 \
    libatk1.0-0 libcups2 libdbus-1-3 \
    git pip curl unzip apache2 && \
    pip install --break-system-packages awscli && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd intl bcmath soap sockets \
    zip mbstring simplexml pdo pdo_mysql xsl opcache

# Installing composer
COPY --from=composer:2.5.5 /usr/bin/composer /usr/bin/composer

# Install Node.js and NPM (necessary for magepack)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs

# Install magepack globally
RUN npm install -g magepack critical

# Clean up
RUN rm -rf var/view_preprocessed/ var/cache/ var/page_cache/ var/tmp/ var/generation/ pub/static/frontend/ pub/static/adminhtml \
    var/di/ var/generation/ var/cache/ var/page_cache/ var/view_preprocessed/ var/composer_home/cache/
