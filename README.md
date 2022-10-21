# Introduction à la méthode DevOps

## Mise en garde

**La présentation est ici : [https://mborne.github.io/cours-devops/](https://mborne.github.io/cours-devops/)**. Cette page est plutôt destinée aux autres professeurs pour faciliter l'articulation entre les autres cours.

**Cette présentation est en construction et elle risque de connaître encore quelques itérations.** Aussi, elle est l'oeuvre d'un DEV qui a découvert DevOps sur le tas après avoir rêver de déléguer le déploiement et l'exploitation de ses applications à un "infogérant". Un OPS de ces infogérants aurait une expérience différente et probablement une approche différente pour présenter DevOps.

Si vous avez des remarques ou des références à proposer : N'hésitez pas [à faire une issue](https://github.com/mborne/cours-devops/issues)!

## Structure du cours

Nous commençons avec un peu de "théorie" avec :

* [Les origines de DevOps](src/slides/origines.md) qui tâche d'expliquer la genèse de DevOps.
* [Les principes de DevOps](src/slides/principes.md) qui s'efforce de présenter les principes clés de DevOps sans trop entrer dans les outils (où la mode évolue rapidement).

L'idée est ensuite d'entrer dans la pratique avec :

* [DevOps avec des VM](src/slides/vm.md) pour faire un focus sur *Infrastructure as Code* en contexte IaaS.
* [DevOps avec des conteneurs](src/slides/conteneurs.md) pour expliquer l'intérêt des conteneurs (livrable universel) et introduire CaaS avec un survol de Kubernetes.

Sur ces dernières parties, l'idée est de prendre des exemples concrets de déploiement et de faire des démonstrations dont le volume variera selon le nombre de séances.

* ~~[DevOps dans le cloud](src/slides/cloud.md) pour faire un focus sur des problématiques d'architecture des zones d'hébergement (parfois nommées *landing zone*)~~ (annulé cette année, nous manquerons de temps et cette partie manque de précision)

## License

[LICENSE](LICENSE)

