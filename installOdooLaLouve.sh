#!/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${RED}Installation du système...${NC}"
apt-get -qq -y install vim
apt-get -qq -y install git

echo "${RED}Installation des paquets pour l'execution de pip install ...${NC}"

apt-get -qq -y install python-pip
apt-get -q -y install python-dev
apt-get -qq -y install python-setuptools
apt-get -qq -y install libjpeg62-turbo-dev zlib1g-dev
apt-get -q -y install libsasl2-dev python-dev libldap2-dev libssl-dev
apt-get -q -y install libxml2-dev libxslt1-dev

#exit 


echo "${RED}Ajout de l'utilisateur Odoo.${NC}"
adduser odoo

su -c whoami odoo
echo -e "su fait"
cd /home/odoo
echo "${RED}Téléchargement de Odoo La Louve (git)${NC}"
su -c "git clone https://github.com/AwesomeFoodCoops/odoo-production.git" odoo
cd /home/odoo/odoo-production/odoo/
su -c "pip install wheel" odoo
su -c "pip install -r requirements.txt" odoo

