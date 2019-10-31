FROM php:7.2-fpm

LABEL maintainer="bryan@handsup.com"

## Set working directory. This directory is where we place the project
WORKDIR /var/www

## Update apt-get & install dependencies
## Clear apt-get cache after installing dependencies
RUN rm /etc/apt/preferences.d/no-debian-php && apt-get update && apt-get install -y \
  git \
  php-sqlite3 \
  libmpdec-dev \
  libxml2-dev \
  build-essential \
  default-mysql-client \
  libpng-dev \
  libjpeg62-turbo-dev \
  libfreetype6-dev \
  locales \
  zip \
  jpegoptim optipng pngquant gifsicle \
  vim \
  unzip \
  php-soap \
  curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install decimal @ref: https://github.com/php-decimal/ext-decimal
RUN pecl install decimal

# Enable decimal extensio
COPY docker-php-ext-decimal.ini /usr/local/etc/php/conf.d

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install soap
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install sockets

## Install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /var/www

# Copy id_rsa.pub to container ~/.ssh
RUN mkdir /root/.ssh
COPY id_rsa.pub /root/.ssh
COPY id_rsa /root/.ssh

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["/usr/local/sbin/php-fpm"]