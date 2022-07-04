FROM php:8.1.1-fpm

ARG VERSION_OS
ENV VERSION_OS=${VERSION_OS}

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

RUN apt-get update

RUN docker-php-ext-install pdo_mysql

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-install sockets

RUN set -x && \
    # install lib packages
    apt-get update &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
        openssh-server \
        nodejs \
        git \
        default-mysql-client \
        npm \
        bc \
        libzip-dev \
        unzip \
        # for bz2
        #   - ref: https://github.com/docker-library/php/issues/47
        libbz2-dev \
        # for gd
        #   - ref: https://stackoverflow.com/questions/61228386/installing-gd-extension-in-docker
        libfreetype6-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
         libmemcached11 \
         libmemcachedutil2 \
         libmemcached-dev \
    && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        # for composer
        #postgresql-client \
        mc \
        && \
    # docker-php
    #   - Removed `mbstring` on alpine: https://stackoverflow.com/questions/59251008/docker-laravel-configure-error-package-requirements-oniguruma-were-not-m/59253249#59253249
    #     Due to this error: `configure: error: Package requirements (oniguruma) were not met: Package 'oniguruma', required by 'virtual:world', not found`
    # for gd
    #   - ref: https://github.com/docker-library/php/pull/910#issuecomment-559383597
    docker-php-ext-configure gd --with-freetype --with-jpeg ; \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        pdo \
        pdo_pgsql \
        bz2 \
        gd \
        exif \
        opcache \
        zip \
        && \
    docker-php-source delete && \
    # php configurations
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    # composer
    curl -sS https://getcomposer.org/installer | php -- --quiet --install-dir=/usr/local/bin --filename=composer && \
    # clean up
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/nginx/html/*

RUN cd /root \
        && git clone https://github.com/php-memcached-dev/php-memcached \
        && cd php-memcached \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && cd .. \
        && rm -rf  php-memcached \
        && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
        && apt-get remove -y build-essential libmemcached-dev libz-dev \
        && apt-get remove -y libmemcached-dev libz-dev \
        && apt-get autoremove -y \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean

WORKDIR /var/www/src
RUN chown -R www-data:www-data ./
COPY opcache.ini /usr/local/etc/php/conf.d/