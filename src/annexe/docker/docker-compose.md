# docker-compose - Orchestration des conteneurs sur une machine

## Principes

* Le fichier `docker-compose.yml` définit les services, volumes, réseaux, etc.
* Le démarrage des services est simplifié à l'aide de l'exécutable `docker-compose`

## Quelques commandes utiles

| Commande                                    | Description                                                             |
| ------------------------------------------- | ----------------------------------------------------------------------- |
| `docker-compose up`                         | Démarrer tous les services                                              |
| `docker-compose up -d`                      | Démarrer l'ensemble des services en mode détaché                        |
| `docker-compose up site`                    | Démarrer le service `site`                                              |
| `docker-compose up -d --scale site=2`       | Démarrer deux instances du service `site`                               |
| `docker-compose run mon-service /bin/bash`  | Démarrer un service avec une commande particulière                      |
| `docker-compose exec mon-service /bin/bash` | Démarrer un programme dans un conteneur existant (simule connexion SSH) |

## Partage de réseau entre plusieurs stacks

En l'absence de spécification, `docker-compose` définit un réseau spécifique chaque stack démarrée à l'aide de `docker compose up`. Il est toutefois possible de partager un même réseau en procédant comme suit :

* Créer un réseau partagé en amont du démarrage des stacks (ex : `docker network create devbox`)
* Définir ce réseau comme étant le réseau par défaut des stacks dans `docker-compose.yaml` :

```yaml
networks:
  default:
    external:
      name: devbox
```


## Resources

* [docs.docker.com - Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)
* [docs.docker.com - Compose file version 3 reference](https://docs.docker.com/compose/compose-file/#compose-file-structure-and-examples)


