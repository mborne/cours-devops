# IaC - Cohabitation des automatismes de gestion de configuration

## Contexte

Il peut arriver que plusieurs équipes cohabitent sur le système. Par exemple :

* Une équipe infrastructure en charge de l'automatisation de la mise à jour des systèmes.
* Une équipe projet en charge du déploiement des applicatifs.

## Exemple de problème de cohabitation

* L'équipe projet définit un fichier `/etc/apt/sources.list.d/nodejs.list` spécifiant la source logicielle pour l'installation de NodeJS dans une version précise (ex : `deb http://miroir/deb.nodesource.com/node_16.x/ bionic main`)
* L'équipe d'infrastructure vide `/etc/apt/sources.list.d/*` avant de lancer la mise à jour système en imposant une gestion par ticket du contenu.

## Impact

Une montée en version de NodeJS ne pourra se faire sans une intervention humaine de l'équipe d'infrastructure.

Si une mise à jour de NodeJS est nécessaire pour un déploiement, **la durée du déploiement passera de quelques minutes à quelques semaines** car il faudra :

* Anticiper le temps de prise en charge du ticket.
* Trouver un accord avec l'équipe d'infrastructure sur une date pour réaliser la livraison en PRODUCTION.
* Potentiellement faire confirmer cette date par le client.

## Solution

En cas d'équipe multiple intervenant sur des VM, il convient de définir clairement les rôles :

* Les OPS gèrent `/etc/apt/sources.list`
* Les DEV gèrent des fichiers `/etc/apt/sources.list.d/{middleware}.list`.

Nous verrons que l'utilisation de conteneurs résoudra ce problème comme suit :

* Les OPS gèrent le moteur d'exécution des conteneurs.
* Les DEV incluent les middlewares (NodeJS, PHP,...) dans l'image du conteneur.
