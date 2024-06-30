# Docker - Les bonnes pratiques

Cette annexe s'efforce de résumer un ensemble de bonnes pratiques classiques (c.f. [références](#références)) complétées de recommandations visant entre autres à guider dans la production d'images pouvant être exécutées dans des environnements sécurisés où il n'est par exemple pas possible d'utiliser le port 80 (c.f. [kubernetes.io - Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) et [kyverno/policies - baseline et restricted](https://github.com/kyverno/policies/tree/main/pod-security))

[[toc]]

## Empaqueter une seule application par conteneur

* Appliquer tant que possible la règle un conteneur = un service.
* Éviter par exemple de produire une image incluant une application et une instance PostgreSQL.
* Utiliser plutôt un fichier docker-compose.yaml pour faciliter le démarrage de l'application.

> NB : Il reste possible (et recommandé) d'inclure dans une même image un service et les utilitaires de ce service.

## Faire en sorte qu'un conteneur puisse être recréé sans perte de données

* Préférer si possible l'utilisation de services dédiés au stockage (base de données, stockage objet,...) pour les données applicatives plutôt que l'utilisation de fichiers.
* Identifier clairement les dossiers contenant des données persistantes dans le cas contraire (ex : `/var/lib/postgresql/data` pour PostgreSQL).
* Externaliser le stockage de ces fichiers à l'aide de volumes (ex : `-v pg-data:/var/lib/postgresql/data`).

## Ne pas inclure des secrets dans les images

* **Ne pas inclure les paramètres pour l'exécution dans l'image** (c.f. [12 facteurs - III. Configuration - Stockez la configuration dans l’environnement](../12-facteurs.md#factor-03)).
* **Ne pas inclure le dossier `.git` dans les images** :
  * Inclure `.git` dans `.dockerignore`.
  * Éviter `COPY . .`.
* **Ne pas utiliser `--build-arg` pour fournir des secrets à la construction**.
  * Savoir que `docker image history ...` permet de récupérer les secrets correspondants.
  * Éviter les dépendances (git, npm, PHP composer...) impliquant une authentification.
  * Consulter [docs.docker.com - Build secrets](https://docs.docker.com/build/building/secrets/) si vous ne pouvez vraiment pas éviter de telles dépendances...
* **Veiller à ne pas inclure un fichier `.env` incluant des secrets utilisés pour le développement dans l'image** :
  * Option 1) Si le framework propose de gérer de tels fichiers à la racine du projet (ex : PHP Symfony), être très attentif à leurs présences dans `.dockerignore` et `.gitignore`.
  * Option 2) Pour limiter réellement le risque d'inclure de tels fichiers dans une image, stocker et chiffrer ces secrets loin du Dockerfile et des dépôts GIT.

## Minimiser la taille des images

* **Installer uniquement ce qui est nécessaire**.
* **Comprendre et exploiter les mécanismes de couches** dans les images (`docker image history mon-image`) :
  * **Grouper les instructions** (`RUN ... && ... && `).
  * **Ordonner les instructions** (ex : ne pas installer des packages systèmes après l'application).
* Utiliser des **multi-stage build** pour éviter de conserver les éléments relatifs à la construction. Par exemple :
  * Construire un site statique dans une image NodeJS (`npm run build`).
  * Copier le dossier public créé dans une image nginx pour l'exécution.

## Minimiser le temps de construction des images

* Utiliser `.dockerignore` pour limiter la taille du contexte.
* **Comprendre et exploiter les mécanismes de cache dans la construction** :

```dockerfile
# Par exemple, pour ne pas exécuter npm install à chaque changement dans src/ :
# 1) installer les dépendances
COPY package.json package-lock.json .
RUN npm install 
# 2) ajouter les fichiers dynamiques dans un second temps
COPY src/ src
```

## Ne pas gérer un proxy sortant dans le Dockerfile

* Ne pas inclure des éléments relatifs à l'utilisation d'un proxy sortant dans le fichier `Dockerfile` (ex : `ENV HTTP_PROXY ...`).
* Faire suivre au besoin la définition pour la construction (`--build-arg HTTP_PROXY --build-arg HTTP_PROXYS ...`).
* Faire suivre au besoin la définition pour l'exécution (`-e HTTP_PROXY -e HTTPS_PROXY ...`).

## Utiliser un miroir pour l'accès aux images publiques

> Utiliser un miroir pour l'accès aux images DockerHub est important pour **éviter d'atteindre la limite de pull** (c.f. [Docker Hub rate limit](https://docs.docker.com/docker-hub/download-rate-limit/) ) :

* **Configurer si possible l'utilisation transparente d'un miroir au niveau du démon docker** (ou containerd).
* **Modifier le nom des images pour l'exécution** dans le cas où cette configuration n'est pas traitée (`nginx:latest` -> `dockerhub-proxy.exemple.fr/library/nginx:latest`).
* **Permettre l'utilisation du miroir pour la construction dans le fichier Dockerfile** (`--build-arg registry=dockerhub-proxy.exemple.fr`) :

```dockerfile
ARG registry=docker.io
FROM ${registry}/library/ubuntu:22.04
```


## Observabilité - Respecter le cadre pour les journaux applicatif

* Écrire les journaux dans les flux standard (stdout et stderr) en utilisant des formats standards (nginx, apache2, json,...).
* Rediriger les écritures dans des fichiers dans ces flux standard s'il n'est pas possible d'adapter le code en ce sens :

```dockerfile
#------------------------------------------------------------------------
# Illustration avec le cas apache2
# (adaptée à partir de https://github.com/docker-library/php)
#------------------------------------------------------------------------
RUN mkdir -p /var/log/apache2 \
 && ln -sfT /dev/stderr "/var/log/apache2/error.log" \
 && ln -sfT /dev/stdout "/var/log/apache2/access.log" \
 && ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log" \
 && chown www-data:www-data /var/log/apache2/*.log
```

## Observabilité - Permettre la surveillance de l'état du service

* Prévoir des endpoints dédiés à la surveillance de l'état de l'application (`livenessProbe`, `readinessProbe`).
* Prévoir des endpoints dédiés à la surveillance des services utilisés en backend (`/health/db`, `/health/s3`,...)

## Sécurité - Ne pas exécuter n'importe quoi ou n'importe quelle image

> Cette précaution qui s'applique à d'autres outils susceptibles d'exécuter du code malveillant (npm, PHP composer,...) s'applique évidemment aussi pour docker.

* Utiliser des images officielles ou des images d'éditeurs reconnus.
* Installer des composants en provenance d'éditeurs reconnus dans vos images.

## Sécurité - Ne pas exécuter les conteneurs en tant qu'utilisateur root

* Utiliser un utilisateur dédié à l'application pour l'exécution (ex : `USER node`, `USER www-data`,...).
* Gérer proprement les droits sur les fichiers dans le conteneur.
* **Utiliser des ports non privilégiés (>1024)** (l'utilisation du port 80 dans de nombreuses images bloque l'activation de `runAsNonRoot: true` et `runAsUser: 1000` avec de nombreuses images en contexte Kubernetes).

## Sécurité - Permettre l'exécution des conteneurs avec un système de fichiers en lecture seule

Avec Kubernetes, une option `readOnlyRootFilesystem: true` permet d'avoir un conteneur avec un système de fichier en lecture seule présentant différents avantages :

* Bloquer les modifications sur l'application en cas d'attaque.
* Identifier les dossiers contenant des données dynamiques (et pouvoir **se protéger contre un risque de full sur les noeuds**).

Pour permettre son utilisation sur une image que l'on met à disposition :

* **Identifier les dossiers dynamiques** dans l'image pour lesquels il conviendra de monter des volumes.
* **Ne pas inclure du contenu statique dans ces dossiers dynamique** (un montage `emptyDir` conservant le contenu de l'image sera impossible avec Kubernetes, permettre la génération au démarrage d'un fichier `/app/config/params.yaml` sans vider `/app/config` sera délicat).

## Sécurité - Scanner les images pour détecter des failles ou des secrets

> A date (juin 2024), la difficulté de l'exploitation des alertes tient à la présence de failles jugées critiques par ces outils dans les images officielles massivement utilisées (ex : [trivy image --severity HIGH,CRITICAL debian:12-slim](img/trivy-debian-202406.png))

* Utiliser les scanners de vulnérabilité au niveau des dépôts d'images (ex : DockerHub, GitHub Container Registry, Harbor,...).
* Utiliser localement des outils tels [Trivy](https://aquasecurity.github.io/trivy/) (qui est utilisé par Harbor) est aussi possible :

```bash
triyv image mon-image:latest
```


## Sécurité - configurer les options de sécurité au niveau du démon

> Plusieurs options de sécurité limitent les risques liés à l'utilisation de docker. Par exemple, l'option [userns-remap](https://docs.docker.com/engine/security/userns-remap/) permet d'associer l'utilisateur "root" au niveau des conteneurs à un utilisateur non root sur le hôte.

* Configurer le démon docker en activant les options de sécurité.
* Vérifier la configuration du démon docker à l'aide d'outils tel [docker-bench-security](https://hub.docker.com/r/docker/docker-bench-security).

## Sécurité - se méfier des expositions de port

> Si vous utiliser docker **sur une machine exposée**, vous devrez **éviter les expositions sur des ports** (ex : `-p 5432:5432`). En effet, <span style="font-weight: bold; color: red">docker manipule iptables et les règles de pare-feu local que vous configurez par exemple avec UFW seront tout simplement ignorées.</span>.

* Utiliser des réseaux pour la communication entre les conteneurs.
* Accéder au besoin aux services non exposés depuis l'hôte :
  * Via les IP des conteneurs (`docker inspect ...`).
  * En mappant les ports uniquement sur l'hôte (ex : `-p 127.0.0.1:9200:9200`)
* Utiliser un **reverse proxy** tel [Traefik](https://github.com/traefik/traefik#overview) **pour limiter le nombre de port à exposer** et pour avoir de jolies URL (ex : https://opensearch.dev.localhost).

## Traiter proprement les signaux SIGTERM pour assurer des arrêts gracieux

### Cas des services

> En substance, la commande `docker stop mon-conteneur -t 600` ne doit pas mettre 10 minutes. Si c'est le cas, l'application ne s'arrête pas proprement lorsqu'elle reçoit un signal d'arrêt (SIGTERM) et docker finit par procéder à un arrêt brutal. Il en sera de même en environnement Kubernetes où devoir attendre 60 secondes pour que le conteneur s'arrête sera problématique.

* Arrêter proprement le service en cas de réception d'un message SIGTERM :
  * Voir exemple pour le cas particulier de NodeJS et Express : [expressjs.com - Health Checks and Graceful Shutdown](https://expressjs.com/en/advanced/healthcheck-graceful-shutdown.html)
  * Adapter pour les autres cas à l'aide de votre moteur de recherche préféré.

### Cas des traitements longs

> Pour **les traitements longs**, traiter SIGTERM sera synonyme de **se mettre en capacité de recommencer ou de poursuivre le traitement** s'il doit être interrompu pour une raison ou une autre (ex : redémarrage d'une machine, maintenance sur un noeud Kubernetes, libération d'une instance spot,...).

* Écouter et faire suivre au besoin les messages SIGTERM (1)
* Utiliser une stratégie adaptée au contexte pour permettre la reprise du traitement :
  * Retour d'un état `PROCESSING` à `PENDING` avec stockage d'une éventuelle progression.
  * Remise en pile du message correspondant au traitement réalisé.
  * ...

> (1) Pour les scripts Bash, voir [www.baeldung.com - Handling Signals in Bash Script](https://www.baeldung.com/linux/bash-signal-handling) (commande `trap`) et [www.baeldung.com - The Uses of the Exec Command](https://www.baeldung.com/linux/exec-command-in-shell-script) (approche `exec`)

### Cas particulier des images apache2

Dans le cas des images intégrant apache2 (ex : `php:8.3-apache2`), le signal SIGTERM est parfois remplacé par SIGWINCH (`STOPSIGNAL=SIGWINCH` dans le fichier Dockerfile...). Le savoir évite de passer des heures à se demander pourquoi les scripts bash et PHP intégrés dans une image ne reçoivent pas le message SIGTERM...

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

