# Utilisation d'un proxy sortant

## Contexte

En cas de présence d'un proxy sortant pour les accès à internet, les systèmes et navigateurs sont souvent configuré à l'aide d'un fichier `proxy.pac`.

Ce fichier `proxy.pac` est un script JavaScript indiquant s'il faut utiliser tel ou tel proxy pour accéder à une ressource.

## Problème

Les outils bas niveau en ligne de commande (`curl`, `vagrant`, `terraform`, `ansible`,...) ne savent pas exploiter ce script. Il faut configurer des variables d'environnement `HTTP_PROXY`, `HTTPS_PROXY` et éventuellement `NO_PROXY`.

## Exemple de configuration temporaire

```bash
export HTTP_PROXY=http://10.0.4.2:3128/
export HTTPS_PROXY=http://10.0.4.2:3128/
export http_proxy=http://10.0.4.2:3128/
export https_proxy=http://10.0.4.2:3128/
```

## Exemple de configuration permanente

* 1) Ajouter les lignes suivantes au fichier `~/.profile` :

```bash
export HTTP_PROXY=http://10.0.4.2:3128/
export HTTPS_PROXY=http://10.0.4.2:3128/
export http_proxy=http://10.0.4.2:3128/
export https_proxy=http://10.0.4.2:3128/
```

* 2) Recharger ce fichier avec `source ~/.profile` OU fermer et rouvrir la session

