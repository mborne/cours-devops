# Docker - les images

## Principe

Une image est fonctionnellement équivalente à l'image d'une VM.

## Points clés

* La commande [docker build](https://docs.docker.com/engine/reference/commandline/build/) est utilisée pour construire une image à partir d'un fichier [Dockerfile](https://docs.docker.com/engine/reference/builder/).
* Il est possible (et recommandé) d'exclure des fichiers à l'aide de `.dockerignore`.
* Il est possible d'utiliser des arguments de construction (`ARG`) par exemple pour construire plusieurs versions d'une application avec un seul `Dockerfile`.

## Quelques commandes

* [docker pull](https://docs.docker.com/engine/reference/commandline/pull/) pour télécharger une image à partir d'un dépôt (DockerHub par défaut)
* [docker build](https://docs.docker.com/engine/reference/commandline/build/) pour construire une image à partir d'un [Dockerfile](https://docs.docker.com/engine/reference/builder/).
* [docker tag](https://docs.docker.com/engine/reference/commandline/tag/) pour créer une image à partir d'une image existante.
* [docker login](https://docs.docker.com/engine/reference/commandline/login/) pour s'authentifier au besoin sur un dépôt.
* [docker push](https://docs.docker.com/reference/cli/docker/push/) pour envoyer une image sur un dépôt.
