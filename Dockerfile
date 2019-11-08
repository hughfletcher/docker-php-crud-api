FROM php:7.3.8-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
      libxml2-dev \
      wget \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      xml \
      mysqli \
      pdo_mysql

RUN cd /var/www/html \
    && wget --trust-server-names https://raw.githubusercontent.com/mevdschee/php-crud-api/v2.6.1/api.php -O index.php

RUN a2enmod rewrite

RUN echo 'RewriteEngine On' >> /var/www/html/.htaccess \
      && echo 'RewriteBase /' >> /var/www/html/.htaccess \
      && echo 'RewriteCond %{REQUEST_FILENAME} !-f' >> /var/www/html/.htaccess \
      && echo 'RewriteCond %{REQUEST_FILENAME} !-d' >> /var/www/html/.htaccess \
      && echo 'RewriteRule ^(.*)$ index.php/$1 [NC,L]' >> /var/www/html/.htaccess

COPY ./entrypoint.sh /
ENTRYPOINT /entrypoint.sh
