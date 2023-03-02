# Travailler derrière un proxy avec Docker

## Contexte

En présence d'un proxy sortant pour l'accès aux ressources internet, il convient de spécifier ce proxy au niveau de la configuration du démon et lors de la construction et de l'utilisation des images.

## Principe

* [Configurer le démon pour télécharger les images en utilisant le proxy](https://docs.docker.com/config/daemon/systemd/)

> `/etc/systemd/system/docker.service.d/http-proxy.conf`

* Construire les images en spécifiant le proxy avec des arguments de construction :

> `docker build --build-arg http_proxy --build-arg https_proxy ...`

* Exécuter les conteneurs en spécifiant le proxy avec des variables d'environnement :

> `docker run -e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTPS_PROXY ...`

## Remarques

* La page [docs.docker.com - Configure the Docker client](https://docs.docker.com/network/proxy/#configure-the-docker-client) indique qu'il est possible de configurer le proxy au niveau de la configuration du client (`~/.docker/config.json`). Testé sans succès.


