---
theme: marp-ensg
paginate: true
footer: ENSG - <a href="./#2">Introduction à la méthode DevOps</a> - mars 2025
header: '<div><img src="./img/logo-ensg.png" alt="ENSG" height="64px"/></div>'
---

# DevOps dans le cloud

- [La variété des offres](#la-variété-des-offres)
- [La variété des services supports](#la-variété-des-services-supports)
- [L'automatisation avec Terraform](#lautomatisation-avec-terraform)
- [Rendre ses applications "cloud ready"](#rendre-ses-applications-cloud-ready)

---

## La variété des offres


### Plusieurs options possibles...

Vous remarquerez que **nous nous sommes concentrés jusque là sur DevOps soit en contexte VM, soit en contexte Docker, soit en contexte Kubernetes**.

Pour déployer une application, nous pourrons aussi **hybrider les offres** avec plusieurs choix possibles :

- **IaaS** où nous disposerons de VM avec un contrôle complet.
- **CaaS** où nous déploierons des conteneurs.
- **PaaS** où nous fournirons le code de l'application.
- **FaaS** où nous fournirons de simples fonctions.
- **SaaS** où nous disposerons de services prêt à l'emploi.

---

## La variété des offres

### Quelle offre choisir?

Il n'est pas évident de répondre dans l'absolu à cette question. Il semble raisonnable de **traiter au cas par cas en fonction de la nature des services de l'application**.

---

## La variété des offres

### Cas des services de stockage

<div style="font-size:0.9em">

A titre d'exemple, pour les **services de stockage** tel PostgreSQL, il peut être pertinent de choisir entre une approche **IaaS ou SaaS** (ex : PostgreSQL géré par l'hébergeur) à moins d'avoir des données jetables (base de diffusion) ou une maîtrise absolue de Kubernetes.

En déployant les services de stockage en amont du déploiement des applications :

- Les services applicatifs deviennent sans état (ils sont externalisés dans les services de stockage)
- La charge de déploiement des applicatifs est allégée (les services de stockage deviennent des services managés du point de vue des développeurs)
- Il est plus simple de mettre en oeuvre des plans de sauvegarde et plan de reprise d'activité

</div>

---

## La variété des offres

### Cas des services applicatifs

Le choix peut alors se faire entre **FaaS, PaaS et CaaS** pour les **services applicatifs** en fonction de leur complexité.

---

## La variété des services supports

### Des services supports fonctions des fournisseurs

**En fonction des hébergeurs, nous ne disposerons pas des mêmes services supports** par exemple pour :

- La gestion des utilisateurs et de leurs droits de gestion de l'infrastructure (IAM)
- La gestion des journaux applicatifs
- La supervision système
- La maîtrise des coûts (projets, labels, quotas,...)

En outre, **certaines offres seront plus "clé en main" que d'autres** (ex : collecte des logs pré-configurée) ce qui impliquera une **complexité de mise en oeuvre variable selon l'hébergeur**.

---

## La variété des services supports

### De nombreuses solutions complémentaires disponibles

Nous remarquerons avec [landscape.cncf.io](https://landscape.cncf.io/) que nous disposerons de nombreuses solutions *cloud ready* sur lesquelles nous appuyer pour construire notre zone d'hébergement cloud.

Nous conviendrons que ce foisonnement de solutions ne facilitera pas le choix d'une solution pour répondre à une problématique.

---

## L'automatisation avec Terraform

Nous nous appuierons sur le dépôt [mborne/gke-playground](https://github.com/mborne/gke-playground#gke-playground) pour illustrer la **capacité de Terraform à automatiser la gestion de plusieurs types de ressources avec éventuellement plusieurs fournisseurs**.

Nous inspecterons au passage Google Kubernetes Engine (GKE) où nous trouverons plusieurs éléments pré-configurés :

- L'authentification basée sur l'IAM
- La récupération des logs
- La récupération des métriques systèmes

---

## Rendre ses applications cloud ready

A l'échelle des applications, **respecter [les 12 facteurs](https://mborne.github.io/cours-devops/annexe/12-facteurs.html)** mis en avant par [Heroku](https://www.heroku.com/) sera un bon point de départ pour :

- **Pouvoir déployer facilement une application**
- **Adapter l'infrastructure à la charge**
- **Faciliter l'exploitation**
- **Pouvoir choisir librement le mode d'hébergement**

Pour les nouvelles applications, il sera intéressant d'**avoir connaissance de ces règles de conception dès la construction**. Pour les autres, il sera intéressant de tendre progressivement vers cet idéal.
