# Helm - *The package manager for Kubernetes*

## Principe de fonctionnement

* [Helm](https://helm.sh/) génère et applique les manifests au format YAML
* Le langage de templating est [Go templating language](https://pkg.go.dev/text/template)

## Installation

* [helm.sh - Installing Helm - From Script](https://helm.sh/docs/intro/install/#from-script)
* [helm.sh - Installing Helm - From Apt (Debian/Ubuntu)](https://helm.sh/docs/intro/install/#from-apt-debianubuntu)

## Quelques dépôts

| NAME       | URL                                                                    |
| ---------- | ---------------------------------------------------------------------- |
| bitnami    | [https://charts.bitnami.com/bitnami/](https://bitnami.com/stacks/helm) |
| netdata    | https://netdata.github.io/helmchart/                                   |
| hashicorp  | https://helm.releases.hashicorp.com                                    |
| jenkins    | https://charts.jenkins.io                                              |
| opensearch | https://opensearch-project.github.io/helm-charts/                      |
| traefik    | https://helm.traefik.io/traefik                                        |

> Voir aussi [artifacthub.io](https://artifacthub.io/)

## Quelques commandes

* Ajouter les charts bitnami : `helm repo add bitnami https://charts.bitnami.com/bitnami`
* Mettre à jour les charts : `helm repo update`
* Récupérer les valeurs possibles pour bitnami/postgresql : `helm show values bitnami/postgresql`
* Installer un chart : `helm -n=jenkins-system install jenkins jenkins/jenkins`
* Mettre à jour un chart : `helm -n=jenkins-system upgrade jenkins jenkins/jenkins`
* Installer ou mettre à jour un chart : `helm -n=jenkins-system upgrade --install jenkins jenkins/jenkins`
* Prévisualiser les fichiers YAML : `helm template jenkins jenkins/jenkins` (ou `--dry-run` sur install/upgrade)

## Quelques exemples d'utilisation

### Déploiement de Jenkins

```bash
# Ajout du dépôt jenkins
helm repo add jenkins https://charts.jenkins.io
# Mise à jour des dépôts
helm repo update
# Création d'un namespace d'accueil
kubectl create namespace jenkins-system
# Installation ou mise à jour
helm --namespace=jenkins-system upgrade --install jenkins jenkins/jenkins
```

### Déploiement de PostgreSQL


```bash
# Ajout du dépot bitnami
helm repo add bitnami https://charts.bitnami.com/bitnami
# Mise à jour des dépôts
helm repo update
# Création d'un namespace d'accueil pg
kubectl create namespace pg
# Installation ou mise à jour
POSTGRESQL_PASSWORD=ChangeIt
helm --namespace=pg upgrade --install postgresql bitnami/postgresql  --set global.postgresql.auth.postgresPassword=$POSTGRESQL_PASSWORD
# Contrôler l'état
kubectl -n pg get sts,svc,pods
# Suivre les instructions pour se connecter :
kubectl port-forward --namespace pg svc/postgresql 15432:5432 &
psql --host 127.0.0.1 -U postgres -d postgres -p 15432 -W
```

Voir :

* [PostgreSQL packaged by Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#readme)
* [bitnami/postgresql/values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml)

## Création d'un chart

La commande `helm create whoami` génère un modèle de chart pour le déploiement d'une application (nginx) qu'il sera possible d'adapter pour sa propre application.

Pour vos premiers pas, noter que :

* Les variables d'environnement sont toujours des strings (il faudra les échapper comme suit `{{ .Values.database.port | quote }}`)
* Les variables `global` sont accessibles depuis tous les sous charts

## Ressources

* [helm.sh - Installing Helm](https://helm.sh/docs/intro/install/)
* [helm.sh - The Chart Best Practices Guide](https://helm.sh/docs/chart_best_practices/)
* [hub.docker.com - alpine/helm](https://hub.docker.com/r/alpine/helm)
* [github.com - mborne/docker-devbox](https://github.com/mborne/docker-devbox#readme) où de nombreux scripts `k8s-install.sh` s'appuient sur des déploiements Helm.
* [github.com - mborne/helm-charts](https://github.com/mborne/helm-charts#helm-charts) quelques charts helm développer pour comprendre les mécanismes de publication sous forme d'image docker avec GitHub Container Registry (ex : `oci://ghcr.io/mborne/helm-charts/postgres-dev`)

