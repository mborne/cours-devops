# DevOps - Les 12 facteurs

Les [12 facteurs](https://12factor.net/fr/#les_12_facteurs) sont des recommandations tirées de l'expérience d'[Heroku](https://www.heroku.com/) parues en 2012. Elles guident dans la **conception applications faciles à déployer et capables de s'adapter à la charge**.

Cette page s'efforce d'en faire une lecture en lien avec les éléments vu dans le cours.

## [I. Base de code - Une base de code suivie avec un système de contrôle de version, plusieurs déploiements](https://12factor.net/fr/codebase) {#factor-01}

Cette recommandation pose les règles suivantes :

* Le **code d'une application doit être versionné** par exemple avec GIT
* Chaque application dispose de sa propre base de code (deux applications différentes ne partagent pas le même dépôt)
* Le même dépôt est utilisé pour le déploiement des différents environnements (seule la version diffère)

En particulier, il conviendra de veiller à **ne dupliquer le code d'une application pour faire plusieurs déploiements** (chose que l'on observe parfois quand le code de l'application inclue des éléments de paramétrage des environnements). En revanche, nous soulignerons que dans le cadre d'une approche GitOps, il sera intéressant d'avoir :

* Un **dépôt dédié au code source** de l'application avec une **gestion propre des branches et des versions**.
* Un **dépôt dédié aux scripts de déploiement** pour être en mesure de **versionner le paramétrage des différents environnements** (ex : version déployée en QUALIF vs PROD)


## [II. Dépendances - Déclarez explicitement et isolez les dépendances](https://12factor.net/fr/dependencies) {#factor-02}

Cette recommandation pose les règles suivantes :

* Une application ne doit **pas <u>dépendre implicitement</u> d'un composant devant être installé en amont du déploiement** au niveau du système (ex : curl, zip,...)
* Une application doit s'appuyer sur un **gestionnaire de dépendances** (npm/yarn, PHP Composer, maven,...) pour déclarer **ses dépendances et leurs versions**.

Nous noterons que l'utilisation de conteneurs permet de relaxer la première règle en considérant les points suivants :

* Une image de conteneur est un livrable autonome.
* Le fichier `Dockerfile` joue un rôle de gestionnaire de dépendances (`RUN apt-get install curl`) permettant de (re)construire ce livrable.


## [III. Configuration - Stockez la configuration dans l’environnement](https://12factor.net/fr/config) {#factor-03}

Cette recommandation pose le principe d'une **stricte séparation entre le code et la configuration** pouvant varier en fonction des déploiements. Elle invite à s'appuyer sur des **variables d'environnement pour gérer le paramétrage des applications** (ex : `DB_HOST`, `DB_USER`, `DB_PASSWORD`,...)


En pratique, nous noterons que :

* Un fichier de configuration complexe pourra difficilement être remplacé par des variables d'environnement (ex : configuration de fluent-bit pour la collecte des journaux applicatifs, configuration de traefik pour l'exposition des services,...)
* Il convient surtout de **ne pas stocker le paramétrage dans le dépôt du code de l'application** et d'**injecter les paramètres spécifiques à l'environnement lors du déploiement**.

**Configurer des variables d'environnement lors du déploiement sera plus simple** mais il restera par exemple possible de :

* Générer des fichiers de configuration à partir de template ansible
* Monter des fichiers de configuration à l'aide de volumes dans le conteneurs
* Gérer des fichiers de configuration sous forme de ConfigMap ou Secret avec Kubernetes


## [IV. Services externes - Traitez les services externes comme des ressources attachées](https://12factor.net/fr/backing-services) {#factor-04}

Il convient de **ne pas faire de distinction entre les services locaux et les services externes**. 

Par exemple, un changement de configuration devra permettre de basculer entre l'utilisation de :

* Une base de données déployée localement par un développeur
* Une base de donnée déployée par un équipe dédiée
* Une base de donnée gérée par l'hébergeur (SaaS)

## [V. Assemblez, publiez, exécutez - Séparez strictement les étapes d’assemblage et d’exécution](https://12factor.net/fr/build-release-run) {#factor-05}

En pratique, cette recommandation se traduit par la séparation en processus dédiés pour :

* La construction et l'exécution des tests unitaires (ex : `NodeJS CI`)
* La construction et la publication d'un livrable en cas de release (ex : `Publish to npmjs.com`, `Publish to DockerHub`,...)
* Le déploiement d'une version publiée (ex : `Deploy`)

## [VI. Processus - Exécutez l’application comme un ou plusieurs processus sans état](https://12factor.net/fr/processes) {#factor-06}

Cette recommandation pose la règle qu'une application doit s'exécuter sous forme d'un ou plusieurs **processus sans état** ([redhat.com - Stateful et stateless : quelle est la différence ?](https://www.redhat.com/fr/topics/cloud-native-apps/stateful-vs-stateless)) qui [ne partagent rien](https://en.wikipedia.org/wiki/Shared-nothing_architecture).

