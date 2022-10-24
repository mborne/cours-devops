# Annexes et références

[[toc]]

## Généralités sur DevOps

* [devopssec.fr - L'histoire du DevOps](https://devopssec.fr/article/histoire-du-devops)
* [www.atlassian.com - Framework CALMS](https://www.atlassian.com/fr/devops/frameworks/calms-framework)
* [www.atlassian.com - Métriques DevOps](https://www.atlassian.com/fr/devops/frameworks/devops-metrics)
* [meritis.fr - Qu’est-ce que le DevOps ? Concepts fondamentaux et bonnes pratiques du DevOps](https://meritis.fr/devops-avez-dit-devops/)
* [fr.kaizen.com - L'importance du Time to Market](https://fr.kaizen.com/produits/importance-time-to-market-fr) qui aborde les notions d'efficacité des ressources et des flux.
* [docs.microsoft.com - Liste de contrôle DevOps](https://docs.microsoft.com/fr-fr/azure/architecture/checklist/dev-ops)

En image :

* [www.commitstrip.com - Comment savoir si votre entreprise est DevOps](https://www.commitstrip.com/fr/2015/02/02/is-your-company-ready-for-devops/?)
* [www.commitstrip.com - Tout automatisé… ou presque](https://www.commitstrip.com/fr/2015/06/22/can-we-automate-everything/?setLocale=1)

## Les briques d'infrastructure

* [Partage de charge et reverse proxy](lb-rp.md)
* [Le proxy sortant](proxy-sortant.md)
* [blog.octo.com - Le bastion SSH](https://blog.octo.com/le-bastion-ssh/)

## Les outils DevOps

* [roadmap.sh - devops](https://roadmap.sh/devops) propre un chemin d'apprentissage permettant de découvrir les principaux concepts et outils associés qu'un DevOps est amenés à rencontrer.
* [Le stockage des livrables et des artefacts](stockage-artefact.md)

En contexte IaaS (VM) :

* [Vagrant](vagrant-helloworld.md) pour créer des VM de DEV as code.
* [Terraform](https://www.terraform.io/) qui remplacera [Vagrant](vagrant-helloworld.md) pour la production. 
* [Ansible](ansible.md) pour gérer la configuration et déployer des applications sur des VM.

## Compléments

### Automatisation des tests

* [blog.octo.com - La pyramide des tests par la pratique](https://blog.octo.com/la-pyramide-des-tests-par-la-pratique-1-5/)

### Généralité sur le cloud

* [ENSG - Technologies de Cloud Computing (Cédric Esnault)](https://cedricici.github.io/cours-cloud/public/#/)
* [www.redhat.com - IaaS, PaaS, SaaS : quelles sont les différences ?](https://www.redhat.com/fr/topics/cloud-computing/iaas-vs-paas-vs-saas)
* [www.ovhcloud.com - IaaS, PaaS, SaaS : quelle solution cloud choisir ?](https://www.ovhcloud.com/fr/public-cloud/cloud-computing/iaas-paas-saas/)

### Principes d'architecture pour le cloud

* [12factor.net - Les 12 facteurs](https://12factor.net) pour concevoir des applications "*cloud ready*"
* [learn.microsoft.com - Modèles de conception de cloud](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/) dont :
  * [learn.microsoft.com - Modèle Surveillance de point de terminaison](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/health-endpoint-monitoring)
  * [learn.microsoft.com - CQRS](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/cqrs) pour pouvoir s'adapter à la charge plus facilement sur la seule diffusion (dans notre exemple : `/wms`, `/wfs`,... vs `/geoserver/`)
  * [learn.microsoft.com - Modèle Figuier étrangleur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/strangler-fig) pour gérer la migration d'un ancien vers un nouveau service.
  * [learn.microsoft.com - Modèle Nouvelle tentative](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/retry) et [learn.microsoft.com - Modèle Disjoncteur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/circuit-breaker) pour survivre aux instabilités d'une plateforme d'hébergement ou d'un service tiers.

### DevSecOps et la sécurité

* [geekflare.com - Une introduction à DevSecOps pour les débutants](https://geekflare.com/fr/devsecops-introduction/)
* [dev-sec.io - hardening à la sauce DevSecOps](https://dev-sec.io/)
* [www.commitstrip.com - La sécurité coûte cher ? Essayez le piratage](https://www.commitstrip.com/fr/2017/06/19/security-too-expensive-try-a-hack/?)
