# Annexes

## Les services supports classiques

* [Le partage de charge et reverse proxy](lb-rp.md)
* [Le proxy sortant](proxy-sortant/index.md)
* [blog.octo.com - Le bastion SSH](https://blog.octo.com/le-bastion-ssh/)

## Les outils DevOps

Pour les outils abordés dans ce cours :

* [Vagrant - quelques notes pour débuter](vagrant-helloworld.md)
* [Ansible](ansible.md)
* [Docker](docker/index.md)
* [Terraform](https://www.terraform.io/) : voir [gce-playground](https://github.com/mborne/gce-playground) et [gke-playground](https://github.com/mborne/gke-playground) pour des exemples

Pour aller plus loin, voir :

* [roadmap.sh - devops](https://roadmap.sh/devops) qui propose un chemin d'apprentissage permettant de découvrir les principaux concepts et outils associés qu'un DevOps est amenés à rencontrer.
* [Le stockage des livrables et des artefacts](stockage-artefact.md)
* [landscape.cncf.io - CNCF Cloud Native Interactive Landscape](https://landscape.cncf.io/) qui donne un panorama des outils "cloud native"

## Compléments

### Les tests

* [blog.octo.com - La pyramide des tests par la pratique](https://blog.octo.com/la-pyramide-des-tests-par-la-pratique-1-5/)
* [fr.wikipedia.org - Chaos_Monkey (Netflix)](https://fr.wikipedia.org/wiki/Chaos_Monkey) pour les tests de résilience sur les infrastructures.

### Principes d'architecture pour le cloud

Pour concevoir des applications faciles à déployer, à exploiter et capables de passer à l'échelle voir :

* [12factor.net - Les 12 facteurs](https://12factor.net) pour la version officielle
  * [DevOps - Les 12 facteurs](12-facteurs.md) pour la fiche de synthèse faisant le lien avec les éléments vu dans ce cours.
  * [www.softfluent.fr - The 12-factor app : sont-ils toujours d’actualité ?](https://www.softfluent.fr/blog/the-12-factor-app-sont-ils-toujours-dactualite/) qui passe en revue et étends ces principes posés en 2012
* [learn.microsoft.com - Modèles de conception de cloud](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/) dont :
  * [learn.microsoft.com - Modèle Surveillance de point de terminaison](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/health-endpoint-monitoring) qui décrit le principe d'URL dédiée à la surveillance.
  * [learn.microsoft.com - CQRS](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/cqrs) qui incite à séparer les API d'écriture et de lecture pour s'adapter à la charge plus facilement sur la seule diffusion (ex : `/wms`, `/wfs` vs `/geoserver/`)
  * [learn.microsoft.com - Modèle Figuier étrangleur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/strangler-fig) qui guide pour faciliter les migrations d'un ancien vers un nouveau service.
  * [learn.microsoft.com - Modèle Nouvelle tentative](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/retry) et [learn.microsoft.com - Modèle Disjoncteur](https://learn.microsoft.com/fr-fr/azure/architecture/patterns/circuit-breaker) qui donne de l'inspiration pour survivre aux instabilités d'un service tiers.