En pratique, nous remarquerons que cette recommandation amènera à **externaliser le stockage des données** :

* **Stocker les données en base de données** (PostgreSQL, MongoDB,...)
* **Stocker les fichiers à l'aide de services dédiés (S3, voire NFS)** plutôt que localement sur les VM ou les conteneurs.
* **Stocker les données des sessions dans une base de données** (ex : Redis) plutôt que localement (comportement par défaut avec PHP) ou en RAM (comportement par défaut avec Java)
* ...

Les **fichiers stockés localement** au niveau de l'application devront être **jetables et propre à chaque instance** de l'application (ex : cache applicatif).


## [VII. Associations de ports - Exportez les services via des associations de ports](https://12factor.net/fr/port-binding) {#factor-07}

Cette recommandation pose la règle qu'**une application ne doit pas dépendre d'un serveur applicatif externe (tomcat, apache, nginx,...) pour s'exécuter**. Elle doit être auto-suffisante et capable de répondre sur un ou plusieurs ports (ex : `http://localhost:3000`).

Nous noterons toutefois que l'utilisation de conteneur permet de rendre indolore le déploiement de ces serveurs applicatifs dans la mesure où ils sont embarqué dans les images.

## [VIII. Concurrence - Grossissez à l'aide du modèle de processus](https://12factor.net/fr/concurrency) {#factor-08}

En substance :

* L'**adaptation à la charge** passe par l'**adaptation du nombre de processus**.
* Il est possible de **distinguer des processus web** pour répondre aux requêtes HTTP et des **processus de traitement (*worker*)** pour les tâches de fond

En outre, il est recommandé de s'appuyer sur l'OS (ex : `systemd`) ou des outils dédiés (ex : `foreman`) pour gérer proprement les arrêts et flux de sortie des processus (plutôt que gérer des "démons" à l'ancienne avec des pid).

En environnement conteneurisé, nous devrons nous inspirer de ce dernier point en nous appuyant au mieux sur les fonctionnalités disponibles au niveau du moteur d'exécution des conteneurs ou de Kubernetes.

## [IX. Jetable - Maximisez la robustesse avec des démarrages rapides et des arrêts gracieux](https://12factor.net/fr/disposability) {#factor-09}

Les **processus doivent pouvoir être démarrés, arrêtés et redémarrés rapidement**. Ceci implique de :

* Minimiser le temps de démarrage
* Gérer proprement le traitement d'un signal SIGTERM
* Survivre à un plantage brutal

En outre, la recommandation s'accompagne de conseils spécifiques aux traitements basées sur des piles de message.


## [X. Parité dev/prod - Gardez le développement, la validation et la production aussi proches que possible](https://12factor.net/fr/dev-prod-parity) {#factor-10}

Cette recommandation invite à **utiliser les mêmes services externes (PostgreSQL, Redis,...) dans les environnements de développement et de production**.

En pratique, s'appuyer sur des outils tels Vagrant ou Docker facilitera l'installation en local de ces services pour les besoins de développement.

Nous éviterons ainsi la tentation de travailler par exemple avec PostgreSQL en PROD et SQLITE en DEV pour échapper à l'installation de PostgreSQL sur les postes des développeurs.


## [XI. Logs - Traitez les logs comme des flux d’évènements](https://12factor.net/fr/logs) {#factor-09}

En substance, il est recommandé de **produire les logs dans la sortie standard** et de **laisser des outils dédiés se charger de la collecte et de l'indexation de ces logs** (logstash, fluent-bit, fluentd...).

En pratique, s'appuyer sur une bibliothèque dédiée à l'écriture des journaux applicatifs permettra généralement de :

* Configurer la sortie des journaux (stdout/stderr plutôt que fichier)
* Produire ces journaux applicatifs dans un format exploitable


## [XII. Processus d’administration - Lancez les processus d’administration et de maintenance comme des one-off-processes](https://12factor.net/fr/admin-processes)

En substance, **les applications doivent embarquer les commandes utilitaires qui seront exécutées comme des processus indépendants**.

En pratique, au niveau des applications web, nous noterons que les frameworks permettent généralement d'**inclure des commandes en annexe du code dédié au traitement des requêtes HTTP** :

* Les commandes `rake` d'application ruby telles GitLab (ex : `gitlab-rake gitlab:backup:create` pour la sauvegarde)
* Les commandes `bin/console` des applications Symfony (`bin/console cache:clear --env=prod` pour le nettoyage du cache)
* Les commandes basées sur [commander](https://www.npmjs.com/package/commander) avec NodeJS
* ...
</div>

Au niveau des conteneurs, nous pourrons intégrer des programmes utilitaires à l'image et noterons que généralement :

* La **commande par défaut** correspondra au **démarrage l'application en mode service** (ex : l'image `postgres` démarrant le service PostgreSQL par défaut)
* **La même image pourra être utilisée pour réaliser un traitement d'administration en spécifiant une commande** (ex : l'image `postgres` permettant l'utilisation de `createdb` ou `psql` dans ce même conteneur pour initialiser la base)


