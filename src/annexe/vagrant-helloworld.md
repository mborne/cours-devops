# Vagrant

## Pré-requis

* [Variables d'environnement pour utilisation d'un proxy sortant](proxy-sortant.md)

## Installation de vagrant

```bash
curl -sS https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vagrant -y
```

## Installation du plugin vagrant pour le proxy

```bash
vagrant plugin install vagrant-proxyconf
```

## Création d'un projet

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

## Installer manuellement le serveur web nginx

```bash
vagrant ssh
# puis dans la VM
sudo apt-get update
sudo apt-get install nginx
```

## Vérifier l'accès à nginx

Depuis l'hôte de la VM, nous aurons normalement accès http://192.168.50.101

## Supprimer la VM

```bash
vagrant destroy
```


## Ressources

* [Vagrant - getting started](https://learn.hashicorp.com/collections/vagrant/getting-started)
* [cheat sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4#file-vagrant-cheat-sheet-md)

