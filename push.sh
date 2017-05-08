#!/usr/bin/env bash

docker build -t aws-ami-php7 .
docker login
docker tag aws-ami-php7 eurelis/aws-ami-php7
docker push eurelis/aws-ami-php7