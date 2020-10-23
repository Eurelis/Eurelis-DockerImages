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


Historique des versions : **dernière version -> 2.4**

| Version | Description                                            |
| :-----: | ------------------------------------------------------ |
|   3.0   | Version PHP 7.3                                        |
|   2.4   | Installation ImageMagick-6.9.10                        |
|   2.3   | Installation ImageMagick                               |
|   2.2   | Ajout unzip                                            |
|   2.1   | Set memory_limit - upload_max_filesize - post_max_size |
|   2.0   | Version PHP 7.2                                        |
|   0.7   | Finalisation Xdebug                                    |
|   0.6   | Ajout patch et diffutils                               |
|   0.5   | Ajustements Xdebug                                     |
|   0.4   | Optimisation du shell                                  |
|   0.3   | Ajout support Xdebug                                   |
|   0.2   | Ajout support Git                                      |
|   0.1   | Version initiale de l'image                            |
