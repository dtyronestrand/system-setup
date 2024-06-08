#!/bin/bash
#
# Ubuntu Setup
#
# Ainsley Clark, ainsley.dev - 15/01/2022

echo "************************************************"
echo "***    Welcome to the Ubuntu System Setup    ***"
echo "************************************************"
echo ""

# Variables
PHP_VERSION="8.2"
GOLANG_VERSION="1.17.5"

# Check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Git Variables
echo "What name do you want to use in git user.name?"
read git_config_user_name

echo "What email do you want to use in git user.email?"
read git_config_user_email

# Copy dot files
echo "Copying config files"
cp ./editorconfig ~/.editorconfig
cp ./.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore

# Updates
echo "Running updates"
apt-get -y update
apt-get -y upgrade

# Curl / Wget
echo "Installing curl"
apt-get install -y curl

# Git
echo 'Installing latest git'
add-apt-repository ppa:git-core/ppa -y
apt-get -y update && apt-get install git -y

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

# Docker
echo "Installing Docker"
wget https://gist.githubusercontent.com/welel/f80c96482e3b539487b9fa08bfcab86d/raw/90bc2330924d225aef7dc3178f5926bda7daff04/install_docker.sh
chmod +x install_docker.sh
./install_docker.sh
systemctl start docker
systemctl enable docker
usermod -aG docker "dev"

# Chrome
echo "Installing Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb

# Edge
echo "Installing Edge"
apt install -y software-properties-common apt-transport-https
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
apt-get -y update && apt install -y microsoft-edge-dev


# Node/NPM
echo "Installing node"
apt-get -y update && apt install nodejs -y

# PHP
echo "Installing PHP $PHP_VERSION"
apt -y install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get -y update && apt -y install php$PHP_VERSION

# Python
echo "Installing python"
apt-get install python3-pip -y

# MySQL
echo "Installing NySQL and MySQL client"
apt-get install mysql-server -y
apt-get install mysql-client -y

# Nginx
echo "Installing Nginx"
apt-get -y update && apt install nginx -y

# VS Code
echo "Installing VS Code"
snap install code --classic

# Jetbrains
echo "Installing Jetbrains Toolbox"
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash

# Dev tools
echo "Installing dev tools"

# Hugo
apt-get -y update && apt-get install -y hugo

# ZSH
echo 'Installing ZSH'
apt install -y zsh

# Image / Video Optimisation
echo "Installing image and video optimisation CLI's"
apt-get install -y webp
apt-get install -y optipng
apt-get install -y jpegoptim
apt-get install -y ffmpeg

# Inject Envs
echo 'export PATH="/usr/local/opt/php@$PHP_VERSION/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/usr/local/opt/php@$PHP_VERSION/sbin:$PATH"' >> ~/.zshrc
echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc

# Oh My ZSH (Last)
echo "Installing Oh My ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
zsh

echo ""
echo "************************************************"
echo "***    Finished, now run ./post-install      ***"
echo "************************************************"
