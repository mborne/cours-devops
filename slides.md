
# Introduction à la méthode DevOps

<br />

<div class="center">
    <img src="img/Devops-toolchain-original.svg" />
</div>

---

# Les origines de DevOps

De nombreux cours sur DevOps se concentrent sur l'automatisation des déploiements. Nous allons tâcher ici de prendre un peu de recul sur l'histoire récente pour comprendre comment DevOps s'inscrit dans l'évolution des méthodes de développement et de déploiement.

---

# Les origines de DevOps

## L'agilité dans les développements

La publication du **[manifeste agile](https://manifesteagile.fr/) en 2001** marque un tournant dans les méthodes de développement. L'agilité inclue entre autre de :

* **Livrer rapidement et régulièrement** une nouvelle version de l'application.
* **Faire travailler ensemble** les personnes en charge du **métier ou des affaires** et les personnes en charge de la **réalisation** au quotidien tout au long du projet.

---

# Les origines de DevOps

## L'automatisation des tests sur le code

Livrer rapidement et régulièrement est **incompatible** avec le fait procéder à de longues **recettes manuelles** pour **éviter l'introduction de bug**.

L'agilité se décline en plusieurs méthodes de développement qui incitent à **réduire le risque de régression** à l'aide de **tests unitaires et fonctionnels**.

On citera par exemple **[Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)** formalisée **en 2003** par Kent Beck où l'idée est de commencer par le développement des tests avant le développement des fonctionnalités.

---

# Les origines de DevOps

## L'intégration continue

Les outils d'**intégration continue** tels [Hudson sorti en 2005](https://en.wikipedia.org/wiki/Hudson_(software)) (forké et renommé en [Jenkins](https://www.jenkins.io/)) gagnent en popularités. Ils sont utilisés entre autre pour :

* **Centraliser l'exécution des tests** (et s'assurer qu'ils sont bien exéctués)
* Présenter pour tous les **rapports d'exécution des tests**
* **Produire des livrables** à déployer (archive zip/tar, paquet debian/centos, installeur)

---

# Les origines de DevOps

## Le cloud

En 2006, Amazon lance deux services qui vont contribuer à populariser le concept d'informatique en nuage :

* [Amazon S3](https://en.wikipedia.org/wiki/Amazon_S3) pour le stockage de données.
* [Amazon Elastic Compute Cloud (EC2)](https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud) pour l'exécution d'application.

Avec ces services :

* Disposer d'une infrastructure de stockage et de calcul capable de s'**adapter à la charge** n'est plus réservée à quelques grands groupes.
* La **facturation à la consommation** donne l'opportunité aux entreprises de taille modeste d'**introduire un nouveau service qui ne sera pas victime de son succès**.

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (1/6)

A ce stade, si les méthodes agiles ont brisés les murs entre le métier et les développeurs, l'exploitation traditionnelle induit toujours un mur entre :

* L'équipe en charge du développement (DEV) qui fournit l'application
* L'équipe en charge de l'exploitation (OPS) qui déploie et veille au bon fonctionnement de l'application

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (2/6)

L'**exploitation traditionnelle** se traduit généralement par un **processus sacralisant un cloisonnement stricts des rôles entre les DEV et les OPS** :

* Les DEV préparent une release (ex : `v0.1.0`)
* Les DEV rédigent un **dossier d'architecture Technique (DAT)** (schéma d'architecture, description des services, dimensionnement demandé, URL à exposer...).
* Les DEV régigent un **dossier d'exploitation (DEX)** décrivant les procédures d'installation, le paramétrage, les éléments à surveiller...
* Les OPS provisionnent l'infrastructure à partir du DAT et du DEX (création des VM, configuration de reverse proxy,...)
* Les DEV valident le déploiement
* Les OPS surveillent l'infrastructure et traitent les problèmes techniques.

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (3/6)

Sur le papier, un telle approche est parfaite :

* Conformément aux recommandations de sécurité, seuls des experts systèmes manipulent le système
* Les développeurs sont déchargés des problématiques d'exploitation

C'est oublier la loi de Murphy!

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (4/6)

En pratique, une telle approche **empêchera de livrer rapidement et régulièrement**. La **mise en production initiale** de l'application prendra alors facilement **1 mois** pour diverses raisons :

* Problème de **compréhension du DAT ou du DEX**
* Problème de **complétude du DAT ou du DEX**

D'expérience, il en sera de même pour **chaque évolution induisant le moindre d'architecture** (ajout d'un service support, changement de méthode de gestion d'un paramètre,...) ce qui laissera deux options :

* Conserver volontairement une architecture non optimimale
* Accepter d'avoir de temps en temps des livraisons qui s'éternisent

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (5/6)

La sacralisation d'une frontière entre les développeurs et les administrateurs systèmes induit aussi des **problèmes en production** quand une **demande d'exploitation ou une procédure** est **mal comprise** ou **mal traduite en opération** :

* **Les OPS** n'étant pas partie prenante dans la conception de l'application **ne peuvent avoir un regard critique et une compréhension des demandes** : Une mise à jour devient une montée en version, une action demandée en QUALIFICATION est appliquée en PRODUCTION,...
* **Les DEV** n'étant pas partie prenante dans la conception de l'infrastructure **n'exploitent pas le système de manière optimale** : Utilisation du mauvais système de stockage, saturation de débit réseau,...

---

# Les origines de DevOps

## Les limites de l'exploitation traditionnelle (6/6)

La frontière entre les rôles se traduit humainement par une tendance des équipes DEV et OPS à **chercher à limiter leur responsabilité en cas de problème** plutôt qu'une recherche collective pour **éviter l'apparition de problèmes** voire **corriger rapidement un problème**.

Typiquement, avant de chercher une solution :

* Il faut prouver côté DEV que le problème n'est pas au niveau du code pour que les OPS commencent à analyser les logs.
* Il faut prouver côté OPS que le problème est lié à une augmentation de la consommation non compatible avec la conception initiale.

---

# Les origines de DevOps

## La naissance de DevOps (1/2)

[devopssec.fr - L'histoire du DevOps](https://devopssec.fr/article/histoire-du-devops) souligne les éléments suivants :

* En 2003, Google pose un nouveau rôle : Le [Site Reliability Engineer (SRE)](https://sre.google/) qui doit assurer un haut niveau de disponibilité des services **collobaration étroite avec les développeurs**.
* En 2008, une conférence Agile à Toronto permet la rencontre entre l'organisateur d'une rencontre sur le thème **« Infrastructure Agile »** et un chef de projet Patrick Debois faisant face au manque de  **cohésion entre les équipes de développement d'applications et les équipes d'exploitation**
* En 2009, deux responsables de Flickr proposent une solution à ce problème : Embaucher des **« Ops qui pensent comme des Devs »** et des **« Devs qui pensent comme des Ops »**.
* En 2009, Patrick Debois contracte **développements (DEV)** et **opérations (OPS)** dans un hashtag pour annoncer la première [DevOpsDays](https://devopsdays.org/): **DevOps est né**.

---

# Les origines de DevOps

## La naissance de DevOps (2/2)

Cette génèse montre que :

* DevOps est avant tout un **rapprochement entre les activités de développement et d'exploitation**.
* Ce rapprochement est nécessaire pour introduire de l'**agilité dans la gestion des infrastructures** pour pouvoir **livrer régulièrement et fréquemment des applications**.
