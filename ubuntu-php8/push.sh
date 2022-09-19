#!/usr/bin/env bash

docker build --build-arg PHP_VERSION=8.1 --build-arg XDEBUG_VERSION=3.1.0 -t ubuntu-php8:php81 .
docker login
docker tag ubuntu-php8:php81 eurelis/ubuntu-php8:php81
docker push eurelis/ubuntu-php8:php81