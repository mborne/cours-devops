---
theme: marp-ensg
paginate: true
footer: ENSG - <a href="./#2">Introduction à la méthode DevOps</a> - mars 2025
header: '<div><img src="./img/logo-ensg.png" alt="ENSG" height="64px"/></div>'
---

# DevOps avec des conteneurs

- [Principe de fonctionnement](#principe-de-fonctionnement)
- [Les principaux concepts](#les-principaux-concepts)
- [Les principaux clients](#les-principaux-clients)
- [Les dépôts d'images](#les-dépôts-dimages)
- [L'observabilité](#lobservabilité)
- [Découvrir docker par la pratique](#découvrir-docker-par-la-pratique)
- [Le déploiement de GeoStack](#le-déploiement-de-geostack)
- [L'intérêt des conteneurs](#lintérêt-des-conteneurs)
- [Que manque-t'il à ce stade?](#que-manque-til-à-ce-stade)

---

## Principe de fonctionnement

### Partage de l'OS et isolation des processus

Par rapport aux VM, les conteneurs docker sont basés sur des **fonctionnalités d'isolation du noyau Linux** :

<div class="left illustration">

<img src="img/docker-vs-vm.png" alt="Conteneur vs VM" style="height: 200px" />

(source : <a href="https://www.docker.com/resources/what-container/">www.docker.com - Comparing Containers and Virtual Machines</a>)

</div>

<div class="right">

Le **démarrage d'un conteneur sera plus rapide que le démarrage d'une VM** car :

- Démarrer un **conteneur** = démarrer un **processus isolé**
- Démarrer une **VM** = démarrer un **OS complet**

</div>

---

## Principe de fonctionnement

### Utilisation d'un système de fichiers par couche

Avec docker, nous trouverons un **concept d'image fonctionnellement identique à celui auquel nous sommes habitué avec les VM** (ex : les `.box` téléchargées par `vagrant` dans la partie précédente).

La deuxième optimisation notable de docker par rapport aux VM tiendra à l'**utilisation de système de fichiers par couche ("overlay") pour matérialiser ces images**.

Cette approche permettra à docker d'**optimiser le téléchargement et la construction des images avec des mécanismes de cache**.

---

## Principe de fonctionnement

### La surcouche docker

Les mécanismes d'isolation ne sont pas nouveaux dans le noyau Linux (voir [LXC - LinuX Containers](https://fr.wikipedia.org/wiki/LXC) et [cgroups](https://fr.wikipedia.org/wiki/Cgroups)). [Les systèmes de fichiers par couches non plus](https://www.adaltas.com/fr/2021/06/03/linux-overlay-filesystem-docker/).

Docker apporte par contre un ensemble cohérent **de concepts et d'outils donnant un cadre pour construire et déployer efficacement des applications** en s'appuyant sur ces mécanismes.

---

## Les principaux concepts

### Vue d'ensemble des concepts

<div style="font-size: 0.9em">

L'utilisation de docker amènera en effet à manipuler plusieurs concepts :

- Les **images** qui sont fonctionnellement équivalentes aux images de VM
- Les fichiers [Dockerfile](https://docs.docker.com/reference/dockerfile/) qui décrivent la construction d'une image.
- Les **dépôts d'images (*registry*)** qui permettent de télécharger et stocker des images.
- Les **conteneurs** qui sont des instances des images se comportant comme des VM grace à des mécanismes d'**isolation**.
- Les **volumes** qui permettent d'externaliser les données des **conteneurs** ("montage de disque")
- Les **réseaux** qui permettent la communication entre les conteneurs.
- Le **démon docker** qui met à disposition [une API pour gérer les conteneurs, images, volumes, réseaux,...](https://docs.docker.com/engine/api/v1.45/).

---

## Les principaux clients

Nous utiliserons principalement les **clients en ligne de commande** suivants **pour communiquer avec l'API docker**  :

- L'exécutable [**docker**](https://docs.docker.com/engine/reference/commandline/cli/) qui permettra de **manipuler individuellement les images, les conteneurs, les volumes, les réseaux,...**
- Son plugin [**docker compose**](https://docs.docker.com/compose/) qui permettra de **gérer des stacks au format YAML** (des services exécutant des conteneurs, des réseaux et des volumes,...)

Nous mentionnerons l'existance d'**interfaces graphiques** (ex : [Portainer](https://www.portainer.io/)) qui sont clientes de l'API docker. Elles ne seront pas utilisées dans ce cours pour une meilleure compréhension du fonctionnement.

---

## Les dépôts d'images

### DockerHub

<div style="font-size: 0.85em">

Nous trouverons plusieurs dépôts d'images mettant à disposition des images docker prêtes à l'emploi. Le plus connu étant [DockerHub](https://hub.docker.com/search?q=) qui met à disposition :

- Des images d'OS : [ubuntu](https://hub.docker.com/_/ubuntu), [debian](https://hub.docker.com/_/debian), [alpine](https://hub.docker.com/_/alpine),...
- Des images pour des services : [postgres](https://hub.docker.com/_/postgres), [mongodb](https://hub.docker.com/_/mongodb), [redis](https://hub.docker.com/_/redis),...
- Des images pour des applications : [wordpress](https://hub.docker.com/_/wordpress), [jenkins](https://hub.docker.com/r/jenkins/jenkins),...

Pour déployer GeoStack, nous y trouverons par exemple :

- Une image [postgis/postgis](https://hub.docker.com/r/postgis/postgis) pour le déploiement PostgreSQL avec l'extension spatiale PostGIS.
- De [nombreuses images GeoServer](https://hub.docker.com/search?q=geoserver)

> Nous remarquerons que l'utilisation de DockerHub pour stocker des images ne sera pas forcément gratuite (c.f. [docker.com - Pricing & Subscriptions](https://www.docker.com/pricing/)) et qu'il existe une [limite de nombre de téléchargement par IP ou par utilisateur](https://docs.docker.com/docker-hub/download-rate-limit/).

</div>

---

## Les dépôts d'images

### Les autres dépôts d'images publiques

<div style="font-size: 0.95em">

Il existe d'autres dépôts d'images publiquement accessibles dont :

- [quay.io](https://quay.io/) de RedHat mettant par exemple à disposition les [dernières versions de Keycloak](https://quay.io/repository/keycloak/keycloak)
- [docker.elastic.co](https://www.docker.elastic.co/) mettant à disposition les images de la stack ELK

Ainsi :

- **En l'absence de précision, nous utiliserons DockerHub** (utiliser l'image `keycloak/keycloak` sera équivalent à utiliser l'image `docker.io/keycloak/keycloak`).
- **Nous préciserons le domaine en cas d'utilisation d'un autre dépôt** (ex : `quay.io/keycloak/keycloak`)

</div>

---

## Les dépôts d'images

### Les dépôts d'images privés

Il est possible de stocker des images avec des outils tels [Harbor](https://goharbor.io/), [Nexus](https://hub.docker.com/r/sonatype/nexus3) ou [registry](https://hub.docker.com/_/registry) déployés en propre.

---

## Les dépôts d'images

### Le dépôt d'images du gestionnaire de code source

La plupart des **gestionnaires de code source (GitHub, GitLab, Gitea,...) intègrent désormais un système de stockage d'image docker** (ghcr.io, registry.gitlab.com,...) ce qui :

- **Évite de gérer en parallèle des authentifications et des droits au niveau du dépôt d'images**.
- **Simplifie la publication des images** au niveau des orchestrateurs d'intégration continue (qui sont eux aussi intégrés aux gestionnaires de code source)

---

## Les dépôts d'images

### Les dépôts d'images des hébergeurs

Enfin, nous mentionnerons l'existence de **dépôts d'images au niveau des solutions d'hébergement** (ex : Google Container Registry, Azure Container Registry, Amazon Elastic Container Registry (ECR)...).

L'utilisation de ces derniers sera parfois imposée pour utiliser certaines fonctionnalités.

> NB : Un hébergeur ne pourra pas garantir qu'il est capable de redéployer votre application en cas de problème s'il dépend une infrastructure tierce.

---

## L'observabilité

### Les journaux applicatifs

<div style="font-size: 0.9em">

Nous soulignerons que **la gestion des journaux applicatifs est unifiée** par :

- La **collecte des flux de sorties standards (stdout/stderr) des conteneurs** par le démon docker (1).
- La présence d'une commande [docker logs](https://docs.docker.com/engine/reference/commandline/logs/) permettant de récupérer les journaux applicatifs d'un conteneur.
- La [présence de plusieurs drivers pour l'écriture des logs](https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers) (2).

> (1) Il sera bien sûr toujours possible d'écrire des journaux dans des fichiers mais se conformer à la [11ième recommandation sur Logs des 12 facteurs](https://12factor.net/fr/logs) et écrire les messages dans les flux standards simplifiera la collecte de ces derniers.
> 
> (2) journald semble particulièrement intéressant pour unifier les journaux des conteneurs avec ceux des services systemd classiques afin d'en faciliter la centralisation.

</div>

---

## L'observabilité

### Les métriques systèmes

En outre, nous soulignerons que **docker collectera des métriques systèmes sur les conteneurs** (CPU, mémoire, entrées/sorties disque et réseau).

Ces métriques seront disponibles au niveau de l'API docker et via la commande [docker stats](https://docs.docker.com/engine/reference/commandline/stats/).


---

## Découvrir docker par la pratique

### Principe

A l'instar de Ansible, il faudrait de nombreuses séances pour vous former réellement à l'utilisation de docker. Nous allons nous contenter d'une découverte des principaux concepts à l'aide d'exemples.

Pour approfondir sur cette technologie, vous pourrez suivre un cours dédié ou vous appuyer sur les ressources suivantes :

- [docs.docker.com - Docker overview](https://docs.docker.com/get-started/overview/)
- [container.training - Introduction to Containers](https://container.training/intro-selfpaced.yml.html#1)

---

## Découvrir docker par la pratique

### Installation de docker

Nous allons nous assurer d'avoir une installation fonctionnelle de docker permettant d'exécuter `docker run hello-world`.

<div class="left">

Si docker n'est pas installé sur votre poste, vous pourrez :

- [Installer docker sur une VM Linux](https://mborne.github.io/cours-devops/annexe/docker/#installation)
- Utiliser le site [labs.play-with-docker.com](https://labs.play-with-docker.com/) pour faire vos premiers tests en ligne (la création d'un compte personnel sur DockerHub sera requise):

</div>

<div class="right illustration">

![h:280px](img/play-with-docker.png)

Play with Docker

</div>

---

## Découvrir docker par la pratique

### Les problèmes classiques

Une [annexe docker](https://mborne.github.io/cours-devops/annexe/docker/index.html) référence la procédure d'installation officielle et s'efforce de guider sur la [résolution des problèmes classiques](https://mborne.github.io/cours-devops/annexe/docker/problemes-frequents.html).

En particulier, il vous faudra potentiellement traiter ceux liés à l'[utilisation d'un proxy sortant avec docker](https://mborne.github.io/fiches/proxy-sortant/proxy-docker/).

---

## Découvrir docker par la pratique

### Mise en garde

**Éviter d'installer le démon docker directement sur un poste de travail branché sur le réseau de votre école/entreprise.**

La configuration par défaut du démon (`/etc/docker/daemon.json`) devra être adaptée pour :

- Éviter les conflits d'IP entre les réseaux virtuels créés par docker et le réseau local (`bip` et `default-address-pools`)
- Définir les bonnes options de sécurité (voir [docker-bench-for-security](https://github.com/docker/docker-bench-security#docker-bench-for-security))


---

## Découvrir docker par la pratique

### Quelques exemples pour débuter...

Pour la prise en main du client [docker](https://docs.docker.com/engine/reference/commandline/cli/) et la découverte des concepts, nous allons voir ensemble les exemples stockés dans un dépôt dédié annexé à ce cours :

- [mborne/docker-exemples](https://github.com/mborne/docker-exemples#docker---quelques-exemples)

Pour la prise en main de [docker compose](https://docs.docker.com/compose/reference/#command-options-overview-and-help), nous utiliserons [mborne/docker-devbox](https://github.com/mborne/docker-devbox/#mbornedocker-devbox) qui est mon terrain de jeu pour docker et Kubernetes en démarrant (1) :

- [mborne/docker-devbox - redis](https://github.com/mborne/docker-devbox/tree/master/redis)
- [mborne/docker-devbox - postgis](https://github.com/mborne/docker-devbox/tree/master/postgis)

> (1) Il faudra en pré-requis exécuter `docker network create devbox` (l'intérêt de la chose sera expliqué par la suite)

---

## Le déploiement de GeoStack

### Principe

Après cette brève introduction, nous allons pouvoir reprendre le déploiement de GeoStack réalisé précédemment avec Ansible.

---

## Le déploiement de GeoStack

### La construction d'une image

Pour illustrer la construction d'une image docker à partir d'un [Dockerfile](https://docs.docker.com/reference/dockerfile/), nous allons faire l'exercice de :

- Créer nous même l'image pour GeoServer
- Stocker cette image à l'aide de GitHub Container Registry (ghcr.io)

Nous inspecterons ensemble le dépôt [mborne/docker-geoserver](https://github.com/mborne/docker-geoserver#readme) correspondant et soulignerons que nous pourrons récupérer l'image comme suit pour la suite :

```bash
docker pull ghcr.io/mborne/geoserver:v2.21.1
```

---

## Le déploiement de GeoStack

### Le déploiement avec docker compose

Nous trouverons la démonstration correspondante dans le dépôt ci-après :

[mborne/geostack-deploy - Déploiement de GeoStack avec docker compose](https://github.com/mborne/geostack-deploy/tree/master/docker#readme)

Nous mémoriserons que :

- **L'utilisation d'un fichier [docker-compose.yml](https://github.com/mborne/geostack-deploy/blob/master/docker/docker-compose.yml) permet de démarrer une pile applicative complète à l'aide de la commande `docker compose up -d`**.
- Sans [docker compose](https://docs.docker.com/compose/reference/), nous serions amené à exécuter de nombreuses commandes docker.

---

## Le déploiement de GeoStack

### La mise en oeuvre d'un reverse proxy (1/2)

Avec Ansible, la mise en oeuvre d'un reverse proxy aurait induit par exemple l'installation et la configuration de nginx.

Avec docker, la présence d'une [API au niveau de docker](https://doc.traefik.io/traefik/providers/docker/) permet des mécanismes de **découverte de configuration** exploités par exemple par [Traefik](https://github.com/mborne/docker-devbox/tree/master/traefik#traefik).

Nous traiterons le déploiement [geostack-deploy - docker - Mise en oeuvre d'un reverse proxy](https://github.com/mborne/geostack-deploy/blob/master/docker/README.md#mise-en-oeuvre-dun-reverse-proxy) pour en comprendre le fonctionnement.

> En alternative à Traefik, il est possible d'utiliser [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy). La principale problématique à traiter serait la même : Le LoadBalancer devra avoir accès aux conteneurs exposés (d'où le réseau "devbox" au niveau de [mborne/docker-devbox](https://github.com/mborne/docker-devbox)).

---

## Le déploiement de GeoStack

### La mise en oeuvre d'un reverse proxy (2/2)

En complément, nous constaterons que [traefik](https://doc.traefik.io/traefik/) faciliterait au passage la [mise en oeuvre de TLS](https://doc.traefik.io/traefik/https/overview/) et de bien d'autres points tels la [mise en oeuvre de limites de nombres d'appel par IP](https://doc.traefik.io/traefik/middlewares/http/ratelimit/)

---

## L'intérêt des conteneurs

<div style="font-size: 0.9em">

En synthèse, nous soulignerons le succès de docker doit beaucoup aux points suivants :

- **L'image est un livrable universel** (plus besoin de choisir entre un .deb, .rpm, .war, .zip,...)
- **L'image est définie as code** via le `Dockerfile` (donc **reconstructible**)
- **L'image testée en DEV est celle qui s'exécute en PROD**
- Le **démarrage** des conteneurs est **rapide**.
- Les **téléchargements et constructions d'images sont optimisés**.
- Un cadre est posé pour l'**observabilité** avec **journaux applicatifs** et les **métriques systèmes**
- **L'API permet la construction d'un écosystème** avec par exemple :
  - Le reverse proxy [traefik](https://doc.traefik.io/traefik/) qui se configure automatiquement en inspectant les conteneurs (**introspection**)
  - L'IHM [portainer](https://www.portainer.io/) qui permet de démarrer des conteneurs (**réflexion**)

</div>

---

## Que manque-t'il à ce stade?

En l'état, si cherchions à héberger GeoStack sur plusieurs machines, nous remarquerions que :

- Les conteneurs sur **la machine A ne peuvent communiquer avec ceux de la machine B**
- Les démons docker sur les machines ne se connaissent pas (un outil tel [Traefik](https://doc.traefik.io/traefik/) devrait moissonner deux API distinctes)

Les **conteneurs** étant une **technologie d'isolation**, nous avons actuellement uniquement l'option de **scalabilité verticale**.

Nous allons voir comment y remédier dans la partie [DevOps avec Kubernetes](kubernetes.html).
