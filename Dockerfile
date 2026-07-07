# zxtunes.com — PHP 8.5-FPM image (multi-stage build)
FROM php:8.5-fpm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install mysqli mbstring gd zip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM php:8.5-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
        libpng16-16t64 libjpeg62-turbo libfreetype6 libonig5 libzip5 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/docker-php-ext-*.ini /usr/local/etc/php/conf.d/

RUN useradd -r -s /usr/sbin/nologin zxtunes \
    && mkdir -p /home/zxtunes/tmp \
                /home/zxtunes/web/zxtunes.com/public_html \
                /home/zxtunes/web/zxtunes.com/data \
    && chown -R www-data:www-data /home/zxtunes

COPY conf/php-hardened.ini /usr/local/etc/php/conf.d/zxtunes.ini
COPY conf/opcache-prod.ini /usr/local/etc/php/conf.d/opcache.ini
COPY conf/php-fpm-www.conf /usr/local/etc/php-fpm.d/www.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD php -r "if(false===@fsockopen('localhost',9000)){exit(1);}" || exit 1

EXPOSE 9000
CMD ["/entrypoint.sh"]
