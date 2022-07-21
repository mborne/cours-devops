
# Introduction à la méthode DevOps

<br />

<div class="center">
    <img src="img/Devops-toolchain.svg" />
</div>

---

# Les origines de DevOps

De nombreux cours sur DevOps se concentrent sur l'automatisation des déploiements. Nous allons tâcher ici de prendre un peu de recul sur l'histoire récente pour comprendre comment DevOps s'inscrit dans l'évolution des méthodes de développement et de déploiement.

---

## L'agilité dans les développements

La publication du **[manifeste agile](https://manifesteagile.fr/) en 2001** marque un tournant dans les méthodes de développement. L'agilité inclue entre autre de :

* **Livrer rapidement et régulièrement** une nouvelle version de l'application.
* **Faire travailler ensemble** les personnes en charge du **métier ou des affaires** et les personnes en charge de la **réalisation** au quotidien tout au long du projet.

---

## L'automatisation des tests sur le code

Livrer rapidement et régulièrement est **incompatible** avec le fait procéder à de longues **recettes manuelles** pour **éviter l'introduction de bug**.

L'agilité se décline en plusieurs méthodes de développement qui incitent à **réduire le risque de régression** à l'aide de **tests unitaires et fonctionnels**.

On citera par exemple **[Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)** formalisée **en 2003** par Kent Beck où l'idée est de commencer par le développement des tests avant le développement des fonctionnalités.

---

## L'intégration continue

Les outils d'**intégration continue** tels [Hudson sorti en 2005](https://en.wikipedia.org/wiki/Hudson_(software)) (forké et renommé en [Jenkins](https://www.jenkins.io/)) gagnent en popularités. Ils sont utilisés entre autre pour :

* **Centraliser l'exécution des tests** (et s'assurer qu'ils sont bien exéctués)
* Présenter pour tous les **rapports d'exécution des tests**
* **Produire des livrables** à déployer (archive zip/tar, paquet debian/centos, installeur)

---

## Le cloud

En 2006, Amazon lance deux services qui vont contribuer à populariser le concept d'informatique en nuage :

* [Amazon S3](https://en.wikipedia.org/wiki/Amazon_S3) pour le stockage de données.
* [Amazon Elastic Compute Cloud (EC2)](https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud) pour l'exécution d'application.

Avec ces services :

* Disposer d'une infrastructure de stockage et de calcul capable de s'**adapter à la charge** n'est plus réservée à quelques grands groupes.
* La **facturation à la consommation** donne l'opportunité aux entreprises de taille modeste d'**introduire un nouveau service qui ne sera pas victime de son succès**.

---

## L'exploitation traditionnelle (1/X)

A ce stade, si les méthodes agiles ont brisés les murs entre le métier et les développeurs, l'exploitation traditionnelle induit toujours un mur entre :

* L'équipe en charge du développement (DEV) qui fournit l'application
* L'équipe en charge de l'exploitation (OPS) qui déploie et veille au bon fonctionnement de l'application

---

## L'exploitation traditionnelle (1/X)

Les **processus sacralisant un cloisonnement stricts des rôles empêchent de livrer rapidement et régulièrement** des nouvelles versions. Par exemple, pour mettre en production :

> TODO : schéma

* Les DEV rédigent une dossier d'architecture Technique (DAT) décrivant l'application.
* Les DEV régigent un dossier d'exploitation (DEX) décrivant les procédures d'installation, le paramétrage, les éléments à surveiller...
* Les OPS provisionnent l'infrastructure à partir de ces documents (création des VM, configuration de reverse proxy,...)
* Les DEV valident le déploiement (après avoir compléter/précise à plusieurs reprises la procédure)


---

## L'exploitation traditionnelle (1/X)

La **mise en production initiale** de l'application prendra alors facilement **1 mois**. Même chose pour **chaque évolution d'architecture** ce qui incite à :

* **Éviter l'ajout de service support** (redis pour une mise en cache, ElasticSearch pour une recherche full-texte,...)
* **Éviter tout refactoring au niveau de l'architecture**

---

## L'exploitation traditionnelle (1/X)

La sacralisation d'une frontière entre les développeurs et les administrateurs systèmes induit aussi des **problèmes en production** quand une **demande d'exploitation ou une procédure** est **mal comprise** ou **mal traduite en opération**. En outre :

* **Les OPS** n'étant pas partie prenante dans la conception de l'application **ne peuvent avoir un regard critique et une compréhension des demandes** (une mise à jour devient une montée en version, une action demandée en QUALIFICATION est appliquée en PRODUCTION,...)
* **Les DEV** n'étant pas partie prenante dans la conception du système d'hébergement **n'exploitent pas le SI de manière optimale** (utilisation du mauvais système de stockage, saturation de débit réseau,...)

Un tendance à la **sécurité par l'obscurité** enfonce le clou du cercueil dans l'absence d'une compréhension partagée du système.

---

## L'exploitation traditionnelle (1/X)

La frontière entre les rôles se traduit humainement par une tendance des équipes DEV et OPS à **chercher à limiter leur responsabilité en cas de problème** plutôt qu'une recherche collective pour **éviter l'apparition de problème** voire **corriger rapidement un problème**.

Typiquement, avant de chercher une solution :

* Il faut prouver côté DEV que le problème n'est pas au niveau du code pour que les OPS commencent à analyser les logs.
* Il faut prouver côté OPS que le problème est lié à une augmentation de la consommation non compatible avec la conception initiale

On prend dans ce dernier conscience que **l'architecture n'est pas scalable quand la construction de l'infrastructure s'appuie sur un DAT contenant la liste exhaustive des machines (nom technique, nombre de CPU, RAM,...)** et des **clics pour créer ces machines** dans l'interface d'un hyperviseur...
