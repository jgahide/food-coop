#!/bin/sh

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White


EchoInfo=$Cyan
EchoError=$Red

# On s'assure que seul root peut executer ce script.
if [ $(id -u) !=  0 ]; then
   echo "${EchoError}Le script d'installation d'odoo saveur La louve doit être executé en tant que super utilisateur (root). ${Color_Off}"
   exit 1
fi

echo "${EchoInfo}Assurons nous que Debian est bien à jour.${Color_Off}"
apt-get -qq update
apt-get -qq -y upgrade

echo "${EchoInfo}Installation des outils système...${Color_Off}"
apt-get -qq -y install vim git

echo "${EchoInfo}Installation des paquets nécéssaire pour l'execution de pip install ...${Color_Off}"

packages="python-pip python-dev python-setuptools
libjpeg62-turbo-dev zlib1g-dev
libsasl2-dev libldap2-dev libssl-dev
libxml2-dev libxslt1-dev
gcc"

for f in $packages
do
	echo "${EchoInfo}Installation du paquet $f ${Color_Off}"
	apt-get install -qq -y $f > /dev/null
done

echo "${EchoInfo}Installation de nodejs...${Color_Off}"
apt-get -qq -y install postgresql
apt-get -qq -y install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
apt-get -qq -y install nodejs

echo "${EchoInfo}Nodejs version : $(node -v) ${Color_Off}"
echo "${EchoInfo}npm version : $(npm -v) ${Color_Off}"

echo "${EchoInfo}Using npm to install less...${Color_Off}"
npm install -g less

if [ grep -c '^username:' /etc/passwd == 0 ]; then
	echo "${EchoInfo}Ajout de l'utilisateur Odoo dans le système.${Color_Off}"
	adduser odoo
else
	echo "${EchoInfo}L'utilisateur Odoo existe déjà, étape sautée.${Color_Off}"
fi

echo "${EchoInfo}Ajout de l'utilisateur Odoo dans la base de donnée.${Color_Off}"
sudo su - postgres -c "createuser -s odoo"

cd /home/odoo
echo "${EchoInfo}Téléchargement de Odoo La Louve (git)${Color_Off}"
su -c "git clone https://github.com/AwesomeFoodCoops/odoo-production.git" odoo
cd /home/odoo/odoo-production/odoo/

echo "${EchoInfo}Installation des dependances pour Odoo${Color_Off}"
su -c "python -m pip install wheel" odoo
su -c "python -m pip install -r requirements.txt" odoo

echo "${EchoInfo}Il est maintenant possible de lancer odoo avec la commande : ${Color_Off}"
echo "${EchoInfo}/home/odoo/odoo-production/odoo/odoo.py --addons-path=addons --db-filter=mydb$ ${Color_Off}"
