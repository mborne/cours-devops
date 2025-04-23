# Vagrant - quelques notes pour débuter

## Pré-requis

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Configurer les variables d'environnement pour utilisation d'un proxy sortant](https://mborne.github.io/fiches/proxy-sortant/proxy-env-vars/)

## Points clés

* [Vagrant](https://www.vagrantup.com/) permet de **créer des machines virtuelles de DEV as code** à partir d'un fichier `Vagrantfile`.
* [Vagrant](https://www.vagrantup.com/) supporte plusieurs systèmes de virtualisation (voir [www.vagrantup.com - providers](https://www.vagrantup.com/docs/providers))
* [Vagrant](https://www.vagrantup.com/) s'appuie sur des images de VM au format `.box`
* Un [dépôt d'image publique permet de rechercher une image de VM](https://app.vagrantup.com/boxes/search) compatible avec son système de virtualisation (`virtualbox`, `libvirt` (KVM),...)

## Installation

Voir [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads) qui permet le **téléchargement pour Windows et MacOS** et donne les instructions pour l'**utilisation du dépôt APT pour l'installation sur une machine Debian/Ubuntu** :

```bash
# Ajout du dépôt APT d'HashiCorp
curl -sS https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Installation de vagrant
sudo apt update
sudo apt install vagrant -y
```

## Débuter avec vagrant

### Installation du plugin vagrant pour le proxy

```bash
vagrant plugin install vagrant-proxyconf
```

### Création d'un projet

```bash
# on créé un dossier pour le projet
mkdir ~/vagrant-helloworld
# on se place dans le projet
cd ~/vagrant-helloworld
# Générer un modèle de Vagrantfile
vagrant init ubuntu/focal64
```

## Adapter la configuration

On modifiera par exemple le fichier `Vagrantfile` comme suit :

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "helloworld"

  #---------------------------------------------------
  # Passage de HTTP_PROXY, HTTPS_PROXY,... à la VM
  # avec le plugin vagrant-proxyconf
  #---------------------------------------------------
  if Vagrant.has_plugin?("vagrant-proxyconf")
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http   = ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https  = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  else
    puts "proxy not configured (use 'vagrant plugin install vagrant-proxyconf')"
  end

  #---------------------------------------------------
  # Ajout d'une IP fixe avec un réseau privé
  # (le même que vagrantbox)
  #---------------------------------------------------
  config.vm.network "private_network", ip: "192.168.50.101"

  #---------------------------------------------------
  # Personnalisation de la VM VirtualBox
  #---------------------------------------------------
  config.vm.provider "virtualbox" do |vb|
    vb.name = "helloworld"
    vb.memory = "1024"
    # vb.gui = true
  end

  #---------------------------------------------------
  # Exécution d'un script d'initialisation
  # (optionnel, nous traiterons plutôt avec ansible)
  #---------------------------------------------------
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
```

## Démarrer la VM

```bash
vagrant up
```

## Problème possible

* Sous ubuntu, la plage IP correspondante devra être autorisée via le fichier `/etc/vbox/networks.conf`. S'il est absent, ajouter le contenu suivant :

```
* 192.168.50.0/24
```

* Sous windows, la création du réseau privé virtual (`192.168.50.0/24`) avant affectation de l'IP `192.168.50.101` demandera des droits administrateurs.


## Installer manuellement le serveur web nginx

```bash
# Se connecter à la VM
vagrant ssh
# Puis dans la VM
sudo apt-get update
sudo apt-get install nginx
```

## Vérifier l'accès à nginx

Depuis l'hôte de la VM, nous aurons normalement accès http://192.168.50.101

## Supprimer la VM

```bash
vagrant destroy
```

## Quelques ressources

* [Vagrant - getting started](https://learn.hashicorp.com/collections/vagrant/getting-started) qui guide pour **débuter en l'absence d'un proxy HTTP** (par exemple sur une machine perso connectée à une box internet standard).
* [gist.github.com - wpscholar/vagrant-cheat-sheet.md](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4#file-vagrant-cheat-sheet-md) qui liste les **principales commandes de vagrant**.
* [github.com - mborne/vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox) : Créer plusieurs VM de DEV avec Ansible.

