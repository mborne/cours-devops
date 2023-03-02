
# Configurer l'utilisation du proxy à l'aide de variables d'environnement

## Principe

De nombreux outils supportent la configuration du proxy à l'aide des variables d'environnement `HTTP_PROXY`, `HTTPS_PROXY` et `NO_PROXY`. Par exemple :

```bash
export HTTP_PROXY=http://10.0.4.2:3128/
export HTTPS_PROXY=http://10.0.4.2:3128/
export http_proxy=http://10.0.4.2:3128/
export https_proxy=http://10.0.4.2:3128/
# à adapter!
export NO_PROXY=localhost,127.0.0.1,vagrantbox-1,vagrantbox-2,vagrantbox-3
```

## Configuration d'une machine Ubuntu

Pour une configuration permanente pour un utilisateur, nous pouvons :

* Ajouter les lignes précédentes au fichier `~/.profile`
* Se déconnecter et rouvrir une session (ou recharger ce fichier avec `source ~/.profile`)

Pour une configuration permanente à l'échelle du système :

* Ajouter les lignes précédentes au fichier `/etc/environment` (sans toucher à la ligne définissant la variable d'environnement `PATH`!)
* Redémarrer la machine


## Configuration d'une machine Windows

Un dialogue "Modifier les variables d'environnement de votre compte" permet d'ajouter les variables `HTTP_PROXY`, `HTTPS_PROXY` et `NO_PROXY`.

Chercher "environnement" dans "paramètres" ou lancer la commande `rundll32 sysdm.cpl,EditEnvironmentVariables` dans un terminal `cmd.exe`.

