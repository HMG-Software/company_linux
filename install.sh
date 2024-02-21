#! /bin/bash

# HMG setup script for Pop!_OS 20.04 (focal/jammy based)
# This script is meant to be run after the initial installation of the OS
# as root or on 1st boot with sudo
# author: @nkia-christoph "Christoph Kröppl"


# update system and install requirements
echo "\n# Update system and install requirements\n"
apt update
apt upgrade -y
apt dist-upgrade -y
apt install -y \
    snapd squashfs-tools \
    ca-certificates curl gnupg  lsb-release python3-pip jq \
    git gh make caffeine gnome-tweaks nautilus-admin vlc obs-studio \
    openconnect network-manager-openconnect network-manager-openconnect-gnome \
    openvpn network-manager-openvpn network-manager-openvpn-gnome openfortivpn \
    pylint pylint-odoo


# Docker
echo "\n# Installing Docker\n"
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo jammy) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io


# Chrome
echo "\n# Installing Chrome\n"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb


# 1Passwd
# GUI
echo "\n# Installing 1Password GUI\n"
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
apt install -y ./1password-latest.deb
rm -f 1password-latest.deb

# CLI
echo "\n# Installing 1Password CLI\n"
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb
apt install -y ./1password-cli-amd64-latest.deb
rm -f "1password-cli-amd64-latest.deb"


# Code
echo "\n# Installing Visual Studio Code\n"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | \
    apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y
apt update
apt install -y code

# configure
cat code/extensions.txt | while read extension || [[ -n $extension ]];
do
    runuser -l hmg -c "code --install-extension $extension --force"
done
cp code/settings.json ~/.config/Code/User/settings.json


# Zoom
echo "\n# Installing Zoom\n"
flatpak update
flatpak install -y zoom


# cleanup and upgrade
echo "\n# Cleanup and upgrade\n"
apt clean -y
apt autoremove -y
apt autoclean -y
pop-upgrade recovery upgrade from-release


# set profile pic
echo "\n# Set profile pic\n"
mkdir -p /usr/share/pixmaps/hmg
chmod 755 /usr/share/pixmaps/hmg
cp pop/bullet.png /usr/share/pixmaps/hmg/bullet.png
chmod 755 /usr/share/pixmaps/hmg/bullet.png
sed -i '/Icon=/c\Icon=/usr/share/pixmaps/hmg/bullet.png' "/var/lib/AccountsService/hmg"
