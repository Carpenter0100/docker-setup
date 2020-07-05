FROM php:7.4-fpm

# install software
RUN apt-get update \
    && apt-get install -y \
        wget \
        curl \
        git \
        build-essential \
        nodejs \
        ca-certificates \
        zsh \
        nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install extensions and use an external script for that.
# https://github.com/mlocati/docker-php-extension-installer
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions \
    gd \
    intl \
    redis \
    pdo_mysql \
    opcache \
    pcntl \
    mysqli \
    gettext \
    exif \
    bz2 \
    bcmath \
    amqp \
    mcrypt \
    rdkafka \
    zip \
    yaml

# add php.ini overrides to scandir for additional .ini files
COPY php-ini-overrides.ini /usr/local/etc/php/conf.d/

# set timezone
RUN echo "Europe/Berlin" > /etc/timezone \
    && echo "Europe/Berlin" > /etc/localtime

# configure mailhog to catch and display mails
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
RUN echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' > /usr/local/etc/php/php.ini

# install node, npm, composer
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && curl -L https://www.npmjs.com/install.sh | sh \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
