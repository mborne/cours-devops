# Introduction à la méthode DevOps

## Mise en garde

**La présentation est ici : [https://mborne.github.io/cours-devops/](https://mborne.github.io/cours-devops/)**. Cette page est plutôt destinée aux autres professeurs pour faciliter l'articulation entre les autres cours.

**Cette présentation risque de connaître encore quelques itérations.** Aussi, elle est l'oeuvre d'un DEV qui a découvert DevOps sur le tas après avoir rêver de déléguer le déploiement et l'exploitation de ses applications à un "infogérant". Un OPS de ces infogérants aurait une expérience différente et probablement une approche différente pour présenter DevOps.

Si vous avez des remarques ou des références à proposer : N'hésitez pas [à faire une issue](https://github.com/mborne/cours-devops/issues)!

## Structure du cours

Nous commençons avec un peu de "théorie" avec :

* [Les origines de DevOps](https://mborne.github.io/cours-devops/origines.html#1) qui tâche d'expliquer la genèse de DevOps comme une prise de conscience (avec des développements agiles impliquant des livraisons fréquentes, il faut introduire de l'agilité dans la gestion des infrastructures).
* [Les principes de DevOps](https://mborne.github.io/cours-devops/principes.html#1) qui s'efforce de présenter les principes clés de DevOps sans se focaliser sur l'automatisation des déploiements et sans trop entrer dans les outils (où la mode évolue rapidement).

L'idée est ensuite d'entrer dans la pratique avec :

* [DevOps avec des VM](https://mborne.github.io/cours-devops/vm.html#1) pour faire un focus sur *Infrastructure as Code* en contexte IaaS avec Terraform, Vagrant et Ansible. Nous soulignons que ce type d'environnement amène la construction non triviale d'une infrastructure d'accueil des applications où les capacités d'automatisation de gestion des configuration sont limitées et où les responsabilités entre les équipes DEV et OPS ne sont pas clairement définies.
* [DevOps avec des conteneurs](https://mborne.github.io/cours-devops/conteneurs.html#1) pour expliquer le principe de fonctionnement et l'intérêt des conteneurs notamment par rapport aux problématiques rencontrées avec IaaS.
* [DevOps avec Kubernetes](https://mborne.github.io/cours-devops/kubernetes.html#1) pour en présenter le principe de fonctionnement, donner un aperçu des principaux concepts et l'intérêt de ces derniers.
* [DevOps dans le Cloud](https://mborne.github.io/cours-devops/cloud.html#1) pour tâcher de guider dans le choix entre IaaS, PaaS, SaaS, CaaS,... en fonction du type de service (service de stockage vs application stateless). Nous concluons en insistant sur la nécessité de respecter [les 12 facteurs](annexe/12-facteurs.html) pour **pouvoir déployer facilement une application** et **adapter l'infrastructure à la charge**.

## License

[LICENSE](LICENSE)

