FROM registry.ademe.fr/docker/phpfpm:8.3-docker-debian

RUN apt-get update \
    && apt-get install -y git zip libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libcurl4-openssl-dev libicu-dev wait-for-it zsh \
    && apt-get clean \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN pecl install xdebug \
    && docker-php-ext-install -j$(nproc) iconv pdo_mysql curl zip intl opcache

# Set the workdir
WORKDIR /var/www/html

#Install composer
RUN /usr/local/bin/install-composer.sh
RUN mv /usr/local/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer
RUN mkdir "/.composer" && chmod 777 /.composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# Set the default shell to Zsh
SHELL ["/bin/zsh", "-c"]

# Enable logging
ENV PHPFPM_CATCH_WORKERS_OUTPUT yes

HEALTHCHECK --interval=30s --timeout=5s CMD php bin/console app:health:check

CMD wait-for-it db:3306 && \
    /usr/local/sbin/php-fpm -F
