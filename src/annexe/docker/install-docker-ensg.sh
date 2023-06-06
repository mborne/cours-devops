#!/bin/bash

#-----------------------------------------------------------------------------------
# Installation de docker spécifique à ENSG :
# - dns
# - proxy sortant
# - plage IP (à adapter?)
# - quelques options de sécurité (c.f. https://github.com/mborne/ansible-docker-ce/blob/master/defaults/main.yml)
#
# Procédure officielle :
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
#-----------------------------------------------------------------------------------

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Must be run as root (use sudo)"
    exit
fi

#---------------------------------------------------------------------------------------------------
# Installation des outils par défaut
#---------------------------------------------------------------------------------------------------
apt-get update
apt-get install -y apt-transport-https \
    ca-certificates gnupg-agent \
    software-properties-common

#---------------------------------------------------------------------------------------------------
# Installation de docker
#---------------------------------------------------------------------------------------------------

# clé GPG
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-compose-plugin
HTTP_PROXY=http://10.0.4.2:3128"
Environment="HTTPS_PROXY=http://10.0.4.2:3128"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
' > /etc/systemd/system/docker.service.d/proxy.conf
#---------------------------------------------------------------------------------------------------
# Configuration du démon docker
#---------------------------------------------------------------------------------------------------
echo '
{
    "data-root": "/var/lib/docker",
    "storage-driver": "overlay2",

    "userns-remap": "default",

    "dns": ["172.31.40.10", "172.31.40.31"],
    "bip": "192.168.100.1/24",
    "fixed-cidr": "192.168.100.1/29",
    "default-address-pools": [
        {"base":"172.80.0.0/16","size":24},
        {"base":"172.90.0.0/16","size":24}
    ],

    "icc": false,
    "live-restore": true,
    "userland-proxy": false,
    "no-new-privileges": true,

    "debug": false,

    "log-driver": "syslog"
}
' > /etc/docker/daemon.json

#---------------------------------------------------------------------------------------------------
# On écrase /etc/default/docker où http_proxy, https_proxy et no_proxy sont désormais vidées
#---------------------------------------------------------------------------------------------------
echo '
# MBorne : removed http_proxy, https_proxy and no_proxy definitions

# Customize location of Docker binary (especially for development testing).
#DOCKERD="/usr/local/bin/dockerd"

# Use DOCKER_OPTS to modify the daemon startup options.
#DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
' > /etc/default/docker


#---------------------------------------------------------------------------------------------------
# On configure le proxy
#---------------------------------------------------------------------------------------------------
mkdir -p /etc/systemd/system/docker.service.d
echo '
[Service]
Environment="HTTP_PROXY=http://10.0.4.2:3128"
Environment="HTTPS_PROXY=http://10.0.4.2:3128"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
' > /etc/systemd/system/docker.service.d/proxy.conf

#---------------------------------------------------------------------------------------------------
# Ajout de vagrant au groupe docker
# (docker sans sudo)
#---------------------------------------------------------------------------------------------------
adduser vagrant docker

#---------------------------------------------------------------------------------------------------
# On redémarre docker
#---------------------------------------------------------------------------------------------------
systemctl daemon-reload
systemctl restart docker.service
