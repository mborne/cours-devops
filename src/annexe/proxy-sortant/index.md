# Le proxy sortant

## Principe

Un proxy sortant sert d'intermédiaire pour le traffic sortant d'une infrastructure. Son utilisation est fréquente en entreprise et dans les écoles car il permet de mettre en place un filtrage des accès à internet.

## Problème

Les systèmes et navigateurs sont généralement configurés à l'aide d'un fichier `proxy.pac` qui est un script JavaScript indiquant s'il faut utiliser un proxy pour accéder à une ressource en fonction du nom de domaine ou de l'IP.

Toutefois, de nombreux outils utilisés en ligne de commande (`curl`, `vagrant`, `terraform`, `ansible`, `docker`...) et les bibliothèques de programmation réalisant des requêtes ne savent pas exploiter ce script `proxy.pac`.

## Solution

Voir :

* [Configurer l'utilisation du proxy à l'aide de variables d'environnement](proxy-env-vars.md) qui couvrira de nombreux cas (curl, ansible, vagrant,...)
* [Travailler derrière un proxy avec Docker](proxy-docker.md) qui traite le téléchargement, la construction et l'utilisation d'image en présence d'un proxy.





