
# DevOps avec des conteneurs

* Les principaux concepts
* L'intérêt des conteneurs
* L'utilisation d'images publiques
* La construction d'une image
* Le déploiement de l'application avec docker compose
* La mise en oeuvre d'un reverse proxy
* Que manque-t'il à ce stade?
* L'orchestration de conteneur

---

## Les principaux concepts (1/2)

### Vue d'ensemble

L'utilisation de docker amène à manipuler plusieurs concepts :

* Les **images** qui sont fonctionnellement équivalentes aux images de VM
* Les `Dockerfile` qui décrivent la construction d'une image à partir d'une image de base et d'instructions.
* Les **dépôts d'images (*registry*)** qui permettent de télécharger et stocker des images.
* Les **conteneurs** qui sont des instances des images se comportant comme des VM grace à des mécanismes d'**isolation**.
* Les **volumes** qui permettent d'externaliser les données des **conteneurs** ("montage")
* Les **réseaux** qui permettent la communication entre les conteneurs.
* Le **démon docker** qui met à disposition [une API pour gérer les conteneurs, images, volumes, réseaux,...](https://docs.docker.com/engine/api/v1.41/).
* L'[exécutable docker](https://docs.docker.com/engine/reference/commandline/cli/) qui est un client de l'API permettant de manipuler les images, les conteneurs, les volumes, les réseaux,...

---

## Les principaux concepts (1/2)

### Découverte par la pratique

Nous allons tâcher de faire un premier survol de ces concepts en reprenant le cas pratique du déploiement de GeoStack.

Pour approfondir sur cette technologie, vous pourrez vous appuyer sur les ressources suivantes :

* [docs.docker.com - Docker overview](https://docs.docker.com/get-started/overview/)
* [container.training](https://container.training/)
* Le site [labs.play-with-docker.com](https://labs.play-with-docker.com/) qui vous permettra de faire vos premiers tests en ligne

---

## L'intérêt des conteneurs

Nous soulignerons que le succès de docker doit beaucoup aux points suivants :

* **L'image est un livrable universel** (plus besoin de choisir entre un .deb, .rpm, .war, .zip,...)
* **L'image est définie as code** via le `Dockerfile` (donc **reconstructible**)
* Le **démarrage** des conteneurs est **rapide** (démarrage d'un processus isolé vs démarrage d'un OS)
* Les téléchargements et constructions sont optimisés car :
  * Une image est un système de fichier par couche
  * Il y a des mécanismes de cache à la construction et au téléchargement
* L'API permet la construction d'un écosystème avec par exemple :
  * Le reverse proxy [traefik](https://doc.traefik.io/traefik/) qui se configure automatiquement en inspectant les conteneurs (**introspection**)
  * L'IHM [portainer](https://www.portainer.io/) qui permet de démarrer des conteneurs (**réflexion**)

---

## L'utilisation d'images publiques

Un autre élément joue beaucoup dans le succès de docker : [Le dépôt d'image public gratuit DockerHub](https://hub.docker.com/search?q=). Nous y trouvons un grand nombre d'images d'OS ([ubuntu](https://hub.docker.com/_/ubuntu), [debian](https://hub.docker.com/_/debian), [alpine](https://hub.docker.com/_/alpine),...) et d'applications ([postgres](https://hub.docker.com/_/postgres), [mongodb](https://hub.docker.com/_/mongodb), [redis](https://hub.docker.com/_/redis),...) prêtes à l'emploi.

Pour déployer GeoStack, nous trouvons :

* Une image [postgis/postgis](https://hub.docker.com/r/postgis/postgis) pour le déploiement PostgreSQL
* De [nombreuses images GeoServer](https://hub.docker.com/search?q=geoserver)

---

## La construction d'une image

Pour illustrer la construction d'une image docker à partir d'un Dockerfile, nous allons faire l'exercice de créer nous même l'image pour GeoServer dans le dépôt [github.com - mborne/docker-geoserver](https://github.com/mborne/docker-geoserver#readme).

Nous l'inspecterons ensemble et soulignerons que nous pourrons récupérer l'image comme suit pour la suite :

```bash
docker pull ghcr.io/mborne/geoserver:v2.21.1
```

---

## Le déploiement de l'application avec docker compose

**EN CONSTRUCTION**

---

## La mise en oeuvre d'un reverse proxy

**EN CONSTRUCTION :**

* Présenter [traefik](https://doc.traefik.io/traefik/)
* La [configuration automatique basée sur des labels permise par l'API docker](https://doc.traefik.io/traefik/providers/docker/)
* La [capacité à traiter facilement la mise en oeuvre de TLS](https://doc.traefik.io/traefik/https/overview/)
* Et [bien d'autres points tel la mise en eouvre de limite de nombres d'appel avec les middlewares](https://doc.traefik.io/traefik/middlewares/http/ratelimit/)


---

## Que manque-t'il à ce stade?

En l'état, si cherchions à héberger GeoStack sur plusieurs machines, nous remarquerions que :

* Les conteneurs sur la machine A ne peuvent communiquer avec ceux de la machine B
* Les démons docker sur les machines ne se connaissent pas (un outil tel traefik devrait moissonner deux API distincte)
* Il nous est délicat de mettre en oeuvre un volume partagé par les conteneurs sur les deux machines.

---

## L'orchestration de conteneur avec Kubernetes

**EN CONSTRUCTION :**

* Introduction :
  * Les différentes solutions swarm, Kubernetes,...
  * L'apport de swarm au niveau de docker
  * (Pas de panique quand vous verrez containerd, c'est la seule partie "run" de docker)

* Une API à l'échelle du cluster
* Une API avec une approche déclarative
* Une API riche en concept (LoadBalancer, Ingress,...)
* Une API extensible permettant l'introspection (exemple avec traefik)
* Une API permettant aussi la réflexion (zalando/postgresql-operator)
* Une API permettant **séparer les responsabilités entre les DEV et les OPS** (à comparer avec l'approche IaaS de la partie précédente)
