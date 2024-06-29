# Docker

## Principe

Docker s'appuie sur les [technologies d'isolation linux (LXC) pour apporter des mécanismes de virtualisation](https://www.lemagit.fr/conseil/Conteneurs-Linux-et-Conteneurs-Docker-quelles-differences).

## Points clés

* Docker amène des concepts et des outils qui facilitent le déploiement des applications en offrant un **cadre générique pour l'empaquetage des applications**
* Docker s'appuie sur une **API mise à disposition par le démon docker** et exploitée par plusieurs clients.
* Les conteneurs partagent les ressources de l'hôte :
  * Il n'est pas nécessaire de démarrer un OS complet pour chaque application
  * Il n'est pas nécessaire d'allouer de la RAM ou des CPU pour chacun
* Les conteneurs démarrent plus rapidement que les VM car démarrer un conteneur = démarrer un processus
* La construction et le téléchargement des images sont optimisés par la mise en cache au niveau des couches de l'image
* Docker amène un cadre pour la gestion des journaux applicatifs et la collecte de métriques systèmes
* Docker s'appuyant sur des mécanismes d'isolation, il faut s'intéresser par exemple à [Kubernetes](../kubernetes/index.md) pour travailler avec plusieurs machines

## Installation

* [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* Pour ENSG, un script [install-docker-ensg.sh](install-docker-ensg.sh) est disponible (**ne pas utiliser à l'IGN** où il convient entre autre d'utiliser des plages d'IP spécifiques et de configurer l'utilisation du proxy)

## Les principaux concepts

* [Les images](concepts/image.md)
* [Les conteneurs](concepts/conteneur.md)
* [Les volumes](concepts/volume.md)
* [Les réseaux](concepts/network.md)

## Les principaux exécutables

| Nom                                                                 | Fonction                                                                                                                                    |
| ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| [docker](https://docs.docker.com/engine/reference/commandline/cli/) | Programme en ligne de commande pour la gestion des objets docker                                                                            |
| [docker-compose](docker-compose.md)                                 | Programme en ligne de commande pour l'orchestration de conteneurs pour simplifier la gestion des stacks applicatives sur **un** hôte docker |
| [docker-machine](https://docs.docker.com/machine/overview/)         | Programme en ligne de commande pour la création et gestion de machine docker dans VirtualBox, AWS,...                                       |

## Utiliser docker

* [github.com - mborne/docker-exemples](https://github.com/mborne/docker-exemples#readme) pour une découverte progressive des principales commandes
* [container.training - Introduction to Containers](https://container.training/intro-selfpaced.yml.html#1) pour la version longue (857 slides)
* [ddocs.docker.com - CLI reference](https://docs.docker.com/reference/cli/docker/) pour la documentation officielle de l'ensemble des commandes.
* [docs.docker.com - CLI Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) pour un résumé
* [docs.docker.com - Dockerfile reference](https://docs.docker.com/engine/reference/builder/) pour la rédaction de Dockerfile
* [Docker - Les bonnes pratiques](bonnes-pratiques.md)
* [Résoudre les problèmes fréquents avec docker](problemes-frequents.md)
* [Travailler derrière un proxy avec Docker](../proxy-sortant/proxy-docker.md)

## Utiliser docker compose

* [docs.docker.com - Overview of docker compose CLI](https://docs.docker.com/compose/reference/)

## Pour comprendre et aller plus loin

L'implémentation des conteneurs :

* [www.lemagit.fr - Conteneurs Linux et Conteneurs Docker : quelle(s) différence(s) ?](https://www.lemagit.fr/conseil/Conteneurs-Linux-et-Conteneurs-Docker-quelles-differences)
* [phoenixnap.com - Docker vs containerd vs CRI-O: An In-Depth Comparison](https://phoenixnap.com/kb/docker-vs-containerd-vs-cri-o) présente des **alternatives à docker pour l'exécution de conteneurs** et la relation entre docker et containerd utilisée au niveau de Kubernetes.
* [podman](https://podman.io/) est une de ces **alternatives à docker** (mise en avant par exemple dans la certification CKAD pour Kubernetes)

L'implémentation du stockage :

* [docs.docker.com - About storage drivers](https://docs.docker.com/storage/storagedriver/) présente le **système de fichier par couche** des conteneurs et les différentes implémentations (ex : [overlay2](https://docs.docker.com/storage/storagedriver/overlayfs-driver/))
