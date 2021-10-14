# Eurelis Image for AWS AMI

Compiler le container
````bash
$ docker build --build-arg PHP_VERSION=7.x -t ubuntu-php7:php7x .
````

Lancer une image et se connecter avec un shell
````bash
$ docker run -i -t ubuntu-php7:php7x /bin/bash
````

Soumettre l'image
````bash
$ ./push.sh
````
Ou utiliser le Makefile


Historique des versions : **dernière version -> 1.0**

| Version | Description                                   |
|:-------:|-----------------------------------------------|
|   1.0   | Version initiale de l'image - Support PHP 7.3 |
