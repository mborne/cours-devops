
# Ansible

[[toc]]

## Pré-requis

* [Configurer les variables d'environnement pour utilisation d'un proxy sortant](proxy-sortant.md)
* Une machine ou VM sous Linux. Voir :
  * [docs.ansible.com - Can Ansible run on Windows?](https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows) qui explique que Ansible ne tourne pas nativement sous windows.
  * [mborne/vagrantbox - Using vagrantbox on windows](https://github.com/mborne/vagrantbox/blob/master/docs/windows.md#using-vagrantbox-on-windows)

## Installation

* [docs.ansible.com - Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html#installation-guide)
* [gist.github.com - mborne/ansible-venv-md - Ansible dans un environnement virtuel Python](https://gist.github.com/mborne/eeb3a0177fe27f5ed393a00eded0a86f#file-ansible-venv-md) pour éviter les conflits de version de bibliothèques Python.

## Documentation

* [docs.ansible.com - Basic Concepts](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html)
* [docs.ansible.com - Getting started with Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)
  * [docs.ansible.com - How to build your inventory](https://docs.ansible.com/ansible/2.9/user_guide/intro_inventory.html)
* [docs.ansible.com - Best Practices](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_best_practices.html#best-practices)


## Quelques exemples

* [github.com - mborne/vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox) : Configurer des VM de DEV avec Ansible.
* [github.com - mborne/geostack-deploy - ansible](https://github.com/mborne/geostack-deploy/tree/master/ansible#readme) déploiement de GeoStack sur les VM [vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox)
* [github.com - mborne/k3s-deploy](https://github.com/mborne/k3s-deploy#k3s-deploy) : Déployer un cluster Kubernetes avec [K3S](https://k3s.io/) sur les VM [vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox).
* [github.com - osm-fr/ansible-scripts](https://github.com/osm-fr/ansible-scripts#readme) illustre l'utilisation de Ansible pour la gestion des [machines OSM France](https://github.com/osm-fr/ansible-scripts/blob/master/hosts)
