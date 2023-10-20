
# DevOps dans le cloud

* La variété des offres
* La variété des services supports
* Rendre ses applications "cloud ready"

---

## La variété des offres

### Plusieurs options possibles...

Vous remarquerez que nous ne sommes concentré jusque là sur DevOps en contexte IaaS ou CaaS mais d'autres options seront possibles.

Pour déployer une application, nous aurons à faire un choix entre :

* IaaS où nous disposerons de VM avec un contrôle complet.
* CaaS où nous déploierons des conteneurs
* PaaS où nous fournirons le code de l'application.
* FaaS où nous fournirons de simples fonctions.
* SaaS où nous disposerons de services prêt à l'emploi.

---

## La variété des offres

### Quelle offre choisir?

Il n'est pas évident de répondre dans l'absolu à cette question. Il semble raisonnable de **traiter au cas par cas en fonction de la nature des services de l'application**.

A titre d'exemple, pour les **services de stockage** tel PostgreSQL, il peut être pertinent de choisir entre une approche **IaaS ou SaaS** (ex : PostgreSQL géré par l'hébergeur) à moins d'avoir une maîtrise absolue de CaaS ou des données jetables (base de diffusion).

En déployant les services de stockage en amont du déploiement des applications (1), le choix pourra se faire entre **FaaS, PaaS et CaaS** pour les **services applicatifs** en fonction de leur complexité.

> (1) En procédant ainsi, les services de stockage deviennent des services managés du point de vue des développeurs. Les services applicatifs deviennent sans état car les états se retrouvent externalisé dans les services de stockage.

---

## La variété des services supports

### Des services supports fonctions des fournisseurs

En fonction des hébergeurs, nous ne disposerons pas des mêmes services supports par exemple pour :

* La gestion des utilisateurs et de leurs droits (IAM)
* La gestion des journaux applicatifs
* La supervision système
* La maîtrise des coûts (notion de projet, quotas,...)

En outre, certaines offres seront plus "clé en main" que d'autres (ex : collecte des logs pré-configurée) ce qui impliquera une complexité variable selon l'hébergeur pour la mise en oeuvre de l'observabilité.

---

## La variété des services supports

### De nombreuses solutions complémentaires disponibles

Nous remarquerons avec [landscape.cncf.io](https://landscape.cncf.io/) que nous disposerons de nombreuses solutions *cloud ready* sur lesquelles nous appuyer pour construire notre zone d'hébergement cloud.


---

## Rendre ses applications cloud ready

Respecter [les 12 facteurs](https://12factor.net/fr/) mis en avant par [Heroku](https://www.heroku.com/) dans sa propre application sera la clé pour pouvoir déployer facilement une application dans le cloud.

Pour les nouvelles applications, il sera d'avoir connaissance de ces règles de conception dès la construction.

Pour les autres, il sera intéressant de voir comment tendre progressivement vers cet idéal.


