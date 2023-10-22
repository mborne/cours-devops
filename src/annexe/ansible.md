
# Ansible

[[toc]]

## Pré-requis

* Une machine ou VM sous Linux (voir [docs.ansible.com - Can Ansible run on Windows?](https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows))
* [Configurer les variables d'environnement pour utilisation d'un proxy sortant](proxy-sortant/proxy-env-vars.md)

## Installation

* [docs.ansible.com - Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html#installation-guide) pour la méthode officielle.
* [gist.github.com - mborne/ansible-venv-md - Ansible dans un environnement virtuel Python](https://gist.github.com/mborne/eeb3a0177fe27f5ed393a00eded0a86f#file-ansible-venv-md) pour une méthode permettant d'éviter les conflits de version de bibliothèques Python.

## Les principaux exécutables

Ansible se décompose en plusieurs programmes permettant de gérer les machines d'un inventaire :

| Exécutable                                                                            | Fonction                                                                                                         |
|---------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| [ansible](https://docs.ansible.com/ansible/latest/cli/ansible.html)                   | Exécuter une tâche sur les machines d'un inventaire                                                              |
| [ansible-playbook](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html) | Exécuter une liste de tâche (playbook) sur les machines d'un inventaire                                          |
| [ansible-galaxy](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html)     | Création et téléchargement de playbook partagés via [galaxy.ansible.com](https://galaxy.ansible.com/) ou via git |
| [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)       | Gestion de fichiers chiffrés pour le stockage des secrets                                                        |

## Quelques exemples

* [github.com - mborne/vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox) qui permet de configurer des VM de DEV avec Ansible.
* [github.com - mborne/geostack-deploy - ansible](https://github.com/mborne/geostack-deploy/tree/master/ansible#readme) qui illustre le déploiement de GeoStack sur les VM [vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox)
* [github.com - mborne/k3s-deploy](https://github.com/mborne/k3s-deploy#k3s-deploy) qui permet de déployer un cluster Kubernetes avec [K3S](https://k3s.io/) sur les VM [vagrantbox](https://github.com/mborne/vagrantbox#vagrantbox).
* [github.com - osm-fr/ansible-scripts](https://github.com/osm-fr/ansible-scripts#readme) qui illustre l'utilisation de Ansible pour la gestion des [serveurs openstreetmap.fr](https://github.com/osm-fr/ansible-scripts/blob/master/hosts)

## Ressources

* [docs.ansible.com - Basic Concepts](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html)
* [docs.ansible.com - Getting started with Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)
  * [docs.ansible.com - How to build your inventory](https://docs.ansible.com/ansible/2.9/user_guide/intro_inventory.html)
* [docs.ansible.com - Best Practices](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_best_practices.html#best-practices)
* [Ansible Galaxy](https://galaxy.ansible.com/) qui présente les dépôt de playbook partagés.
