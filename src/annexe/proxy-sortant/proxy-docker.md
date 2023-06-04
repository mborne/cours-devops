# Travailler derrière un proxy avec Docker

En présence d'un proxy sortant pour l'accès aux ressources internet, il convient de :

[[toc]]

## Configurer le démon pour télécharger les images en utilisant le proxy

> Symptôme : "`docker pull` ou `docker run` ne fonctionne pas sur ma machine!"

**ATTENTION** : La page [docs.docker.com - Configure the Docker client](https://docs.docker.com/network/proxy/#configure-the-docker-client) indique qu'il est possible de configurer le proxy au niveau de la configuration du client (`~/.docker/config.json`) mais cette approche a été testée sans succès.

La méthode suivante fonctionne :

* Créer un fichier `/etc/systemd/system/docker.service.d/http-proxy.conf` en adaptant le contenu suivant :

```ini
[Service]
Environment="HTTP_PROXY=http://proxy:3128"
Environment="HTTPS_PROXY=http://proxy:3128"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
```

* Vérifier que ̀`/etc/default/docker` n'efface pas ces variables en commentant les lignes correspondantes.

* Recharger la configuration du démon docker et le redémarrer :

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

* Tester avec par exemple `docker pull nginx`


## Construire les images en spécifiant le proxy avec des arguments de construction

> Symptôme : "`RUN apt-get update`, `RUN curl`,... ne fonctionnent pas dans mon Dockerfile"

Pour la construction, il est possible de faire suivre les variables d'environnement pour la construction comme suit : 

```bash
docker build --build-arg http_proxy --build-arg https_proxy ...
```

Avec un fichier `docker-compose.yaml`, nous trouverons l'équivalent suivant :

```yaml
services:
  api:
    # ...
    build:
      args:
        - http_proxy
        - https_proxy
    # ...
```

NB : Par rapport à l'approche consistant à utiliser `ENV HTTP_PROXY=...` dans les images, nous évitons ainsi de prédéfinir un proxy dans les images résultantes.

## Démarrer les conteneurs en spécifiant le proxy avec des variables d'environnement

> Symptôme : "Mon conteneur n'arrive pas à accéder à des ressources ou services sur internet"

Pour l'exécution, il est possible de définir le proxy à l'aide de variable d'environnement : 

```bash
docker run -e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTPS_PROXY ...
```

Avec un fichier `docker-compose.yaml`, nous trouverons l'équivalent suivant :

```yaml
services:
  api:
    # ...
    environment:
      - HTTP_PROXY=${HTTP_PROXY}
      - HTTPS_PROXY=${HTTPS_PROXY}
      - http_proxy=${HTTP_PROXY}
      - https_proxy=${HTTPS_PROXY}
    # ...
```

