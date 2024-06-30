# Le proxy sortant

## Principe

Un **proxy sortant sert d'intermédiaire pour le traffic sortant d'une infrastructure**. Son utilisation sera fréquente pour **mettre en place un filtrage des accès à internet** depuis le réseau d'une entreprise, d'une école ou d'un hébergement sécurisé.

## Points clés

Avec certains pare-feux, il est possible de réaliser un filtrage par FQDN (nom de domaine). Toutefois, ce filtrage au niveau des pare-feux reste un filtrage par IP (ex : autoriser l'accès à https://ignf.github.io sans autoriser l'accès à https://mborme.github.io sera délicat).

L'utilisation d'un proxy offrira plus de souplesse et de finesse sur **la mise en oeuvre d'un filtrage par domaine** avec **deux approches possibles** :

* **Filtrage en liste blanche** (seuls les sites autorisés sont accessibles)
* **Filtrage en liste noire** (seuls les sites interdits sont bloqués)

En outre, le proxy sortant permettra de **tracer les accès à internet** et de **mettre en cache les téléchargements**.

## Problème

Les systèmes et navigateurs sont généralement configurés à l'aide d'un fichier `proxy.pac` qui est un script JavaScript indiquant s'il faut utiliser un proxy pour accéder à une ressource en fonction du nom de domaine ou de l'IP (voir [findproxyforurl.com - Example PAC File](https://findproxyforurl.com/example-pac-file/))

Toutefois, de nombreux outils utilisés en ligne de commande (`curl`, `vagrant`, `terraform`, `ansible`, `docker`...) et les bibliothèques de programmation réalisant des requêtes ne savent pas exploiter ce script `proxy.pac`.

## Solution

En fonction des cas, les fiches suivantes pourront vous aider à travailler derrière un proxy :

* [Configurer l'utilisation du proxy à l'aide de variables d'environnement](proxy-env-vars.md) qui couvrira de nombreux cas (curl, ansible, vagrant, terraform...)
* [Travailler derrière un proxy avec Docker](proxy-docker.md) qui traite le téléchargement, la construction et l'utilisation d'image en présence d'un proxy.


## Ressources

* [codes.gouv.fr - Socle Interministériel des Logiciels Libres - Squid](https://code.gouv.fr/sill/detail?name=Squid)
* [doc.ubuntu-fr.org - squid](https://doc.ubuntu-fr.org/squid)

