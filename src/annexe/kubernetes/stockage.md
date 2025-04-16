# Kubernetes - les volumes et le stockage

Cette annexe s'efforce de donner une vue d'ensemble du [stockage avec Kubernetes](https://kubernetes.io/docs/concepts/storage/). Elle a pour objectif premier d'**illustrer la complexité du sujet** et de montrer qu'**héberger les données non jetables d'applications dans Kubernetes** ne sera pas une mince affaire.

[[toc]]

## Les volumes

Kubernetes distingue **plusieurs types de [volumes](https://kubernetes.io/docs/concepts/storage/volumes/)** répondant à différents cas d'utilisation :

* [Les volumes persistants (PersistentVolume)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) avec [plusieurs types](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes) dont :
  * [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) correspondant à un dossier sur un noeud.
  * [nfs](https://kubernetes.io/docs/concepts/storage/volumes/#nfs) pour un montage réseau.
* [Les volumes projetés](https://kubernetes.io/docs/concepts/storage/projected-volumes/)
  * [configMap](https://kubernetes.io/docs/concepts/storage/volumes/#configmap)
  * [secret](https://kubernetes.io/docs/concepts/storage/volumes/#secret)
* [Les volumes éphémères](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/) :
  * [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir-configuration-example) pour stocker les **données temporaires propres à chaque Pod**

## Les pilotes pour le stockage

Kubernetes dispose d'un **mécanisme de plugin permettant d'intégrer différentes solutions de stockage** (c.f. [kubernetes-csi.github.io - CSI Drivers](https://kubernetes-csi.github.io/docs/drivers.html)) dont :

* [NFS](https://github.com/kubernetes-csi/csi-driver-nfs#readme)
* [SMB](https://github.com/kubernetes-csi/csi-driver-smb#readme)
* [CephFS](https://github.com/ceph/ceph-csi#readme)

Dans les cas où nous utilisons **Kubernetes en mode SaaS**, nous soulignerons que les **possibilités offertes par défaut seront fonctions de l'infrastructure** :

* Des volumes Cinder si nous utilisons [Managed Kubernetes Service d'OVH](https://www.ovhcloud.com/fr/public-cloud/kubernetes/) qui s'appuie sur OpenStack.
* Des [GCE Persistent Disk](https://cloud.google.com/persistent-disk?hl=fr#documentation) si nous utilisons [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine?hl=fr).


## Provisionnement statique et dynamique

Le concept de [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/#using-dynamic-provisioning) permettra de faire **abstraction sur la commande d'un volume persistant** :

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nginx
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast
  resources:
    requests:
      storage: 30Gi
```

Le concept de [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/) permettra de répondre à cette demande avec deux cas de figure :

* La création du **PersistentVolume** correspondant par un administrateur du cluster (**provisionnement statique**)
* La création automatique du **PersistentVolume** via l'utilisation d'une classe de stockage prévue à cet effet (**provisionnement dynamique**)

La commande `kubectl get storageclass` renverra la liste des classes de stockage mise à disposition pour le provisionnement dynamique.

## Les modes d'accès

Nous soulignerons que **tous les types de stockage n'offrent pas les mêmes possibilités**. En particulier, Kubernetes distinguera plusieurs **modes d'accès** dont :

* **ReadWriteOnce** (RWO) indiquant que le volume peut être utilisé en lecture/écriture par des **Pods s'exécutant sur un même noeud**.
* **ReadWriteMany** (RWX) dans le cas où les **Pods s'exécutent sur plusieurs noeuds**.

Ainsi :

* **ReadWriteOnce** sera le reflet d'une contrainte : **Il n'est généralement pas possible d'attacher un disque virtuel à plusieurs machines virtuelles**.
* **ReadWriteMany** correspondra à l'utilisation d'un **stockage de fichier en réseau** ou **système de stockage distribué**.

En règle générale, il sera **préférable de ne pas avoir recours à un stockage ReadWriteMany** pour des raisons de **performance** et éventuellement de coût (mais se libérer de cette contrainte pourra demander des efforts de refonte importants).

## Cas des StatefulSet

La propriété `volumeClaimTemplates` sur les [StatefulSet](https://kubernetes.io/fr/docs/concepts/workloads/controllers/statefulset/#composants) permettra de **laisser Kubernetes se charger de la création d'un PVC par Pod** (`postgres-0, postgres-1,...`) :

Il convient de noter qu'il n'y aura **pas de suppression automatique sur les PVC créés automatiquement pour les Pod d'un StatefulSet** (ils survivront à la suppression des Pods et du StatefulSet).

## Mise en garde

* La **suppression d'un PersistentVolumeClaim se traduit généralement par la suppression du PersistentVolume correspondant** (voir [kubernetes.io - Change the Reclaim Policy of a PersistentVolume](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/))
* Si vous utilisez [Helm](https://mborne.github.io/outils/helm/) pour créer des PVC, `helm uninstall mon-application` incluera la suppression des PVC (voir [helm.sh - Tell Helm Not To Uninstall a Resource](https://helm.sh/docs/howto/charts_tips_and_tricks/#tell-helm-not-to-uninstall-a-resource) et **créer les PVC en amont du déploiment**)
* L'**utilisation de volumes persistants dans un cluster Kubernetes** induira une **prudence particulière et une complexité accrue dans l'exploitation d'un cluster Kubernetes**.

Par exemple, la suppression brutale d'un Pod récalcitrant à la suppression (`status=Terminating`) se traduira par le démontage incomplet de ces volumes et le blocage du redémarrage du Pod sur un autre noeud.

