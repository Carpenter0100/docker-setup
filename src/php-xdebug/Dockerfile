FROM pws_php

# install xdebug
RUN install-php-extensions xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
