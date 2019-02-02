# Eurelis Image for AWS AMI

Compiler le container
````bash
$ docker build -t aws-ami-php7 .
````

Lancer une image et se connecter avec un shell
````bash
$ docker run -i -t aws-ami-php7 /bin/bash
````

Soumettre l'image
````bash
$ ./push.sh
````
Ou utiliser le Makefile


Historique des versions : **dernière version -> 0.7**

| Version | Description                 |
| :-----: | --------------------------- |
|   0.8   | Ajout unzip                 |
|   0.7   | Finalisation Xdebug         |
|   0.6   | Ajout patch et diffutils    |
|   0.5   | Ajustements Xdebug          |
|   0.4   | Optimisation du shell       |
|   0.3   | Ajout support Xdebug        |
|   0.2   | Ajout support Git           |
|   0.1   | Version initiale de l'image |
