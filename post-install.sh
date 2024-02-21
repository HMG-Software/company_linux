#! /bin/bash
# Post-Installation
# This script is meant to be run after the initial installation of the OS
# It is meant to be run as a regular user, not as root or with sudo


# Docker Post-Installation steps
echo "\n# Docker Post-Installation steps\n"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


# Pycharm
echo "\n# Installing Pycharm\n"
sudo snap refresh
sudo snap install pycharm-community --classic


# HMG Pop/Cosmic/Gnome defaults
# to find the right settings, run`dconf watch /` while making changes in GUI
# then confirm with `gsettings get SCHEMA KEY`
echo "\n# Setting up HMG defaults\n"
cat pop/settings.txt | while read setting || [[ -n $setting ]];
do
    bash "$setting"
done


# Set user password
echo "\n# Set user password\n"
sudo passwd $USER


# Setup encryption pw
echo "\n# Add user's encryption password\n"
sudo cryptsetup luksAddKey /dev/nvme0n1p3 -S 1
