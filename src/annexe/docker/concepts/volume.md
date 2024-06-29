
# Docker - les volumes

## Principe

Les volumes docker permettent de réaliser des montages dans les conteneurs. L'utilisation de ces derniers est fondamentale pour **externaliser les données des conteneurs afin que celles-ci survivent à la recréation des conteneurs**.

## Volume nommé et volume mappé

Nous soulignerons l'existence de **volumes nommés** (`docker run -v <volume-name>:/data`) et de **volumes mappés** (`docker run -v /path/on/host:/data`).

Nous préfèrerons l'utilisation de volumes nommés en notant **une différence de comportement au lancement d'un conteneur** :

* Le contenu d'**un volume nommé est initialisé à partir du contenu de l'image**
* Le contenu d'**un volume mappé est initialisé à vide**

## Quelques commandes

* [docker volume ls](https://docs.docker.com/engine/reference/commandline/volume_ls/) pour **lister les volumes**
* [docker volume create](https://docs.docker.com/engine/reference/commandline/volume_create/) pour **créer un volume**
* [docker volume inspect](https://docs.docker.com/engine/reference/commandline/volume_inspect/) pour **récupérer des informations détaillées sur un volume** (dont le chemin de stockage effectif)
* [docker volume rm](https://docs.docker.com/engine/reference/commandline/volume_rm/) pour **supprimer un volume**
* `docker run -v ` pour monter un volume dans un conteneur


## Ressources

* [docs.docker.com - Volumes](https://docs.docker.com/storage/volumes/)
  * [Back up, restore, or migrate data volumes](https://docs.docker.com/storage/volumes/#back-up-restore-or-migrate-data-volumes)
  * [Create a service which creates an NFS volume](https://docs.docker.com/storage/volumes/#create-a-service-which-creates-an-nfs-volume)
  * [Create CIFS/Samba volumes](https://docs.docker.com/storage/volumes/#create-cifssamba-volumes)

