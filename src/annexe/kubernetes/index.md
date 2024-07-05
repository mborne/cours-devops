
### La configuration

Pour la [gestion de la configuration](https://kubernetes.io/docs/concepts/configuration/), nous trouverons principalement les concepts suivants :

* Les [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
* Les [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)

Nous nous limiterons dans ce cours à mentionner :

* La possibilité d'utiliser ces concepts pour gérer des **variables d'environnements** et des **fichiers de configuration**.
* Les limites de **secrets** où il est principalement question d'un **simple encodage en base64** (1)

> La présence d'un type distinct entre ConfigMap et Secret sera principalement utile pour limiter les accès à ces derniers.


