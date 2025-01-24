FROM debian:bullseye-slim

RUN \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get -y --no-install-recommends install \
        php7.4 \
        php-fpm \
        libfcgi-bin \
        php-cli \
        php-zip \
        wget \
        php-mysql \
        php-mbstring \
        php-xml \
        sendmail \
        ca-certificates \
        mariadb-client \
        curl \
    && apt-get clean

RUN \
    sed -i "s/listen = .*/listen = 0.0.0.0:9000/" "/etc/php/7.4/fpm/pool.d/www.conf"; \
    sed -i 's/clear_env = no/;clear_env = no/' "/etc/php/7.4/fpm/pool.d/www.conf"; \
    mkdir -p "/run/php"; \
    chown "www-data:www-data" "/run/php"; \
    wget "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"; \
    chmod +x "wp-cli.phar"; \
    mv "wp-cli.phar" "/usr/local/bin/wp"; \
    wp cli update

COPY tools/* /

ENTRYPOINT /docker-entrypoint.sh php-fpm7.4 -F
