# Docker - Les bonnes pratiques

Cette annexe s'efforce de recencer un ensemble de bonnes pratiques classiques (voir [références](#références)) complétées de recommandations visant à guider dans la production d'image pouvant être exécutées dans des environnements sécurisés où il n'est par exemple pas possible d'utiliser le port 80 (c.f. [kubernetes.io - Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/))

[[toc]]

## Empaqueter une seule application par conteneur

Par exemple, nous éviterons de produire une image incluant une application et une instance PostgreSQL. Pour faciliter le démarrage de l'application, nous fournirons plutôt un docker-compose.yaml.

> NB : Il reste possible (et recommandé) d'inclure dans une même image un service et les commandes utilitaires de ce service.

## Faire en sorte qu'un conteneur puisse être recréé sans perte de données

Il convient pour ce faire d'externaliser les données de l'application dans des volumes.

## Ne pas inclure des secrets dans les images

* **Ne pas inclure la configuration pour l'exécution dans l'image** (c.f. [12 facteurs - III. Configuration - Stockez la configuration dans l’environnement](../12-facteurs.md#iii-configuration---stockez-la-configuration-dans-lenvironnement-factor-03))
* **Ne pas inclure le dossier `.git` dans les images** :
  * Inclure `.git` dans `.dockerignore`
  * Éviter `COPY . .`
* **Ne pas utiliser `--build-arg` pour fournir des secrets à la construction**
  * Noter que `docker image history ...` permet de récupérer les secrets correspondants
  * Éviter les dépendances (git, npm, PHP composer...) impliquant une authentification
  * Voir [docs.docker.com - Build secrets](https://docs.docker.com/build/building/secrets/) si vous ne pouvez vraiment éviter de telles dépendances...
* **Veiller à ne pas inclure un fichier `.env` incluant des secrets utilisé pour le développement dans l'image** :
  * Option 1) Si le framework propose de gérer de tels fichiers à la racine du projet (ex : PHP Symfony), être très attentif à leurs présences dans `.dockerignore` et `.gitignore`.
  * Option 2) Pour limiter réellement le risque d'inclure de tels fichiers dans une image, stocker et chiffrer ces secrets loin du Dockerfile et des dépôts GIT.

## Minimiser la taille des images

* **Comprendre les mécanismes de couches** dans les images (`docker image history mon-image`)
* **Grouper les instructions** (`RUN ... && ... && `) en conséquence
* **Installer uniquement ce qui est nécessaire** à l'exécution par exemple en utilisant des **multi-stage build**

## Minimiser le temps de construction des images

* Utiliser `.dockerignore` pour limiter la taille du contexte
* **Comprendre les mécanismes de cache dans la construction** des images
* Exploiter ces mécanismes de cache pour limiter les opérations :

```dockerfile
# pour ne pas exécuter npm install à chaque changement dans src/
COPY package-lock.json .
RUN npm install 
# ... ajouter les fichiers dynamiques dans un second temps
COPY src/ src
```

## Ne pas gérer un proxy sortant dans le Dockerfile

Ne pas inclure des éléments relatifs à l'utilisation d'un proxy sortant dans le fichier `Dockerfile` (ex : `ENV HTTP_PROXY ...`).

Au besoin, il est possible de faire suivre la définition du proxy à la construction à la construction (`--build-arg HTTP_PROXY --build-arg HTTP_PROXYS ...`) et à l'exécution (`-e HTTP_PROXY -e HTTPS_PROXY ...`).

## Utiliser un miroir pour l'accès aux images publiques

Utiliser un miroir pour l'accès aux images DockerHub est important pour éviter d'atteindre la limite de pull (c.f. [Docker Hub rate limit](https://docs.docker.com/docker-hub/download-rate-limit/) ).

Noter que :

* Il est possible de **configurer l'utilisation transparente d'un miroir au niveau du démon docker** (même chose pour containerd)
* Il convient de **modifier le nom des images pour l'exécution** dans le cas où cette configuration n'est pas traitée (`nginx:latest` -> `dockerhub-proxy.exemple.fr/library/nginx:latest`)
* Il est possible de **permettre l'utilisation du miroir pour la construction dans le fichier Dockerfile** (`--build-arg registry=dockerhub-proxy.exemple.fr`) :

```dockerfile
ARG registry=docker.io
FROM ${registry}/library/ubuntu:22.04
```

## Observabilité - Respecter le cadre pour les journaux applicatif

Il convient d'écrire les journaux dans les flux standard (stdout et stderr) en utilisant des formats standards (nginx, apache2, json,...).

Nous soulignerons que si ce point ne peut être traité au niveau du développement de l'application, il est possible de rediriger les écritures dans des fichiers dans ces flux standard :

```dockerfile
#------------------------------------------------------------------------
# Illustration du cas apache2
# (adaptée à partir de https://github.com/docker-library/php)
#------------------------------------------------------------------------
RUN ln -sfT /dev/stderr "/var/log/apache2/error.log" \
 && ln -sfT /dev/stdout "/var/log/apache2/access.log" \
 && ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log" \
 && chown www-data:www-data /var/log/apache2/*.log
```

## Observabilité - Permettre la surveillance de l'état du service

* Prévoir des endpoints dédiés à la surveillance de l'état de l'application (`livenessProbe`, `readinessProbe`)
* Prévoir des endpoints dédiés à la surveillance des services utilisés en backend (`/health/db`, `/health/s3`,...)

## Résilience - Traiter proprement les signaux SIGTERM pour accélérer les arrêts/redémarrages des conteneurs

### Cas des services

En substance, la commande `docker stop mon-conteneur -t 600` ne doit pas mettre 10 minutes. Si c'est le cas, l'application ne s'arrête pas proprement lorsqu'elle reçoit un signal d'arrêt (SIGTERM) et docker finit par procéder à un arrêt brutal.

Il en sera de même en environnement Kubernetes où devoir attendre 60 secondes pour que le conteneur s'arrête sera problématique.

Vous pourrez voir par exemple la page [expressjs.com - Health Checks and Graceful Shutdown](https://expressjs.com/en/advanced/healthcheck-graceful-shutdown.html) pour le cas particulier de NodeJS et Express. Pour les autres cas, votre moteur de recherche préféré devrait être en mesure de trouver les ressources qui vous aideront.

### Cas des traitements longs

Pour **les traitements longs**, traiter SIGTERM sera synonyme de **se mettre en capacité de recommencer ou de poursuivre le traitement** s'il doit être interrompu pour une raison ou une autre (ex : redémarrage d'une machine, maintenance sur un noeud Kubernetes, libération d'une instance spot,...).

La stratégie de traitement du message SIGTERM dépendra toutefois du contexte :

* Retour d'un état `PROCESSING` à `PENDING` avec stockage d'une éventuelle progression.
* Remise en pile du message correspondant au traitement réalisé.
* ...

### Cas particulier des images apache2

Dans le cas des images intégrant apache2 (ex : `php:8.3-apache2`), le signal SIGTERM est parfois remplacé par SIGWINCH à l'aide d'une commande `STOPSIGNAL=SIGWINCH` dans le fichier Dockerfile.

Le savoir évite de passer des heures à se demander pourquoi les scripts bash et PHP intégrés dans une image ne reçoivent pas SIGTERM...


## Sécurité - Ne pas exécuter les conteneurs en tant qu'utilisateur root

* Utiliser un utilisateur dédié à l'application pour l'exécution (ex : `USER node`)
* Gérer proprement les droits sur les fichiers dans le conteneur
* Utiliser des ports non privilégiés (>1024) pour permettre l'exécution non root (`runAsNotRoot: true` et `runAsUser: <uid>`)

## Sécurité - Permettre l'exécution des conteneurs avec un système de fichier en lecture seule

Avec Kubernetes, une option `readOnlyRootFilesystem: true` permet d'avoir un conteneur avec un système de fichier en lecture seule présentant différents avantages :

* Bloquer les modifications sur l'application en cas d'attaque
* Identifier les dossiers contenant des données dynamiques (et pouvoir **se protéger contre un risque de full sur les noeuds**)

Pour permettre son utilisation sur une image que l'on met à disposition :

* **Identifier les dossiers dynamiques** dans l'image pour lesquels il conviendra de monter des volumes
* **Ne pas inclure du contenu statique dans ces dossiers dynamique** (un montage `emptyDir` conservant le contenu de l'image sera impossible avec Kubernetes, permettre la génération au démarrage d'un fichier `/app/config/params.yaml` sans vider `/app/config` sera délicat)


## Sécurité - Ne pas exécuter n'importe quoi ou n'importe quelle image

Cette précaution qui s'applique à d'autres outils susceptibles d'exécuter du code malveillant (npm, PHP composer,...) s'applique évidemment aussi pour docker.

## Sécurité - Scanner les images pour détecter des failles ou des secrets

Nous trouverons de tels outils au niveau des dépôts d'image (ex : DockerHub, GitHub Container Registry, Harbor,...). Notez toutefois qu'il est possible d'utiliser localement des outils tels [Trivy](https://aquasecurity.github.io/trivy/) qui est utilisé par Harbor :

```bash
triyv image mon-image:latest
```

A date (juin 2024), la difficulté de l'exercice tient à la présence de failles critiques au sens de ces outils dans les images officielles massivement utilisées (ex : [trivy image --severity HIGH,CRITICAL debian:12-slim](img/trivy-debian-202406.png))


## Sécurité - configurer les options de sécurité au niveau du démon

Plusieurs options de sécurité limitent les risques liés à l'utilisation de docker. Par exemple, l'option [userns-remap](https://docs.docker.com/engine/security/userns-remap/) permet d'associer l'utilisateur "root" au niveau des conteneurs à un utilisateur non root sur le hôte.

Il convient par exemple de s'appuyer sur [docker-bench-security](https://hub.docker.com/r/docker/docker-bench-security) pour configurer ces aspects.

Au niveau de l'environnement de développement, vous devrez faire particulièrement attention à :

## Sécurité - se méfier des expositions de port

Si vous utiliser docker **sur une machine exposée**, vous devrez **éviter les expositions sur des ports** (ex : `-p 5432:5432`). En effet, <span style="font-weight: bold; color: red">docker manipule iptables et les règles de pare-feu local que vous configurez par exemple avec UFW seront tout simplement ignorées.</span>.

Plusieurs autres options sont préférables :

* Utiliser des réseaux pour la communication entre les conteneurs
* Accéder au besoin aux services via les IP des conteneurs depuis le hôte (`docker inspect ...`)
* Mapper certains port uniquement sur l'hôte (ex : `-p 127.0.0.1:9200:9200`)
* Utiliser un reverse proxy tel [Traefik](../../outils/traefik/index.md) pour avoir des URL propres

## Références

* [cloud.google.com - Bonnes pratiques en matière de création de conteneurs](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr)
  * [Traiter correctement le PID 1, le traitement de signal et les processus zombie](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#signal-handling)
  * [Optimiser les conteneurs pour le cache de création de Docker](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#optimize-for-the-docker-build-cache)
  * [Supprimer les outils inutiles](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#remove_unnecessary_tools)
  * [Créer la plus petite image possible](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#build-the-smallest-image-possible)
  * [Utiliser l'analyse des failles dans Container Registry](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#use-vulnerability-scanning)
  * [Ajouter des tags pertinents aux images](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#properly_tag_your_images)
  * [Envisager sérieusement l'utilisation d'une image publique](https://cloud.google.com/solutions/best-practices-for-building-containers?hl=fr#carefully_consider_whether_to_use_a_public_image)
* [docs.docker.com - Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
  * [Decouple applications](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#decouple-applications) : Empaqueter une seule application par conteneur
  * [Don’t install unnecessary packages](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#dont-install-unnecessary-packages) : Installer uniquement les packages nécessaires dans les images
  * [Create ephemeral containers](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#create-ephemeral-containers) : Faire en sorte qu'un conteneur puisse être recréé sans perte de données (volumes nommés)
  * [Understand build context](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#understand-build-context) : Comprendre que les fichiers du contexte de construction sont envoyés au démon docker.
  * [Exclude with .dockerignore](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#exclude-with-dockerignore) : Exclure des fichiers lors de la construction de l'image docker à l'aide de `.dockerignore`
  * [Use multi-stage builds](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#use-multi-stage-builds)
  * [Minimize the number of layers](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#minimize-the-number-of-layers) : Limiter le nombre de couches dans l'image en regroupant les commandes
  * [Leverage build cache](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache) : Comprendre les mécanismes de cache de construction pour mieux les exploiter
  * [Pipe Dockerfile through stdin](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#pipe-dockerfile-through-stdin) : Envoyer directement le contenu `Dockerfile` à via stdin quand son contenu est généré.
  * [Sort multi-line arguments](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#sort-multi-line-arguments) : Organiser les commandes sur plusieurs lignes pour faciliter la relecture et la maintenance

