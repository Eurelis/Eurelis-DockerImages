# Eurelis Image Apache/PHP8

Image basee sur `ubuntu:24.04`, parametree par build-arg pour supporter les versions PHP 8.0 a 8.4 (voir `push.sh` pour les couples PHP_VERSION / XDEBUG_VERSION valides).

Compiler le container

```bash
docker build --build-arg PHP_VERSION=8.x --build-arg XDEBUG_VERSION=3.x.x -t ubuntu-php8:php8x .
```

Lancer une image et se connecter avec un shell

```bash
docker run -i -t ubuntu-php8:php8x /bin/bash
```

Soumettre les images (toutes versions)

```bash
./push.sh
```

Historique des versions : **derniere version -> 2.0**

| Version | Description                                                          |
|:-------:|-----------------------------------------------------------------------|
|   2.0   | Passage de la base a `ubuntu:24.04` (la PPA ondrej/php ne fournit plus de paquets pour `ubuntu:20.04`) et ajout du support PHP 8.4 |
|   1.1   | Fix build linux/amd64, mise a jour des certificats CA, support PHP 8.2 / 8.3 |
|   1.0   | Version initiale de l'image - Support PHP 8.0 / 8.1                  |
