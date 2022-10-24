# Le proxy sortant

## Principe

Un proxy sortant sert d'intermédiaire pour le traffic sortant d'une infrastructure. Son utilisation est fréquente en entreprise et dans les écoles car il permet de mettre en place un filtrage en fonction des URL cible.

## Les limites de la configuration automatique {#proxy-pac}

Les systèmes et navigateurs sont généralement configurés à l'aide d'un fichier `proxy.pac` qui est un script JavaScript indiquant s'il faut utiliser tel ou tel proxy pour accéder à une ressource en fonction du nom de domaine ou de l'IP.

Toutefois, de nombreux outils utilisés en ligne de commande (`curl`, `vagrant`, `terraform`, `ansible`, `docker`...) et les bibliothèques de programmation réalisant des requêtes ne savent pas exploiter ce script `proxy.pac`.

Il est alors nécessaire

## Configuration à l'aide de variables d'environnement {#proxy-env-vars}

### Principe

Il convient donc de configurer l'utilisation du proxy à l'aide des variables d'environnement `HTTP_PROXY`, `HTTPS_PROXY` et `NO_PROXY`.

### Configuration d'une machine Ubuntu

```bash
export HTTP_PROXY=http://10.0.4.2:3128/
export HTTPS_PROXY=http://10.0.4.2:3128/
export http_proxy=http://10.0.4.2:3128/
export https_proxy=http://10.0.4.2:3128/
# à adapter!
export NO_PROXY=localhost,127.0.0.1,vagrantbox-1,vagrantbox-2,vagrantbox-3
```

Pour une configuration permanente pour un utilisateur, nous pouvons :

* Ajouter les lignes précédentes au fichier `~/.profile`
* Se déconnecter et rouvrir une session (ou recharger ce fichier avec `source ~/.profile`)

Pour une configuration permanente à l'échelle du système :

* Ajouter les lignes précédentes au fichier `/etc/environment` (sans toucher à la ligne définissant la variable d'environnement `PATH`!)
* Redémarrer la machine


### Configuration d'une machine Windows

Un dialogue "Modifier les variables d'environnement de votre compte" permet d'ajouter les variables `HTTP_PROXY`, `HTTPS_PROXY` et `NO_PROXY`.

Chercher "environnement" dans "paramètres" ou lancer la commande `rundll32 sysdm.cpl,EditEnvironmentVariables` dans un terminal `cmd.exe`.


