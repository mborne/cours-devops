# Références

## Généralités sur DevOps

En correspondance avec les parties origines et principes DevOps :

* [devopssec.fr - L'histoire du DevOps](https://devopssec.fr/article/histoire-du-devops)
* [www.atlassian.com - Framework CALMS](https://www.atlassian.com/fr/devops/frameworks/calms-framework)
* [www.atlassian.com - Métriques DevOps](https://www.atlassian.com/fr/devops/frameworks/devops-metrics)
* [meritis.fr - Qu’est-ce que le DevOps ? Concepts fondamentaux et bonnes pratiques du DevOps](https://meritis.fr/devops-avez-dit-devops/)
* [docs.microsoft.com - Liste de contrôle DevOps](https://docs.microsoft.com/fr-fr/azure/architecture/checklist/dev-ops)

En image :

* [www.commitstrip.com - Comment savoir si votre entreprise est DevOps](https://www.commitstrip.com/fr/2015/02/02/is-your-company-ready-for-devops/)
* [www.commitstrip.com - Tout automatisé… ou presque](https://www.commitstrip.com/fr/2015/06/22/can-we-automate-everything/)

Pour le concept *Lean* en particulier :

* [www.leanprimer.com - LEAN PRIMER par Craig Larman et Bas Vodde](https://www.leanprimer.com/downloads/lean_primer_fr.pdf)
* [pablopernot.fr - Lean Software Development (présentation)](https://pablopernot.fr/pdf/LSD-08.pdf)
* Lean Software Development: An Agile Toolkit (Mary Poppendieck, Tom Poppendieck)
* Lean startup (Eric Ries)

En complément :

* [blog.stephane-robert.info - Formation DevOps](https://blog.stephane-robert.info/docs/)
* [blog.stephane-robert.info - Glossaire DevOps](https://blog.stephane-robert.info/docs/glossaire/introduction/)


## Les tests

Pour aller plus loin sur les tests :

* [blog.octo.com - La pyramide des tests par la pratique](https://blog.octo.com/la-pyramide-des-tests-par-la-pratique-1-5/)
* [fr.wikipedia.org - Chaos_Monkey (Netflix)](https://fr.wikipedia.org/wiki/Chaos_Monkey) pour les tests de résilience sur les infrastructures.

## Les principes d'architecture

Pour concevoir des applications faciles à déployer, à exploiter et capables de passer à l'échelle voir :

* [12factor.net - Les 12 facteurs](https://12factor.net) pour la version officielle
  * [DevOps - Les 12 facteurs](https://mborne.github.io/fiches/12-facteurs/) pour la fiche de synthèse faisant le lien avec les éléments vu dans ce cours.
  * [www.softfluent.fr - The 12-factor app : sont-ils toujours d’actualité ?](https://www.softfluent.fr/blog/the-12-factor-app-sont-ils-toujours-dactualite/) qui passe en revue et étends ces principes posés en 2012
* [learn.microsoft.com - Modèles de conception de cloud](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/) dont :
  * [learn.microsoft.com - Modèle Surveillance de point de terminaison](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/health-endpoint-monitoring) qui décrit le principe d'URL dédiée à la surveillance.
  * [learn.microsoft.com - CQRS](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/cqrs) qui incite à séparer les API d'écriture et de lecture pour s'adapter à la charge plus facilement sur la seule diffusion (ex : `/wms`, `/wfs` vs `/geoserver/`)
  * [learn.microsoft.com - Modèle Figuier étrangleur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/strangler-fig) qui guide pour faciliter les migrations d'un ancien vers un nouveau service.
  * [learn.microsoft.com - Modèle Nouvelle tentative](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/retry) et [learn.microsoft.com - Modèle Disjoncteur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/circuit-breaker) qui donne de l'inspiration pour survivre aux instabilités d'un service tiers.

## Le cloud

Pour aller plus loin sur l'informatique en nuage :

* [ENSG - Technologies de Cloud Computing (Cédric Esnault)](https://cedricici.github.io/cours-cloud/public/#/)
* [www.redhat.com - IaaS, PaaS, SaaS : quelles sont les différences ?](https://www.redhat.com/fr/topics/cloud-computing/iaas-vs-paas-vs-saas)
* [www.ovhcloud.com - IaaS, PaaS, SaaS : quelle solution cloud choisir ?](https://www.ovhcloud.com/fr/public-cloud/cloud-computing/iaas-paas-saas/)


## DevSecOps

Nous abordons peu dans ce cours la sécurité, mais vous noterez que :

* Le besoin de livrer rapidement les évolutions ne sera pas compatible avec l'attente de validation de sécurité
* Les équipes de sécurité peuvent elles aussi être intégrées au processus de développement pour un meilleur traitement de cet aspect

Vous pourrez à ce titre consulter les ressources suivantes :

* [geekflare.com - Une introduction à DevSecOps pour les débutants](https://geekflare.com/fr/devsecops-introduction/)
* [dev-sec.io - hardening à la sauce DevSecOps](https://dev-sec.io/)
* [www.commitstrip.com - La sécurité coûte cher ? Essayez le piratage](https://www.commitstrip.com/fr/2017/06/19/security-too-expensive-try-a-hack/)
* [cyber.gouv.fr - Agilité et sécurité numériques : méthode et outils à l’usage des équipes projet](https://cyber.gouv.fr/publications/agilite-et-securite-numeriques-methode-et-outils-lusage-des-equipes-projet) qui évoque la notion d'***abuser story*** en complément de celle d'***user story*** pour **intégrer le traitement des problématiques de sécurité au processus de développement**.
* [cyber.gouv.fr - Sécuriser un site web](https://cyber.gouv.fr/publications/securiser-un-site-web)
