
# Docker - Les réseaux

## Principe

Les réseaux docker sont fonctionnellement équivalents à des réseaux privés.

## Points clés

* La présence de réseaux créés par défaut (`none`, `host` et `bridge`)
* La possibilité pour un conteneur d'accéder à un autre conteneur du même réseau par son nom (`ping db` fonctionnera depuis `app`)
* La définition du réseau via `docker run --network <network-name>` (par défaut : `bridge`)
* La présence de plusieurs drivers pour les réseaux, dont un driver [overlay](https://docs.docker.com/network/overlay/) permettant la communication entre conteneur sur plusieurs hôtes docker en mode swarm

## Quelques commandes

* [docker network ls](https://docs.docker.com/engine/reference/commandline/network_ls/) pour lister les réseaux
* [docker network create](https://docs.docker.com/engine/reference/commandline/network_create/) pour créer un réseau
* [docker network inspect](https://docs.docker.com/engine/reference/commandline/network_inspect/) pour récupérer des informations détaillées sur un réseau
* [docker network rm](https://docs.docker.com/engine/reference/commandline/network_rm/) pour supprimer un réseau
* `docker run --network` pour connecter un conteneur à un réseau (par défaut `bridge`)

## Configuration du démons

Les points suivants peuvent être configurés dans `/etc/docker/daemon.json` :

| Paramètre                | Description                                                                                                                                                                   | Exemple                                                                           |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `bip`                    | [La plage d'IP du réseau bridge par défaut](https://success.docker.com/article/how-do-i-configure-the-default-bridge-docker0-network-for-docker-engine-to-a-different-subnet) | `172.26.0.1/16`                                                                   |
| `"default-address-pools` | Les plages d'IP utilisées les autres réseaux docker                                                                                                                           | `[{"base": "172.80.0.0/16", "size": 24}, {"base": "172.90.0.0/16", "size": 24}` ] |

