# Cas d'école de métrique contre-productive

Le cas suivant semble courant :

* On utilise uniquement un outil d'analyse statique du code pour définir une métrique sécurité du code (Ex : "nombre de failles détectées dans le code")
* On concentre tous les efforts sur le traitement des alertes levées automatiquement.

On se retrouve alors à traiter principalement des problèmes de sécurité mineurs et des faux positifs.

Les failles critiques ne pouvant être décelées par ce type d'outils peuvent par contre faire de vieux os car on a oublié de définir une métrique "Fréquence des audits de sécurité complet" pour les failles ne pouvant être détecté que par :

* Une revue du code
* Une revue de l'architecture
* Une revue de la méthode de déploiement
* Une revue de la méthode de sauvegarde
* ...
