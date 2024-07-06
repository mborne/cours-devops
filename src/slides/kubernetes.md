# DevOps avec Kubernetes

* Introduction
* Principe de fonctionnement
* Découvrir Kubernetes par la pratique
* Les principaux concepts
* Le dashboard Kubernetes
* L'observabilité
* L'orchestration du déploiement
* Intérêt de Kubernetes
* Que manque-t'il à ce stade?

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

Nous soulignerons l'existence de la solution d'orchestration [Swarm](https://docs.docker.com/engine/swarm/) qui est intégrée à docker et qui permettrait par exemple de :

* [Créer un cluster avec les machines vagrantbox](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/)
* [Déployer GeoStack sous forme d'un service sur ce cluster](https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/)

Nous noterons que le développement de [Swarm](https://docs.docker.com/engine/swarm/) a principalement amené l'ajout d'un réseau de type "overlay" à Docker pour la communication des conteneurs entre plusieurs machines.

---

## Introduction

### Kubernetes

Pour ce cours, nous allons plutôt nous concentrer sur **Kubernetes** qui est une référence en matière d'orchestration de conteneurs et qui bénéficie d'un riche écosystème incluant des **solutions de plus haut niveau d'abstraction** ("serverless") qui ne seront pas présentées dans ce cours :

* [KNative - Serverless and Event Driven Applications](https://knative.dev/docs/)
* [OpenFaaS - Serverless Functions, Made Simple](https://www.openfaas.com/)


---

## Principe de fonctionnement

### L'API de Kubernetes (1/2)

Kubernetes met à disposition une [API de contrôle de l'exécution des conteneurs à l'échelle d'un cluster](https://kubernetes.io/docs/concepts/overview/components/) avec :

* Une **approche déclarative** où l'utilisateur spécifie les **objets** à créer en YAML (ou JSON)
* Des **concepts plus riches et plus nombreux** que l'API docker

Nous verrons que **cette API est centrale dans l'écosystème Kubernetes** :

* Elle donne un cadre pour **l'authentification** et **la gestion des droits** (RBAC).
* Elle permet l'**introspection** et la **réflexion** (découverte de configuration, opérateurs en charge de déployer des applications,...)
* Elle est **extensible** (les applications peuvent définir leurs propres types d'objet)

---

## Principe de fonctionnement

### L'API de Kubernetes (2/2)

Cette API sera centrale pour l'administration d'un cluster Kubernetes. Le client [kubectl](https://kubernetes.io/docs/reference/kubectl/) permettra de communiquer avec elle :

<div class="center">
    <img src="img/admin-vm-vs-k8s.drawio.png" alt="Administration VM vs K8S" style="height: 240px" />
</div>

A l'aide des mécanismes de gestion de droits sur cette API REST, il sera possible de distinguer les objets gérés par les **administrateurs du cluster** de ceux gérés par les **administrateurs des applications métiers**.

---

## Principe de fonctionnement

### Le plan de contrôle et les noeuds

Le **plan de contrôle** (*control-plane*) héberge les composants relatifs à la gestion du cluster dont :

* L'API Kubernetes (`kube-apiserver`)
* La base de données clé/valeur de l'API (`etcd`)

En production, les conteneurs applicatifs s'exécuteront sur des **noeuds** (`nodes`) distincts de ceux hébergeant les composants du plan de contrôle.

> Voir [kubernetes.io - Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/) pour un schéma d'architecture et des explications plus détaillées.

---

## Principe de fonctionnement

### Un modèle réseau ouvert par défaut

Avec docker, pour que deux conteneurs puissent communiquer, il faut s'assurer qu'ils partagent le même réseau.

Avec Kubernetes, nous aurons :

* Un **modèle réseau ouvert par défaut** pour la communication au sein du cluster.
* La **possibilité de restreindre les communications réseaux** avec un concept dédié : [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

Dans ce cours, nous nous limiterons à noter que **l'utilisation d'un pare-feu classique ne permettra pas de maîtriser finement les flux réseaux** (1).

> (1) Un pare-feu externe au cluster ne verra que les IP des noeuds, il ne sera pas possible de raisonner à l'échelle des services pour imposer par exemple l'utilisation d'un proxy sortant.
> 
> Voir [kubernetes.io - The Kubernetes network model](https://kubernetes.io/docs/concepts/services-networking/#the-kubernetes-network-model) et [youtube.com - Understanding Kubernetes Networking. Part 2: POD Network, CNI, and Flannel CNI Plug-in](https://www.youtube.com/watch?v=U35C0EPSwoY) pour des explications plus détaillées.

---

## Découvrir Kubernetes par la pratique

### Installation du client

Pour communiquer avec un cluster, nous installerons le client [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) qui nous permettra de communiquer avec l'API Kubernetes en ligne de commande. 

---

## Découvrir Kubernetes par la pratique

### Création d'un cluster de développement

Il existe différents outils permettant d'installer un environnement de développement Kubernetes :

* [K3S](https://k3s.io/) de Rancher.
* [Kind (Kubernetes in docker)](https://kind.sigs.k8s.io/) (1)
* [MicroK8S](https://microk8s.io/) de Canonical (Ubuntu).
* [Minikube](https://kubernetes.io/fr/docs/setup/learning-environment/minikube/)

Nous traiterons l'**installation de K3S avec Ansible sur les VM vagrantbox** à l'aide du dépôt [mborne/k3s-deploy](https://github.com/mborne/k3s-deploy#k3s-deploy).

> (1) L'installation demande moins de travail mais il est plus difficile de comprendre le fonctionnement de Kubernetes. Aussi, les choses se compliquent pour tester certaines fonctionnalités (LoadBalancer et Ingress en particulier). Voir [mborne/docker-devbox - kind](https://github.com/mborne/docker-devbox/tree/master/kind#readme) après le cours.

---

## Découvrir Kubernetes par la pratique

### Lister les noeuds

En premier contact, nous pourrons :

* Configurer `kubectl` pour utiliser le cluster déployé sur les machines vagrantbox :

```bash
# Copier l'aide affichée par k3s-deploy :
export KUBECONFIG=/home/formation/k3s-deploy/.k3s/k3s.yaml
```

* Lister les noeuds à l'aide des commandes suivantes :

```bash
# Information sur le cluster
kubectl cluster-info
# Lister les noeuds
kubectl get nodes
```

---

## Découvrir Kubernetes par la pratique

### Et maintenant?

Nous allons maintenant pouvoir **découvrir progressivement les principaux concepts de Kubernetes à l'aide d'exemples**.

---

## Les principaux concepts

### Les Pods

Les [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) sont la plus petite unité d'exécution gérée par Kubernetes. Ils sont porteurs des spécifications pour l'exécution d'un ou plusieurs conteneurs qui partagent sur un même Pod :

* Le même réseau (communication en localhost)
* Le même stockage (accès aux volumes)

Nous traiterons les exemples [mborne/k8s-exemples - Pods](https://github.com/mborne/k8s-exemples#pod) en faisant le lien avec [les exemples de prise en main de docker](https://github.com/mborne/docker-exemples#readme) pour nous familiariser avec ce concept.

> Nous ne détaillerons pas les cas d'utilisations des Pod avec plusieurs conteneurs (sidecar, ambassador, adapter) et des conteneurs d'initialisation (ex : télécharger des données au démarrage, retarder le démarrage d'un service,...)

---

## Les principaux concepts

### Les charges de travail (1/2)

En pratique, les [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) ne sont pas créés manuellement. Nous définissons plutôt des [charges de travail (*workloads*)](https://kubernetes.io/docs/concepts/workloads/) adaptées à la nature de l'application pour créer les Pods :

* Un [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) pour un **service sans état** (ex : [whoami](schema/whoami-deployment.png))
* Un [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) pour **un service avec état** (ex : [PostgreSQL](schema/postgres-statefulset.png) où chaque Pod disposera de son propre stockage)
* Un [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) pour exécuter **un Pod par noeud** (ex : [fluent-bit](https://fluentbit.io/) pour la collecte des logs)

Nous traiterons le premier cas avec [mborne/k8s-exemples - Création de plusieurs Pod whoami à l'aide d'un Deployment](https://github.com/mborne/k8s-exemples#deployment).

---

## Les principaux concepts

### Les charges de travail (2/2)

En complément, nous soulignerons aussi la possibilité de définir :

* Des [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) pour des **tâches ponctuelles**.
* Des [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) pour des **tâches périodiques**.

Nous traiterons la [création d'un Job calculant 2000 décimales de PI](https://kubernetes.io/docs/concepts/workloads/controllers/job/).

---

## Les principaux concepts

### Le concept de Service (1/2)

En première approche, un [Service](https://kubernetes.io/docs/concepts/services-networking/service/) pourra être vu comme un reverse proxy devant les Pods :

<div class="center">
    <img src="schema/whoami-service.png" alt="Illustration du concept de service" style="height: 280px" />
</div>

Nous traiterons [mborne/k8s-exemples - Création d'un service whoami devant ces Pods](https://github.com/mborne/k8s-exemples#service) et constaterons qu'**un service offre un point d'accès stable à l'un des Pod** dans le cluster (ex : `http://whoami`)

---

## Les principaux concepts

### Le concept de Service (2/2)

Nous soulignerons qu'il existe [plusieurs types de services](https://kubernetes.io/fr/docs/concepts/services-networking/service/#publishing-services-service-types) dont :

* `ClusterIP` rendant le **service accessible dans le cluster** (type par défaut)
* `LoadBalancer` permettant de demander l'**exposition sur une IP publique**.
* `NodePort` permettant l'**exposition via un port sur un noeud (<u>à éviter</u>**)

Nous traiterons [mborne/k8s-exemples - Exposition du service whoami sur une IP publique](https://github.com/mborne/k8s-exemples#service) pour accéder au service depuis notre machine sur une IP publique en exploitant le type `LoadBalancer` (*).

> (*) K3S simulera la publication en exposant le service sur les machines vagrantbox. Dans d'autres contextes (ex : Google Kubernetes Engine), une IP publique serait affectée pour notre service avec routage du traffic vers le service Kubernetes.

---

## Les principaux concepts

### Le concept de Namespace

Les [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) permettent d'isoler des groupes de ressources définies dans un même cluster. Ils permettent d'héberger et de **cloisonner plusieurs applications dans un même cluster** (*Namespace as a service*).

Nous traiterons [mborne/k8s-exemples - Namespace](https://github.com/mborne/k8s-exemples#namespace) pour **inspecter les namespaces** existants dont :

* "default" dans lequel nous avons travaillé jusque là sans le préciser
* "kube-system" où nous trouverons un service assurant la résolution DNS (ex : pour l'appel à `http://whoami` testé précédemment)

Nous verrons **comment créer et utiliser un namespace dédié pour l'application whoami**.

---

## Les principaux concepts

### Le concept Ingress (1/3)

Le concept [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) permettra de **spécifier l'exposition d'un service en HTTP/HTTPS** :

<div class="center">
    <img src="schema/whoami-ingress.png" alt="Illustration du concept Ingress" style="height: 280px" />
</div>

---

## Les principaux concepts

### Le concept Ingress (2/3)

L'exposition des ressources [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) sera prise en charge par un [*Ingress Controller*](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) :

<div class="center">
    <img src="schema/traefik-ingress-controller.png" alt="Illustration de Traefik en tant qu'Ingress Controller" style="height: 280px" />
</div>

Nous trouverons [plusieurs implémentations](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/#additional-controllers) dont une implémentation [Traefik](https://github.com/mborne/docker-devbox/tree/master/traefik#usage-with-kubernetes) qui est installée par défault avec K3S (1).

> (1) A date, une option `--disable traefik` désactive cette fonctionnalité dans [mborne/k3s-deploy - inventory/vagrantbox/group_vars/k3s_master/k3s.yml](https://github.com/mborne/k3s-deploy/blob/master/inventory/vagrantbox/group_vars/k3s_master/k3s.yml)

---

## Les principaux concepts

### Le concept Ingress (3/3)

Nous traiterons [mborne/k8s-exemples - Ingress](https://github.com/mborne/k8s-exemples#ingress) où nous verrons comment :

* **Installer Traefik en tant que Ingress Controller**
* **Exposer le service whoami sous forme d'une URL**

En pré-requis, nous serons amené à [installer helm](annexe/kubernetes/helm.html) et expliquer brièvement son intérêt.

---

## Les principaux concepts

### Le stockage et les volumes

Nous retrouverons le concept de [Volume](https://kubernetes.io/docs/concepts/storage/volumes/) repris à Docker. Nous trouverons toutefois de nombreux concepts complémentaires permettant :

* Le support d'un plus **grand nombre de systèmes de stockage**.
* De mieux traiter **différents cas d'utilisation d'utilisation** avec une distinction entre :
  * [Les volumes persistants (PersistentVolume)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  * [Les volumes éphémères](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/) (ex : [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) pour un dossier de cache)
  * [Les volumes projetés](https://kubernetes.io/docs/concepts/storage/projected-volumes/) (ex : [configMap](https://kubernetes.io/docs/concepts/storage/volumes/#configmap) pour un fichier de configuration)

Nous survolerons l'annexe [Kubernetes - les volumes et le stockage](annexe/kubernetes/storage.md) pour constater que **Kubernetes offre de nombreuses possibilités en matière de stockage** mais que **c'est un sujet complexe**.

---

## Le dashboard Kubernetes

Nous remarquerons que l'équipe Kubernetes met à disposition une interface graphique plutôt complète : [Kubernetes Dashboard](https://github.com/kubernetes/dashboard#kubernetes-dashboard).

Nous pourrons l'installer à l'aide de [mborne/docker-devbox - kubernetes-dashboard](https://github.com/mborne/docker-devbox/blob/master/kubernetes-dashboard/README.md#kubernetes-dashboard).

---

## L'observabilité

Pour découvrir l'observabilité avec Kubernetes, nous pourrons nous appuyer sur [github.com - mborne/docker-devbox](https://github.com/mborne/docker-devbox) pour installer :

* [Prometheus](https://github.com/mborne/docker-devbox/tree/master/prometheus#usage-with-kubernetes) pour collecter des métriques système.
* [Loki](https://github.com/mborne/docker-devbox/tree/master/loki#usage-with-kubernetes) pour collecter les journaux applicatifs.
* [Grafana](https://github.com/mborne/docker-devbox/tree/master/grafana#usage-with-kubernetes) pour disposer d'une interface graphique de consultations des journaux et des métriques.

Nous remarquerons au passage que Grafana permet de gérer les dashboards as code ( [docker-devbox - grafana/helm/values.yaml](https://github.com/mborne/docker-devbox/blob/master/grafana/helm/values.yaml) ).

---

## L'orchestration du déploiement

### ArgoCD

Nous mentionnerons la possibilité d'utiliser [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) pour orchestrer les déploiements avec une approche GitOps.

Nous nous appuierons sur [mborne/docker-devbox - argocd](https://github.com/mborne/docker-devbox/tree/master/argocd#argo-cd) pour l'installer. Nous l'utiliserons pour déployer l'application [github.com - mborne/debug](https://github.com/mborne/debug) (déploiement de type [Kustomize](https://kustomize.io/) avec le dossier suivant : https://github.com/mborne/debug/tree/master/manifests)

---

## Intérêt de Kubernetes

### Un cadre standardisé pour la zone d'hébergement

En résumé, Kubernetes offre des **concepts pour chacun des éléments à configurer dans la zone d'hébergement** :

<div class="center">
    <img src="img/archi-hebergement-k8s.drawio.png" alt="Exemple d'architecture de zone d'hébergement K8S" style="height: 260px" />
</div>

Ces concepts permettent de **gérer as code** le **déploiement et la configuration des services techniques**, la **configuration du load-balancer (Ingress)**, la configuration du **pare-feu (NetworkPolicy)**,...

---

## Intérêt de Kubernetes

### Un cadre pour la création d'un écosystème

L'API extensible amène un cadre pour le développement d'outils réutilisables sur différentes instances Kubernetes :

* Prometheus / Grafana / Loki pour l'**observabilité**
* ArgoCD, GitLab-CI,... pour l'**orchestration des déploiements**
* cert-manager pour la **gestion des certificats**

Nous trouverons même des **opérateurs pour déployer des services tels PostgreSQL** avec une approche déclarative (ex : [CloudNativePG](https://cloudnative-pg.io/) permettant la définition d'un [postgis-cluster.yaml](https://github.com/mborne/docker-devbox/blob/master/cnpg/manifest/postgis-cluster.yaml)) .

---

## Que manque-t'il à ce stade?

### Kubernetes n'est pas une solution clé en main

A ce stade, nous soulignerons que **Kubernetes n'est pas une solution offrant une zone d'hébergement clé en main**. Il faudra par exemple **déployer, configurer et exploiter des services techniques** (ex : Ingress Controller, Prometheus, Grafana...).

Nous pourrons **limiter les efforts sur certains points avec des distributions plus riches** (ex : Rancher, VMWare Tanzu,...) ou en ayant recours à **Kubernetes en mode SaaS** (Managed Kubernetes Service chez OVH, Google Kubernetes Engine,...) mais :

* **Les efforts seront variables selon le choix** (ex : fluent-bit sera déployé automatiquement pour alimenter Google Cloud Logging avec GKE)
* **Il restera toujours des choix à faire en matière de gestion des droits** (ex : sur quel environnement donner des droits aux DEV?), des **utilisateurs à gérer** et **un système et des coûts à surveiller**.

---

## Que manque-t'il à ce stade?

### Sécuriser l'exécution des conteneurs n'est pas trivial

Pour sécuriser l'exécution des conteneurs, il nous resterait par exemple à [configurer des options de sécurité sur les conteneurs](https://kubernetes.io/docs/concepts/security/pod-security-standards/). Par exemple :

```yaml
securityContext:
  allowPrivilegeEscalation: false
  privileged: false
  runAsUser: 1000
  runAsNonRoot: true
  capabilities:
    drop:
      - ALL
  seccompProfile:
    type: RuntimeDefault
```

Or, l'activation de certaines options n'est pas indolore au niveau des applications où il convient de :

* **Gérer proprement les droits sur les fichiers dans le conteneur**.
* **Ne pas utiliser des ports privilégiés tels le port 80**.

---

## Que manque-t'il à ce stade?

### Éviter les problèmes de cohabitation n'est pas trivial

Il est nécessaire de [spécifier les réservations et limites RAM et CPU des conteneurs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#example-1) pour :

* Permettre la mise en oeuvre de l'**autoscalling sur les noeuds**.
* **Éviter qu'un service consomme toutes les ressources CPU et RAM d'un noeud**.

Il est aussi nécessaire de **s'assurer qu'un Pod ne provoque pas un full sur un noeud** par exemple en :

* Imposant la déclaration de volumes pour le stockage local (`readOnlyRootFilesystem: true`).
* Imposant la déclaration de limites via la mise en oeuvre des quotas sur le stockage local.

En substance, **il faudra une bonne maîtrise de la consommation RAM et de la rigueur sur la gestion des données**.

---

## Que manque-t'il à ce stade?

### Kubernetes n'est pas magique!

Kubernetes offre un cadre permettant la cohabitation d'applications conteneurisées (limites de consommation de ressources, options de sécurité,...).

Il est toutefois du ressort de l'utilisateur d'exploiter ce cadre en **respectant un ensemble de [bonnes pratiques](annexe/docker/bonnes-pratiques.html) dans la création et l'utilisation des conteneurs** pour profiter d'un bon niveau de sécurité et d'un haut niveau de disponibilité (1).

> (1) NB : Les mécanismes de redémarrage automatique des Pods en cas de problème limiteront les effets de certains types de problème (ex : atteinte limite RAM). Il faudra intervenir pour d'autres (ex : full sur un noeud)

---

## Que manque-t'il à ce stade?

### Kubernetes n'est pas la solution à tous les problèmes

Il convient aussi de noter que :

* **Déployer et maintenir des applications "Stateful"** telles des bases de données **en environnement Kubernetes n'est pas trivial** et demandera une **maîtrise du stockage** avec Kubernetes.
* **Kubernetes est une solution bas niveau** qui sera **moins efficace qu'une offre PaaS ou SaaS pour déployer certaines applications** (ex : CMS, site statique,...).

Nous allons à ce titre prendre un peu de recul dans la partie [DevOps dans le cloud](cloud.md) et aborder la possibilité d'hybrider les solutions.

