
# DevOps avec des VM

* Contexte
* Architecture initiale
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

## Architecture initiale

Nous commencerons par l'architecture triviale suivante :

![GeoStack 0.1](schema/geostack-0.1.png)

Nous en étudierons les limites par la suite.

---

## La création d'un livrable (1/4)

### Ne pas construire l'application en PRODUCTION

<span style="color: red; font-weight">Construire une application sur la PRODUCTION amène de nombreux problèmes :</span>

* Le risque de **ne pas pouvoir redéployer l'application en cas de problème** (ex : disparition d'une dépendance, indisponibilité d'un service,...)
* Une augmentation de la durée du déploiement
* La construction sur chaque instance.
* ...

NB : L'utilisation de fichier `package-lock.json`, `composer.lock`,... ne vous protégera que contre une montée en version innatendue des dépendances.

---

## La création d'un livrable (2/4)

### Produire et stocker un livrable à déployer

Pour le déploiement d'une application en PRODUCTION, il est important de :

* Tagger une version au niveau du gestionnaire de code source (ex : `v0.1.0`).
* Produire un livrable pour cette version du code.
* [Stocker ce livrable](annexe/stockage-artefact.html).
* Déployer en PRODUCTION un livrable stocké en lieu sûr.

(c.f. [Les 12 facteurs - V. Assemblez, publiez, exécutez](https://12factor.net/fr/build-release-run))

---

## La création d'un livrable (3/4)

### Choisir des services déjà packagés

Dans le cas présent, nous avons cette chance :

* [PostgreSQL](https://www.postgresql.org/download/) met à disposition des binaires pour différents systèmes. Nous pourrons utiliser le dépôt [apt.postgresql.org](http://apt.postgresql.org/) qui permettra d'utiliser `apt-get install` et `apt-get upgrade`
* [GeoServer](https://geoserver.org/release/stable/) met lui aussi à disposition des livrables prêts à l'emploi.

Nous appelerons le système résultant **GeoStack** (afin d'avoir un nom de base pour faire un dépôt)

---

## La création d'un livrable (4/4)

### Packager sa propre application

Dans le cas où il convient de créer un livrable pour sa propre application, on souligne que :

* Il existe une **grande variété de formats de livrables possibles** fonction des technologies et OS cible (c.f. [format supportés par Nexus](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats) )
* Packager des applications telles PostgreSQL est un métier (construire et maintenir des .deb ou .rpm dans les règles de l'art n'est pas trivial).
* Dans le cas des **langages interprétés** (NodeJS, PHP...) :
  * Nous pourrons nous contenter en guise de livrable d'une simple archive (.zip, du code et de ses dépendances avec **le code de la version + les dépendances**
  * Nous pourrons facilement produire des .deb ou .rpm avec des outils tels [FPM](https://fpm.readthedocs.io)

Nous n'entrerons pas dans le détail (*spoiler* : nous verrons comment l'utilisation de conteneurs résoud ce problème)

---

## La création des VM (1/4)

### La variété des API

Il existe une grande variétés d'offres d'hébergement offrant une API permettant de contrôler :

* Les machines virtuelles (*compute*)
* Les réseaux privés (*network*)
* Le stockage (*storage*)
* L'exposition de service (*Load Balancer*)
* Un nom de domaine / DNS (1)
* ...

Nous trouverons des **concepts spécifiques à chaque solution dans ces API** (c.f. [API OVHCloud](https://api.us.ovhcloud.com/console/), [API Scaleway](https://developers.scaleway.com/en/), [DigitalOcean API (2.0)](https://docs.digitalocean.com/reference/api/api-reference/)...)

> (1) Particulièrement pratique pour générer des certificats wildcard [LetsEncrypt](https://letsencrypt.org/fr/) avec [lego](https://go-acme.github.io/lego/dns/)

---

## La création des VM (2/4)

### Terraform

Pour **gérer une infrastructure "as code" en production**, nous pourrons nous appuyer sur **[Terraform](https://www.terraform.io/intro#how-does-terraform-work)** qui apporte :

* Un **langage déclaratif** pour la création des ressources (machine virtuelle, réseau,...)
* Le support d'un [grand nombre de **fournisseurs**](https://registry.terraform.io/browse/providers) dont :
  * Les clouds publics : [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), [Google Cloud Platform](https://registry.terraform.io/providers/hashicorp/google/latest),...
  * Les clouds privés : [vsphere](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs), [openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs),...

Nous nous contenterons de survoler quelques exemples et d'une mise en garde sur le fait que **terraform n'est pas stateless** (il convient de [configurer un backend pour le stockage des états](https://www.terraform.io/language/settings/backends/configuration))

---

## La création des VM (3/4)

### Vagrant (1/2)

Pour la suite, nous allons plutôt utiliser [Vagrant](https://www.vagrantup.com/) qui est l'équivalent de [Terraform](https://www.terraform.io/) pour les environnements de développement.

Nous allons analyser et utiliser le dépôt [mborne/vagrantbox](https://github.com/mborne/vagrantbox) pour démarrer des VM (`vagrantbox-1`, `vagrantbox-2`,...) avec [VirtualBox](https://www.virtualbox.org/) en notant que [Vagrant supporte d'autres fournisseurs](https://www.vagrantup.com/docs/providers).

**Démonstration!** (en espérant que votre proxy de malheur m'épargne l'effet démo)

> La découverte de la plupart des outils de ce cours sera plus simple sur une machine perso. connectée à internet via une box standard.

---

## La création des VM (4/4)

### Vagrant (2/2)

Nous soulignerons que :

* La principale difficulté traitée dans ce dépôt est l'utilisation optionnelle d'un proxy sortant avec le plugin [vagrant-proxyconf](https://rubygems.org/gems/vagrant-proxyconf/versions/1.5.2).
* Vous pourrez initialiser vos propre `Vagrantfile` en suivant [Vagrant - getting started](https://learn.hashicorp.com/collections/vagrant/getting-started) :

```bash
vagrant init ubuntu/focal64
vagrant up
```
* Vous trouverez de nombreux tutorials et [cheat sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4#file-vagrant-cheat-sheet-md) en ligne pour utiliser cet outil.
* Vagrant est aussi pratique pour créer une VM de DEV Linux avec un environnement graphique (`apt-get install ubuntu-desktop`)

---

## Le déploiement de l'application

### Les outils de gestion de configuration

Nous avons le choix entre plusieurs solutions de **gestion de configuration** :

* [Chef](https://docs.chef.io/platform_overview/)
* [Puppet](https://puppet.com/docs/puppet/6/puppet_overview.html)
* [Ansible](https://docs.ansible.com/ansible/latest/index.html)

---

## Le déploiement de l'application

### Le choix d'Ansible

Nous allons nous appuyer sur Ansible qui est une solution :

* [Libre, OpenSource et référencée dans le SILL (1)](https://sill.etalab.gouv.fr/software?name=Ansible)
* Basée sur l'utilisation du format YAML
* Implétentée en Python
* N'imposant pas un serveur de contrôle
* Permettant l'utilisation d'un serveur de contrôle ([AWX](https://github.com/ansible/awx#readme) par exemple).

> (1) [Socle interministériel de logiciels libres](https://sill.etalab.gouv.fr/software) où je ne retrouve plus chef et puppet un temps référencés (changement de licence?).

---

## Le déploiement de l'application

### Les principaux exécutables d'Ansible

Nous trouverons plusieurs exécutable avec Ansible :

* `ansible` qui permettra par exemple de lancer une commande sur les machines d'un inventaire
* `ansible-playbook` qui sera utilisée pour traiter un ensemble de tâches décrites au format YAML.
* `ansible-vault` qui permettra de chiffrer des secrets
* `ansible-galaxy` qui permettra de télécharger des rôles partagés pour construire vos playbooks (voir [galaxy.ansible.com](https://galaxy.ansible.com/))

---

## Le déploiement de l'application

### Le déploiement de GeoStack avec Ansible!

Présenter proprement l'ensemble des [concepts ansible](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#basic-concepts) demanderait plusieurs séances.

Nous allons ici nous contenter d'une démonstration de l'utilisation de PostgreSQL et GeoServer avec cet outils :

**TODO : liens vers geostack-deploy/ansible**

---

## Le déploiement de l'application

**TODO**

* Configurer un pare-feu (sensibilisation avec [www.shodan.io](https://www.shodan.io/))
* Configurer un reverse proxy (ex : nginx)
* Mettre en oeuvre HTTPS (letsencrypt, blinder la configuration TLS : https://www.ssllabs.com/ssltest/,...)
* Blinder la configuration des VM (parenthèse DevSecOps avec https://dev-sec.io/baselines/linux/ )
* ...


---

## L'incontournable zone d'hébergement

TODO : présenter l'architecture classique d'une zone d'hébergement IaaS :

* Bastion SSH
* Reverse Proxy / Load Balancer communs aux applications
* Services supports
* Puits de logs
* Système de supervision


