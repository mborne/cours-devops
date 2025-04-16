
# Kubernetes

Quelques notes complémentaires aux slides [DevOps avec Kubernetes](https://mborne.github.io/cours-devops/kubernetes.html)...

## Clients

* [kubectl](https://mborne.github.io/outils/kubectl) : client en ligne de commande pour communiquer avec l'API CLI.
* [helm](https://mborne.github.io/outils/helm/) : client en ligne de commande s'appuyant sur [GO template langage](https://pkg.go.dev/text/template) pour rendre paramétrable les déploiements.
* [kubernetes-dasboard](https://github.com/kubernetes/dashboard#readme) (UI)

## Pods

Le concept de [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) est introduit dans les slides. Il serait intéressant dans un second temps de s'intéresser aux concepts suivants :

* Les [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) pouvant être exploité pour :

  * Préparer des données en disposant d'outils supplémentaires (ex : télécharger un fichier avec curl)
  * Retarder le démarrage d'un conteneur (ex : attente du démarrage d'un service, de la fin de l'exécution d'un traitement,...)
  * Traiter des aspects de sécurité (ex : consommation de secret, isolation du main conteneurs,...)

* Les [liveness, readiness et startup probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/) utilisées pour surveiller le bon fonctionnement des conteneurs.

## Charges de travail

Les concepts suivants relatif à la gestion des [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) sont présentés dans les slides :

- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) pour un **service sans état**.
- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) pour un **service avec état**.
- [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) pour exécuter **un Pod par noeud**.
- [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) pour une **tâche ponctuelle**.
- [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) pour une **tâche périodique**.

Remarque :

* Les concepts de [ReplicaSet](https://kubernetes.io/fr/docs/concepts/workloads/controllers/replicaset/) et de [Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/) sont passés sous silence.


## Exposition de services

Les concepts suivants sont présentés dans les slides :

* [Service](https://kubernetes.io/fr/docs/concepts/services-networking/service/)
* [Ingress](https://kubernetes.io/fr/docs/concepts/services-networking/ingress/)

## Gestion de la configuration

Pour la [gestion de la configuration](https://kubernetes.io/docs/concepts/configuration/), nous trouvons principalement les concepts suivants permettant d'injecter des **variables d'environnements** et des **fichiers de configuration** dans les conteneurs :

* Les [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
* Les [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)

Remarques :

* La présence d'un type distinct entre ConfigMap et Secret permet principalement de limiter les accès à ces derniers (RBAC).
* Les **secrets ne sont pas chiffrés** (simple encodage en base64)

## Les volumes et le stockage

c.f. [Kubernetes - les volumes et le stockage](./stockage.md) qui présente les concepts correspondants (PersistentVolume, PersistentVolumeClaim, StorageClass,...)


## Authenfication

c.f. [kubernetes.io - Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) qui présente le modèle utilisateur (`username: string`, `groups: string[]`,...)

## Gestion des droits

c.f. [kubernetes.io - Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) qui présente les concepts :

- Role et ClusterRole




## Ressources

Documentation officielle :

* [kubernetes.io - Working with Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
* [kubernetes.io - Concepts](https://kubernetes.io/docs/concepts/)
* [kubernetes.io - API reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#-strong-api-overview-strong-)
* [kubernetes.io - Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels)

Formations :

* [container.training](https://container.training/)
* [blog.stephane-robert.info - Formation Kubernetes](https://blog.stephane-robert.info/tags/kubernetes/)

Articles et vidéos :

* [medium.com - K8s: Deployments vs StatefulSets vs DaemonSets](https://medium.com/stakater/k8s-deployments-vs-statefulsets-vs-daemonsets-60582f0c62d4)
* [bryanbende.com - K3s on Raspberry Pi - Volumes and Storage](https://bryanbende.com/development/2021/05/15/k3s-raspberry-pi-volumes-storage#longhorn)
* [www.youtube.com - Understanding Kubernetes Networking. Part 2: POD Network, CNI, and Flannel CNI Plug-in](https://www.youtube.com/watch?v=U35C0EPSwoY)

Outils :

* [blog.devgenius.io - 7 Open Source Kubernetes Developer Tools to Follow in 2022](https://blog.devgenius.io/7-open-source-kubernetes-developer-tools-to-follow-in-2022-78a5e5dbd4e3)
* [collabnix.github.io - Kubetools - A Curated List of Kubernetes Tools](https://collabnix.github.io/kubetools/)
* [learnk8s.io - Can you expose your microservices with an API gateway in Kubernetes?](https://learnk8s.io/kubernetes-ingress-api-gateway)
