FROM ubuntu:20.04

#
# Ok with values : 7.3 | 7.4
#
ARG PHP_VERSION

#
# Config de base
#
RUN apt-get update
RUN apt-get install -y \
    curl \
    gcc \
    ghostscript \
    git \
    unzip \
    vim \
    zip

#
# Time zone
#
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt install -y tzdata

#
# Install pip
#
RUN apt-get install -y python3-pip

#
# Install Supervisor
#
RUN pip install supervisor

#
# Install Apache / PHP7
#
RUN apt-get install -y \
    apache2

RUN apt-get install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php

RUN apt-get install -y \
    php$PHP_VERSION \
    php$PHP_VERSION-bcmath \
    php$PHP_VERSION-bz2 \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-dev \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-gmp \
    php$PHP_VERSION-intl \
    php$PHP_VERSION-imagick \
    php$PHP_VERSION-json \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-mcrypt \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-opcache \
    php$PHP_VERSION-soap \
    php$PHP_VERSION-uuid \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-xmlrpc \
    php$PHP_VERSION-yaml \
    php$PHP_VERSION-zip

RUN apt-get install -y php-pear

#
# Configure Apache/PHP
#
RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php/$PHP_VERSION/apache2/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/$PHP_VERSION/apache2/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php/$PHP_VERSION/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php/$PHP_VERSION/apache2/php.ini
RUN sed -i "s/;error_log = php_errors.log/error_log = \/var\/log\/apache2\/php_errors.log/" /etc/php/$PHP_VERSION/apache2/php.ini
RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php/$PHP_VERSION/cli/php.ini
RUN sed -i "s/;error_log = php_errors.log/error_log = \/var\/log\/apache2\/php_errors.log/" /etc/php/$PHP_VERSION/cli/php.ini
COPY config/info.php /var/www/html/

# Active apache rewrite
RUN a2enmod rewrite
RUN service apache2 restart

EXPOSE 80

#
# ImageMagick
#
RUN apt-get install -y imagemagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --1 --install-dir=/usr/local/bin --filename=composer
RUN curl -sS https://getcomposer.org/installer | php -- --2 --install-dir=/usr/local/bin --filename=composer2

#
# Configure xdebug
#
RUN cd /opt \
    && curl -OL http://xdebug.org/files/xdebug-2.9.0.tgz \
    && tar -xvzf xdebug-2.9.0.tgz \
    && cd /opt/xdebug-2.9.0 \
    && phpize \
    && export PHP_API_VERSION=$(php -i | grep 'PHP API' | sed -e 's/PHP API => //') \
    && ./configure \
    && make \
    && make test \
    && make install \
    && touch /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    && echo "[xdebug]" > /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    && echo "zend_extension = /usr/lib/php/$PHP_API_VERSION/xdebug.so" >> /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_enable=true" >> /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_autostart=true" >> /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /etc/php/$PHP_VERSION/apache2/conf.d/90-xdebug.ini \
    # Ajout depuis docker 18.3 : host.docker.internal pointe vers le host
    && cd .. \
    && rm xdebug-2.9.0.tgz \
    && rm -R xdebug-2.9.0 \
    && rm package.xml

#
# Install MySQL
#
RUN apt-get install -y mysql-client

#
# Configure Supervisor
#
COPY config/supervisord.conf /etc/

#
# Custom env
#
COPY config/.bashrc /root/

#
# Create a user in container with the same ACL as host local user
#
RUN useradd -m -u 1000 -r local
COPY config/.bashrc /home/local

#
# Image history
#
RUN touch /etc/version \
    && echo "Current image version : 1.1 with PHP $PHP_VERSION" > /etc/version \
    && echo "---------- Version history ----------" >> /etc/version \
    && echo "1.2 - Activate apache rewrite" >> /etc/version \
    && echo "1.1 - Support for composer 1 & 2" >> /etc/version \
    && echo "1.0 - Version initiale de l'image" >> /etc/version

#
# Container start
#
CMD ["supervisord", "--nodaemon"]
