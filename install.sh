#!/bin/bash

# HMG Setup script for Pop!_OS 20.04 (Focal Fossa based)
# Pls run with sudo or as root
# author: @nkia-christoph


# HMG Pop/Cosmic/Gnome defaults
# to find the right settings, run`dconf watch /` while making changes in GUI
# then confirm with `gsettings get SCHEMA KEY`
cat pop/settings.txt | while read setting || [[ -n $setting ]];
do
    runuser -l hmg -c "$setting"
done


# update system and install requirements
apt update
apt upgrade -y
apt dist-upgrade -y
apt install -y \
    snapd \
    ca-certificates curl gnupg  lsb-release python3-pip jq \
    git gh make caffeine gnome-tweaks nautilus-admin vlc obs-studio \
    openconnect network-manager-openconnect network-manager-openconnect-gnome \
    openvpn network-manager-openvpn network-manager-openvpn-gnome openfortivpn \
    pylint pylint-odoo


# Docker
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo focal) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io


# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb


# 1Passwd
# GUI
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
apt install -y "1password-latest.deb"
rm -f 1password-latest.deb

# CLI
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb
apt install -y "1password-cli-amd64-latest.deb"
rm -f "1password-cli-amd64-latest.deb"


# Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | \
    apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt update
apt install -y code

# configure
cat code/extensions.txt | while read extension || [[ -n $extension ]];
do
    runuser -l hmg -c "code --install-extension install $extension --force"
done
cp code/settings.json ~/.config/Code/User/settings.json


# Pycharm
snap install pycharm-community --classic
# runuser -l hmg -c "idea.sh installPlugins EditorConfig"


# Zoom
flatpak update
flatpak install -y zoom


# cleanup and upgrade
apt clean -y
apt autoremove -y
apt autoclean -y
pop-upgrade recovery upgrade from-release

# Manual Steps:
# - Docker Post-Installation steps
# - Setting usr passwds
