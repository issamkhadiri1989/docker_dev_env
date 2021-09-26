#FROM php:7.4-apache
FROM oberd/php-8.0-apache

RUN a2enmod rewrite
RUN apt-get update && apt-get install -y git unzip zip
WORKDIR /var/www/html
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql bcmath zip intl opcache
COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer
RUN apt update 
RUN apt install nano

# install the PHP APCu extension
RUN mkdir -p /usr/src/php/ext/apcu && curl -fsSL https://pecl.php.net/get/apcu | tar xvz -C "/usr/src/php/ext/apcu" --strip 1 && docker-php-ext-install apcu


# initialize git
RUN mkdir /root/.ssh/
COPY docker/server/ssh/* /root/.ssh/
RUN chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/id*
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan gitlab.com,172.65.251.78 >> /root/.ssh/known_hosts
RUN echo "Host gitlab.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config


RUN pecl install xdebug-3.0.1 && docker-php-ext-enable xdebug