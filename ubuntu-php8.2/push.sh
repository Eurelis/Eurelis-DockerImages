#!/usr/bin/env bash

docker build --build-arg PHP_VERSION=8.2 --build-arg XDEBUG_VERSION=3.3.0 -t ubuntu-php8:php82 .
docker tag ubuntu-php8:php82 eurelis/ubuntu-php8:php82
docker push eurelis/ubuntu-php8:php82