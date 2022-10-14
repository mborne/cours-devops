
# DevOps avec des VM

* Contexte
* La création d'un livrable
* La création des VM
* Le déploiement de l'application
* Que manque-t'il?
* L'incontournable zone d'hébergement

---

## Contexte

Nous allons voir en pratique comment se passe le déploiement d'une application **as code** sur des VM linux en déployant :

* [PostgreSQL](https://www.postgresql.org/) avec l'extension [PostGIS](https://postgis.net/) pour stocker des données géographiques.
* [GeoServer](https://geoserver.org/) pour diffuser ces données en WMS et WFS.

---

## La création d'un livrable (1/3)

Pour le déploiement d'une application en PRODUCTION, il est important de :

* Tagger une version du code
* Produire un livrable pour cette version du code

<span style="color: red; font-weight">On ne construira pas une application sur la machine de PRODUCTION!</span>

## La création d'un livrable (2/3)

Dans le cas présent, nous avons de la chance :

* [PostgreSQL](https://www.postgresql.org/download/) met à disposition des binaires pour différents systèmes. Nous pourrons utiliser le dépôt [apt.postgresql.org](http://apt.postgresql.org/) qui permettra d'utiliser `apt-get install` et `apt-get upgrade`
* [GeoServer](https://geoserver.org/release/stable/) met lui aussi à disposition des livrables prêts à l'emploi.

---

## La création d'un livrable (3/3)

Dans le cas général, nous soulignerons que :

* Il existe une **grande variété de formats de livrables possibles** fonction des technologies et OS cible (c.f. [format supportés par Nexus](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats) )
* Packager des applications telles PostgreSQL est un métier (construire et maintenir des .deb ou .rpm dans les règles de l'art n'est pas trivial).
* Dans le cas des **langages interprétés** (NodeJS, PHP...) :
  * Nous pourrons nous contenter en guise de livrable d'une simple archive (.zip, du code et de ses dépendances avec **le code de la version + les dépendances**
  * Nous pourrons facilement produire des .deb ou .rpm avec des outils tels [FPM](https://fpm.readthedocs.io)



---

## La création des VM

**TODO - EN CONSTRUCTION**

* variété des solutions d'hébergement IaaS (exemples)
* découverte avec crédits gratuits ou sandbox annexées à des formations en ligne (acloudguru)
* terraform pour la production (mise en garde sur le stockage des états)
* vagrant pour le DEV (et la suite du cours demo avec vagrantbox)

---

## Le déploiement de l'application

**TODO - EN CONSTRUCTION**

* Ansible, chef, puppet,...
* Focus sur ansible (annexe)
* Déploiement de PostgreSQL avec ansible
* Déploiement de GeoServer avec ansible

---

## Le déploiement de l'application


* Expliquer ce qu'il resterait à faire :
  * Blinder la configuration des VM (parenthèse DevSecOps avec https://dev-sec.io/baselines/linux/ )
  * Installer un reverse Proxy (ex : nginx)
  * Configurer HTTPS (letsencrypt, blinder la configuration TLS : https://www.ssllabs.com/ssltest/,...)
  * Configurer un pare-feu (pour ne pas finir sur [www.shodan.io](https://www.shodan.io/))
  * ...


---

## L'incontournable zone d'hébergement

TODO : présenter l'architecture classique d'une zone d'hébergement IaaS :

* Bastion SSH
* Reverse Proxy / Load Balancer communs aux applications
* Services supports
* Puits de logs
* Système de supervision


