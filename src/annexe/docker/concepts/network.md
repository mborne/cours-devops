
# Docker - Les réseaux

## Principe

Les réseaux docker sont fonctionnellement équivalents à des réseaux privés.

## Points clés

* Docker définit plusieurs réseaux par défaut :
  * `bridge` qui est un réseau virtuel créé par docker et **utilisé par défaut avec `docker run`** (voir `docker0` dans `ip link`)
  * `host` qui permet de désactiver l'isolation réseau
  * `none` qui permet de désactiver le réseau
* Docker permet la création de nouveaux réseaux (ex : `docker create network devbox`)
* Docker fonctionne avec un **modèle d'isolation par défaut** (**deux conteneurs doivent partager un même réseau pour communiquer entre eux**)
* Un conteneur peut être attaché à un ou plusieurs réseaux (ex : `docker run --network devbox ...`)
* Un serveur DNS est intégré à docker (`ping db` fonctionnera depuis `app` sur un même réseau)
* Il existe un [driver réseau overlay](https://docs.docker.com/network/overlay/) lié à [Swarm](https://docs.docker.com/engine/swarm/) qui permet la communication entre conteneurs sur plusieurs hôtes.

## Quelques commandes

* [docker network ls](https://docs.docker.com/engine/reference/commandline/network_ls/) pour lister les réseaux.
* [docker network create](https://docs.docker.com/engine/reference/commandline/network_create/) pour créer un réseau.
* [docker network inspect](https://docs.docker.com/engine/reference/commandline/network_inspect/) pour récupérer des informations détaillées sur un réseau.
* [docker network rm](https://docs.docker.com/engine/reference/commandline/network_rm/) pour supprimer un réseau.
* `docker run --network` pour connecter un conteneur à un réseau (par défaut `bridge`).

## Ressources

* [docs.docker.com - Networking overview](https://docs.docker.com/network/)
