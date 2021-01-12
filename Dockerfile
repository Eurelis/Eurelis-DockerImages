FROM amazonlinux:1
#
#
# COMMAND :
#
# Build : docker build -t eurelis-php7 .
#
# Run: docker run -d -p 9080:80 -it eurelis-php7
# Shell: docker exec -it XXXXX_XXXXX /bin/bash
# Stop: docker stop XXXXX_XXXXX
#
# Remove container: docker rm XXXXX_XXXXX
# Remove all container: docker rm $(docker ps -a -q)
#
# Remove all ilmages: docker rmi $(docker images -q)
#
#

#
# Config de base
#
RUN yum -y update
#RUN yum -y install yum-util
#RUN yum -y groupinstall development
RUN yum install -y \
       vi \
       htop \
       which \
       git \
       patch \
       diffutils \
       unzip \
       gcc \
       pecl

#
# Install Supervisor
#
RUN python --version \
       && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
       && python get-pip.py \
       && rm get-pip.py \
       && pip install supervisor

#
# Install Apache / PHP7
#
RUN yum install -y httpd24

RUN yum install -y \
       php73 \
       php73-pdo \
       php73-pdo_mysql \
       php73-mysqli \
       php73-ftp \
       php73-soap \
       php73-gmp \
       php73-dom \
       php73-bcmath \
       php73-gd \
       php73-odbc \
       php73-gettext \
       php73-xmlreader \
       php73-xmlwriter \
       php73-xmlrpc \
       php73-bz2 \
       php73-curl \
       php73-ctype \
       php73-session \
       php73-redis \
       php73-zlib \
       php73-mbstring \
       php73-simplexml \
       php73-tokenizer \
       php73-opcache \
       php73-intl \
       php73-posix \
       php73-devel

#
# ImageMagick
#
RUN cd /opt/ \
       && curl -O http://www.imagemagick.org/download/ImageMagick-6.9.10-42.tar.gz \
       && gunzip ImageMagick-6.9.10-42.tar.gz \
       && tar xvf ImageMagick-6.9.10-42.tar \
       && cd ImageMagick-6.9.10-42 \
       && ./configure \
       && make \
       && make install \
       && ldconfig /usr/local/lib \
       && cd .. \
       && rm ImageMagick-6.9.10-42.tar \
       && rm -R ImageMagick-6.9.10-42/
RUN yum install -y php7-pear \
       && pecl7 install imagick \
       && echo "extension=imagick.so" > /etc/php.d/imagick.ini

#
# Install MySQL
#
RUN yum install -y \
       mysql \
       mysql-server

#
# Configure Apache/PHP
#
RUN mkdir '/etc/httpd/vhosts.conf.d'
RUN sed -i "s/#ServerName www.example.com:80/ServerName myproject.local:80/" /etc/httpd/conf/httpd.conf \
       && echo 'IncludeOptional vhosts.conf.d/*.conf' >> /etc/httpd/conf/httpd.conf
RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php.ini
COPY config/info.php /var/www/html/
#RUN chkconfig httpd on
#RUN service httpd start
#RUN apachectl start
EXPOSE 80

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#
# Configure MySQL
#
# TODO: Mettre 256Mo min par défaut et remettre à jour le upload_max_filesize et post_max_size
RUN sed -i "s/socket=\/var\/lib\/mysql\/mysql.sock/socket=\/tmp\/mysql.sock/" /etc/my.cnf \
       && sed -i "s/pdo_mysql.default_socket=/pdo_mysql.default_socket=\/tmp\/mysql.sock/" /etc/php.ini \
       && echo '[client]' >> /etc/my.cnf \
       && echo 'socket=/tmp/mysql.sock' >> /etc/my.cnf

RUN echo 'NETWORKING=yes' >> /etc/sysconfig/network
COPY config/mysql_safe_start_custom.sh /usr/bin/
RUN chmod +x /usr/bin/mysql_safe_start_custom.sh

#RUN chkconfig mysqld on
#RUN service mysqld start

#
# Configure Supervisor
#
COPY config/supervisord.conf /etc/

#
# Configure xdebug
#
RUN yum install -y \
       gcc

RUN cd /opt \
       && curl -OL http://xdebug.org/files/xdebug-2.6.0.tgz \
       && tar -xvzf xdebug-2.6.0.tgz \
       && cd /opt/xdebug-2.6.0 \
       && phpize \
       && ./configure \
       && make \
       && make install \
       && touch /etc/php-7.3.d/90-xdebug.ini \
       && echo "[xdebug]" > /etc/php-7.3.d/90-xdebug.ini \
       && echo "zend_extension = /usr/lib64/php/7.3/modules/xdebug.so" >> /etc/php-7.3.d/90-xdebug.ini \
       && echo "xdebug.remote_enable=true" >> /etc/php-7.3.d/90-xdebug.ini \
       && echo "xdebug.remote_autostart=true" >> /etc/php-7.3.d/90-xdebug.ini \
       && echo "xdebug.remote_host=host.docker.internal" >> /etc/php-7.3.d/90-xdebug.ini \
       # Ajout depuis docker 18.3 : host.docker.internal pointe vers le host
       && cd .. \
       && rm xdebug-2.6.0.tgz \
       && rm -R xdebug-2.6.0 \
       && rm package.xml


#
# Custom env
COPY config/.bashrc /root/

# Create a user in container with the same ACL as host local user
RUN useradd -m -u 1000 -r local
COPY config/.bashrc /home/local

#
# Image history
#
RUN touch /etc/version \
       && echo "Current image version : 3.0" > /etc/version \
       && echo "---------- Version history ----------" >> /etc/version \
       && echo "3.0 - Version PHP 7.3" >> /etc/version \
       && echo "2.5 - Ajout d'un user local au container avec le même UID que l'utilisateur system" >> /etc/version \
       && echo "2.4 - Installation ImageMagick-6.9.10" >> /etc/version \
       && echo "2.3 - Installation ImageMagick" >> /etc/version \
       && echo "2.2 - Ajout unzip" >> /etc/version \
       && echo "2.1 - Set memory_limit - upload_max_filesize - post_max_size" >> /etc/version \
       && echo "2.0 - Version PHP 7.2" >> /etc/version \
       && echo "0.7 - Finalisation Xdebug" >> /etc/version \
       && echo "0.6 - Ajout patch et diffutils" >> /etc/version \
       && echo "0.5 - Ajustements Xdebug" >> /etc/version \
       && echo "0.4 - Optimisation du shell" >> /etc/version \
       && echo "0.3 - Ajout support Xdebug" >> /etc/version \
       && echo "0.2 - Ajout support Git" >> /etc/version \
       && echo "0.1 - Version initiale de l'image" >> /etc/version


#
# Container start
#
#CMD mysqld_safe
#CMD apachectl -D FOREGROUND
CMD ["supervisord", "--nodaemon"]
