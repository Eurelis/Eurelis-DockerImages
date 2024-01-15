# https://computingforgeeks.com/how-to-install-php-on-ubuntu-linux-system/
FROM ubuntu:20.04

#
# Ok with values : 8.2
#
ARG PHP_VERSION

#
# Ok with values : 3.3.0
#
ARG XDEBUG_VERSION

#
# Config de base
#
RUN apt-get update -y
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
# Install Apache / PHP8
#
RUN apt-get install -y apache2 software-properties-common

RUN echo "install PHP${PHP_VERSION}" \
    && add-apt-repository ppa:ondrej/php \
    && apt upgrade -y \
    && apt update \
    && apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-uuid \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-yaml \
    php${PHP_VERSION}-zip

RUN apt-get install -y php-pear

#
# Configure Apache/PHP
#
RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php/${PHP_VERSION}/apache2/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/${PHP_VERSION}/apache2/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php/${PHP_VERSION}/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php/${PHP_VERSION}/apache2/php.ini
COPY config/info.php /var/www/html/

EXPOSE 80

#
# ImageMagick
#
RUN apt-get install -y imagemagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --2 --install-dir=/usr/local/bin --filename=composer

#
# Configure xdebug
#
RUN cd /opt \
    && curl -OL http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz \
    && tar -xvzf xdebug-${XDEBUG_VERSION}.tgz \
    && cd /opt/xdebug-${XDEBUG_VERSION} \
    && phpize \
    && export PHP_API_VERSION=$(php -i | grep 'PHP API' | sed -e 's/PHP API => //') \
    && ./configure \
    && make \
    && make test \
    && make install \
    && touch /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    && echo "[xdebug]" > /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    && echo "zend_extension = /usr/lib/php/$PHP_API_VERSION/xdebug.so" >> /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_enable=true" >> /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_autostart=true" >> /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /etc/php/${PHP_VERSION}/apache2/conf.d/90-xdebug.ini \
    # Ajout depuis docker 18.3 : host.docker.internal pointe vers le host
    && cd .. \
    && rm xdebug-${XDEBUG_VERSION}.tgz \
    && rm -R xdebug-${XDEBUG_VERSION} \
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
    && echo "Current image version : 1.0 with PHP ${PHP_VERSION} and XDEBUG ${XDEBUG_VERSION}" > /etc/version \
    && echo "---------- Version history ----------" >> /etc/version \
    && echo "1.0 - Version initiale de l'image" >> /etc/version

#
# Container start
#
CMD ["supervisord", "--nodaemon"]
