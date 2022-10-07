# IaC - l'indépotence

## Cas d'école

Je souhaite configurer l'authentification SSH en renseignant les clés publiques (ex : https://github.com/mborne.keys) pour un utilisateur (ex : `mborne`).

## Contre-exemple

J'ajoute les clés en question au fichier `/home/${USER}/authorized_keys` : **Pas bien!** (avec plusieurs exécutions, le fichier grossira innutilement)

## Exemple

Je m'assure que les clés en question sont bien dans le fichier `/home/${USER}/authorized_keys` : **Bien!**










