# Résoudre les problèmes fréquents avec docker

Quelques notes pour aider à résoudre les problèmes classiques rencontrés par les débutants :

[[toc]]

## Utilisation d'un proxy sortant

Si vous devez utiliser un proxy pour accéder à internet, vous rencontrerez sûrement des problèmes avec :

* La commande `docker pull`
* Les commandes `RUN apt-get update && apt-get install` dans vos `Dockerfile`
* L'accès aux ressources internet depuis vos conteneurs.

Voir [Travailler derrière un proxy avec Docker](../proxy-sortant/proxy-docker.md).

## Configuration de l'utilisation d'un serveur DNS particulier

Si docker ne parvient pas à résoudre des noms de domaine, il est fort probable que ce soit un problème de configuration DNS :

* Adaptez ce qui suit dans `/etc/docker/daemon.json` :

```json
{
   "dns": ["8.8.8.8","8.8.4.4"]
}
```

* Redémarrer le démon docker (`sudo service docker restart`)

## Utilisation d'un dépôt d'image en HTTP

Si vous avez un dépôt d'images privé qui n'utilise pas https (ex : http://localhost:5000 démarré avec [registry:2](https://hub.docker.com/_/registry) pour tester la publication d'image), docker refusera de puller les images :

* Déclarer ce dépôt dans `/etc/docker/daemon.json` :

```json
{
   "insecure-registry":["localhost:5000"]
}
```

* Redémarrer le démon docker (`sudo service docker restart`)

