# L'orchestration de conteneur avec Kubernetes

### Introduction

Pour répondre **permettre l'exécution de conteneur sur plusieurs hôtes**, nous trouverons des **orchestrateurs de conteneurs**. Il en existe plusieurs, dont [swarm](https://docs.docker.com/engine/swarm/) qui est intégrée à docker et qui permettrait par exemple de :

* [Créer un cluster entre les machines vagrantbox-1; vagrantbox-2 et vagrantbox-3](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/)
* [Déployer GeoStack sous forme d'un service sur ce cluster](https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/) (1)

Nous allons nous concentrer sur une solution plus riche : **Kubernetes**.

> Le développement de swarm à amené à l'ajout d'un driver réseau "overlay" permettant la communication des conteneurs entre plusieurs machines (`docker network create --driver overlay geostack`)

---

## L'orchestration de conteneur

### Kubernetes

Nous ne pourrons pas rentrer dans les détails, mais nous soulignerons que Kubernetes amène une [API de contrôle de l'exécution des conteneurs à l'échelle d'un cluster](https://container.training/kube-selfpaced.yml.html#85).

* Une **API avec une approche déclarative** (on spécifie en YAML le nombre de conteneurs attendus, Kubernetes se charge de les démarrer)
* Une architecture réseau permettant par défaut la communication entre les conteneurs :
  * Un réseau de type overlay est présent à l'échelle du cluster
  * Il n'est plus nécessaire de partager explicitement des réseaux

---

## L'orchestration de conteneur

### Kubernetes

Nous soulignerons que Kubernetes amène :

* Une [API riche en concepts](https://kubernetes.io/docs/concepts/)
* Une API extensible permettant l'introspection (utilisée par [traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/) cette fois à l'échelle d'un cluster)
* Une API permettant la réflexion qui peut être illustrée par :
  * [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) qui se charge de déployer les autres applications au sein d'un cluster Kubernetes.
  * [zalando/postgres-operator](https://github.com/zalando/postgres-operator#getting-started) qui se charge de gérer un cluster PostgreSQL dans Kubernetes.

Dans le cadre de ce cours, nous remarquerons que l'API Kubernetes permet de **séparer les responsabilités entre les DEV et les OPS**.
