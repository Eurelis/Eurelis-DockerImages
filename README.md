# Eurelis Image for AWS AMI

Compiler le container
````bash
$ docker build -t aws-ami-php7 .
````

Lancer une image et se connecter avec un shell
````bash
$ docker run -i -t aws-ami-php7 /bin/bash
````

Soumettre l'image.
````bash
$ ./push.sh
````