# docker - construire une image à partir d'un Dockerfile

## Principe

La commande [docker build](https://docs.docker.com/engine/reference/commandline/build/) est utilisée pour construire une image à partir d'un fichier [Dockerfile](https://docs.docker.com/engine/reference/builder/).

## Quelques commandes utiles

| Commande                                               | Description                                                                                              |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| `docker build -t mon-application .`                    | Construction de l'image `mon-application` avec le dossier courant en contexte et le fichier `Dockerfile` |
| `docker build -t mon-application -f Dockerfile.centos` | Idem avec `Dockerfile.centos`                                                                            |
| `docker build --build-arg version=11 -t postgres:11 .` | Construction d'une image `postgres:11` avec un argument de construction                                  |

## Remarques

* Il est possible (et recommandé) d'exclure des fichiers à l'aide de `.dockerignore`
* Il est possible d'utiliser des arguments de construction (`ARG`) par exemple pour construire plusieurs versions avec un seul `Dockerfile`

