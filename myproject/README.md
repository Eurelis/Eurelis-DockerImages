# Docker-Compose sur un projet

Exemple de configuration Docker-Compose pour un projet.

## Running Docker-Compose

Lancer le container
````bash
$ docker-compose up -d
````

Rebuilder l'application
````bash
$ docker exec -i -t myproject-web /opt/scripts/rebuild.sh
````

Se connecter au container en tant que root
````bash
$ docker exec -i -t myproject-web /bin/bash
````

Se connecter au container avec l'utilisateur local
````bash
$ docker exec -it -u local myproject-web /bin/bash
````

Arreter le container
````bash
$ docker-compose stop