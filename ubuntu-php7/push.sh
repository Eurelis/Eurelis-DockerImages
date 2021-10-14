#!/usr/bin/env bash

docker build --build-arg PHP_VERSION=7.3 -t ubuntu-php7:php73 .
docker login
docker tag ubuntu-php7:php73 eurelis/ubuntu-php7:php73
docker push eurelis/ubuntu-php7:php73

docker build --build-arg PHP_VERSION=7.4 -t ubuntu-php7:php74 .
docker login
docker tag ubuntu-php7:php74 eurelis/ubuntu-php7:php74
docker push eurelis/ubuntu-php7:php74