# DevOps avec Kubernetes

* Introduction
* Principe de fonctionnement
* Découvrir Kubernetes par la pratique
* Les principaux concepts
* Le dashboard Kubernetes
* L'orchestration du déploiement
* Utilisation d'un cluster managé

---

## L'orchestration de conteneurs

### Introduction

Il existe plusieurs solutions d'**orchestration de conteneurs** permettant :

* L'automatisation de la gestion des conteneurs (ex : redémarrage en cas de problème)
* L'automatisation des **déploiements sans interruption**.
* La **mise en réseau** des conteneurs pour l'**exécution sur plusieurs hôtes**.
* L'automatisation de la **mise à l'échelle**.

---

## Introduction

### Swarm

Nous soulignerons l'existence de la solution d'orchestration [swarm](https://docs.docker.com/engine/swarm/) qui est intégrée à docker et qui permettrait par exemple de :

* [Créer un cluster avec les machines vagrantbox](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/)
* [Déployer GeoStack sous forme d'un service sur ce cluster](https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/)

Nous noterons que le développement de swarm à amené à l'ajout d'un réseau de type "overlay" permettant la communication des conteneurs entre plusieurs machines (`docker network create --driver overlay geostack`)

---

## Introduction

### Kubernetes

Pour ce cours, nous allons plutôt faire un survol de **Kubernetes** qui est une référence en la matière et qui bénéficie d'un riche écosystème incluant des **solutions de plus haut niveau d'abstraction** qui ne seront pas présentées en détail dans ce cours :

* [KNative - Serverless and Event Driven Applications](https://knative.dev/docs/)
* [OpenFaaS - Serverless Functions, Made Simple](https://www.openfaas.com/)


---

## Principe de fonctionnement

### L'API de Kubernetes (1/2)

Kubernetes met à disposition une [API de contrôle de l'exécution des conteneurs à l'échelle d'un cluster](https://kubernetes.io/docs/concepts/overview/components/) avec :

* Une **approche déclarative** où l'utilisateur spécifie les **objets** à créer en YAML (ou JSON)
* Des **concepts plus riches et plus nombreux** que l'API docker

Nous verrons que cette API est centrale dans l'écosystème Kubernetes :

* Elle donne un cadre pour **l'authentification** et **la gestion des droits** (RBAC).
* Elle permet l'**introspection** et la **réflexion** (découverte de configuration, opérateurs en charge de déployer des applications,...)
* Elle est **extensible** (les applications peuvent définir leurs propres types d'objet)

---

## Principe de fonctionnement

### L'API de Kubernetes (2/2)

Cette API sera centrale pour l'administration d'un cluster Kubernetes. Le client [kubectl](https://kubernetes.io/docs/reference/kubectl/) permettra de communiquer avec elle :

<div class="center">
    <img src="img/admin-vm-vs-k8s.drawio.png" alt="Administration VM vs K8S" style="height: 300px" />
</div>

Nous remarquerons qu'il sera possible de distinguer les objets gérés par les **administrateurs du cluster** et ceux gérés par les **administrateurs des applications**.

---

## Principe de fonctionnement

### Le plan de contrôle et les noeuds

Le **plan de contrôle** (*control-plane*) hébergera les composants relatifs à la gestion du cluster dont :

* L'API Kubernetes (`kube-apiserver`)
* La base de données clé/valeur de l'API (`etcd`)

En production, les conteneurs applicatifs s'exécuteront sur des **noeuds** (`nodes`) distinct de ceux hébergeant le plan de contrôle.

> Voir [kubernetes.io - Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/) pour un schéma d'architecture et des explications plus détaillées.

---

## Principe de fonctionnement

### Un modèle réseau ouvert par défaut

Avec docker, pour que deux conteneurs puissent communiquer, il faut s'assurer qu'ils partagent le même réseau.

Avec Kubernetes, nous aurons :

* Un **modèle réseau permettant par défaut la communication au sein du cluster**
* La **possibilité de restreindre les communications réseaux** avec un concept dédié que nous n'aborderons pas dans cette introduction : [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

> Voir [kubernetes.io - The Kubernetes network model](https://kubernetes.io/docs/concepts/services-networking/#the-kubernetes-network-model) et [youtube.com - Understanding Kubernetes Networking. Part 2: POD Network, CNI, and Flannel CNI Plug-in](https://www.youtube.com/watch?v=U35C0EPSwoY) pour des explications plus détaillées.

---

## Découvrir Kubernetes par la pratique

### Installation du client

Pour communiquer avec un cluster, nous installerons le client [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) qui nous permettra de communiquer avec l'API Kubernetes en ligne de commande. 

---

## Découvrir Kubernetes par la pratique

### Création d'un cluster de développement

Nous noterons qu'il existe différents outils permettant d'installer un environnement de développement Kubernetes pour découvrir les concepts par la pratique :

* [K3S](https://k3s.io/) de Rancher.
* [Kind (Kubernetes in docker)](https://kind.sigs.k8s.io/)
* [MicroK8S](https://microk8s.io/) de Canonical (Ubuntu).
* [Minikube](https://kubernetes.io/fr/docs/setup/learning-environment/minikube/)

Nous tenterons l'installation de K3S avec Ansible sur les VM vagrantbox à l'aide du dépôt [mborne/k3s-deploy](https://github.com/mborne/k3s-deploy#k3s-deploy).

> Vous trouverez aussi [un utilitaire pour installer Kind dans mborne/docker-devbox](https://github.com/mborne/docker-devbox/tree/master/kind#kind-kubernetes-in-docker). L'installation demandera moins de travail pour des tests simples, mais il sera plus difficile de comprendre le fonctionnement de Kubernetes et les choses se compliqueront pour tester certaines fonctionnalités (LoadBalancer et Ingress en particulier).

---

## Découvrir Kubernetes par la pratique

### Lister les noeuds

En premier contact, nous allons nous assurer que `kubectl` est correctement configuré (`export KUBECONFIG=chemin/vers/kubeconfig`) et **lister les noeuds** à l'aide des commandes suivantes :

```bash
# Information sur le cluster
kubectl cluster-info
# Lister les noeuds
kubectl get nodes
```

---

## Les principaux concepts

### Les Pods

Les [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) sont la plus petite unité d'exécution gérée par Kubernetes. Ils sont porteurs des spécifications pour l'exécution d'un ou plusieurs conteneurs qui partageront :

* Le même réseau (communication en localhost)
* Le même stockage (partage de l'accès aux volumes)

Pour découvrir ce concept, nous traiterons [mborne/k8s-exemples - Création d'un Pod avec un conteneur nginx](https://github.com/mborne/k8s-exemples#k8s-exemples). Nous ne détaillerons pas les cas d'utilisations des Pod avec plusieurs conteneurs (sidecar, ambassador, )

---

## Les principaux concepts

### Les charges de travail

En pratique, les [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) ne seront pas créés manuellement. Nous utiliserons des [charge de travail (*workloads*)](https://kubernetes.io/docs/concepts/workloads/) adaptées à la nature de l'application pour créer les Pods :

* Un [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) pour un service sans état (ex : nginx)
* Un [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) dans le cas contraire (ex : PostgreSQL)
* Un [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) dans le cas où ils doivent s'exécuter sur tous les noeuds (ex : fluent-bit pour la collecte des logs)

Nous soulignerons aussi la possibilité de définir :

* Des [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) pour des tâches ponctuelles.
* Des [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cronjob/) pour des tâches périodiques.

> Nous traiterons [mborne/k8s-exemples - Création de plusieurs Pod whoami à l'aide d'un Deployment](https://github.com/mborne/k8s-exemples#k8s-exemples).

---

## Les principaux concepts

### Le concept de Service

En première approche, un [Service](https://kubernetes.io/docs/concepts/services-networking/service/) pourra être vu comme un reverse proxy devant les Pods.

Nous soulignerons qu'il existe plusieurs types de service dont :

* `ClusterIP` (type par défaut) rendant le service accessible dans le cluster
* `NodePort` permettant l'exposition via un port sur un noeud (**à éviter**)
* `LoadBalancer` permettant de demander l'exposition sur une IP publique.

> Nous traiterons [mborne/k8s-exemples - Création d'un service whoami devant ces Pods](https://github.com/mborne/k8s-exemples#k8s-exemples).

---

## Les principaux concepts

### Le concept de Namespace

Nous trouverons avec Kubernetes un concept de [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) permettant d'isoler les ressources des différentes applications hébergées dans le cluster.

Ce concept permettra l'accueil de plusieurs applications dans un même cluster.

> Nous traiterons [mborne/k8s-exemples - Namespace](https://github.com/mborne/k8s-exemples#namespaces) pour inspecter les différents namespaces (dont "default" dans lequel nous travaillons sans le préciser) et verrons comment créer et utiliser un namespace "whoami" dédié.


---

## Les principaux concepts

### Le concept Ingress

Le concept [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) permet d'exposer un service en HTTP/HTTPS.

Nous noterons que :

* L'exposition des ressources [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) sera prise en charge par un contrôleur Ingress (ex : [nginx-ingress-controller](https://github.com/mborne/docker-devbox/blob/master/nginx-ingress-controller/README.md), [Traefik](https://github.com/mborne/docker-devbox/tree/master/traefik#usage-with-kubernetes),...)
* Le choix du contrôleur ingress passera par la définition de la propriété `ingressClass` (ex : `nginx`, `traefik`,... avec la possibilité de distinguer `nginx-private` et `nginx-public`)

> Nous traiterons l'installation d'un contrôleur ingress à l'aide de [mborne/docker-devbox - traefik](https://github.com/mborne/docker-devbox/tree/master/traefik#usage-with-kubernetes) et l'exposition du service whoami sous forme d'une URL. Nous serons amené à [installer helm](annexe/kubernetes/helm.html) et expliquer brièvement son intérêt.

---

## Les principaux concepts

### La configuration

Nous trouverons plusieurs concepts relatif à la [gestion de la configuration](https://kubernetes.io/docs/concepts/configuration/) dont :

* [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
* [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)

Ces éléments pourront être convertis en **variables d'environnement** ou monté sous forme de **fichiers** au niveau des conteneurs.

> Nous manipulerons ces deux concepts pour stocker des paramètres et injecter les variables d'environnement correspondantes dans les Pod d'un déploiement.

---

## Les principaux concepts

### Les concepts pour le stockage (1/3)

Nous noterons que Kubernetes dispose d'un mécanisme de plugin permettant de supporter différentes solutions de stockage (c.f. [kubernetes-csi.github.io - CSI Drivers](https://kubernetes-csi.github.io/docs/drivers.html))

Nous retrouverons le concept de [Volume](https://kubernetes.io/docs/concepts/storage/volumes/) repris à Docker avec une distinction entre :

* [Les volumes persistants (PersistentVolume)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Les volumes éphémères](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/) (ex : [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir))

---

## Les principaux concepts

### Les concepts pour le stockage (2/3)

Pour le [provisionnement des volumes persistant (PersistentVolume)](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/), nous trouverons deux concepts intéressants :

* Le concept de **PersistentVolumeClaim** correspondant à la **commande d'un volume persistant** pour une application.
* Le concept de [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/) permettant de répondre avec deux cas de figure :
  * La création du *PersistentVolume* correspondant par un administrateur du cluster (**provisionnement statique**)
  * La création automatique du *PersistentVolume* via l'utilisation d'une classe de stockage prévue à cet effet (**provisionnement dynamique**)

> Il sera intéressant d'exécuter `kubectl get storageclass` pour lister les possibilités dans un cluster.


---

## Les principaux concepts

### Les concepts pour le stockage (3/3)

Nous soulignerons que tous les types de stockage n'offrent pas les mêmes possibilités.

A ce titre, Kubernetes distinguera plusieurs **modes d'accès**, par exemple :

* **ReadWriteOnce** indiquant que le volume peut être utilisé en lecture/écriture par des Pods s'exécutant sur un même noeud.
* **ReadWriteMany** dans le cas où les Pods s'exécutent sur plusieurs noeuds.

Nous noterons que ce deuxième mode de stockage ne sera pas toujours disponibles en standard (il faudra par exemple s'appuyer un stockage de fichier en réseau avec le protocole NFS).

En règle générale, il sera préférable de ne pas y avoir recours à un stockage **ReadWriteMany** pour des raisons de performance et de coût (mais se libérer de cette contrainte peu demander des efforts de refonte importants des traitements).

---

## Le dashboard Kubernetes

A l'aide de [mborne/docker-devbox - kubernetes-dashboard](https://github.com/mborne/docker-devbox/blob/master/kubernetes-dashboard/README.md#kubernetes-dashboard), nous installerons une interface graphique pour la manipulation du cluster.

Nous lirons ensemble les fichiers YAML correspondant à ce déploiement pour survoler des concepts non abordés jusqu'ici (ServiceAccount, RBAC,...)

---

## L'orchestration du déploiement

### Exemple avec ArgoCD

Afin d'avoir un aperçu de l'utilisation d'un orchestrateur de déploiement utilisant une approche GitOps, nous installerons [ArgoCD à l'aide de mborne/docker-devbox - argocd](https://github.com/mborne/docker-devbox/tree/master/argocd#argo-cd).

Nous reprendrons le déploiement de whoami à l'aide de ArgoCD.

---

## Utilisation d'un cluster managé

Si le temps le permet, nous nous appuierons sur le dépôt [mborne/gke-playground](https://github.com/mborne/gke-playground#gke-playground) pour inspecter la solution Google Kubernetes Engine (GKE) où nous trouverons plusieurs éléments pré-configurés :

* L'authentification basée sur l'IAM
* La récupération des logs
* La récupération des métriques systèmes
