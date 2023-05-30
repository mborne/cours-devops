# Le stockage des livrables et des artefacts

Il existe plusieurs solutions pour stocker des livrables dont :

[[toc]]

## Les gestionnaires d'artefact

Dans cette catégorie, nous trouverons par exemple [Nexus Repository Manager](https://fr.sonatype.com/products/nexus-repository) qui a ajouté en version 3 le support d'un grand nombre de format.

## Le système de release du gestionnaire de code source

Nous soulignerons la **possibilité de stocker des livrables en annexe des dépôts GIT** au niveau d'un nombre croissant de gestionnaire de code source :

* [Le système de releases sur GitHub](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
* [Le système de stockage sur GitLab](https://docs.gitlab.com/ee/ci/pipelines/job_artifacts.html)
* [Le système de package de Gitea](https://docs.gitea.io/en-us/usage/packages/overview/)

En contrepartie d'un rôle toujours plus central pour le gestionnaire de code source, nous soulignerons le **gain en matière de cohérence des droits entre le gestionnaire de code source et le dépôt d'artefact**.


## Les dépôts publics des gestionnaires de dépendance

A l'échelle des langages, nous trouverons des dépôts publics dédiés :

* [npmjs.com](https://www.npmjs.com/) pour NodeJS
* [packagist.org](https://packagist.org/) pour PHP
* [pypi.org](https://pypi.org/) pour Python
* [Maven Central Repository](https://search.maven.org/) pour Java
* ...

Nous noterons qu'il est possible de les utiliser pour publier des versions des bibliothèques


## Mise en garde sur la sécurité

L'utilisation d'un gestionnaire de dépendance expose aux risques suivants :

* Une dépendance disponible publiquement peut être corrompue
* Une dépendance disponible publiquement peut venir remplacer une dépendance hébergée sur un dépôt privé (confusion de dépendance)

Il convient en conséquence de :

* Faire preuve de prudence dans le choix de ses dépendances
* Se prémunir contre le risque de confusion de dépendance avec une stratégie adaptée au gestionnaire de dépendance (pip, composer, npm, docker,...)




