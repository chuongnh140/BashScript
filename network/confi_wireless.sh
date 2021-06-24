#!/bin/bash
###############################
#    Author: chuongnh140      #
###############################
GREEN="\e[32m"
BLUE="\e[34m"
REDLI="\e[91m"
YELLOW="\e[33m"
BLULI="\e[94m"
END="\e[0m"

_versionUbuntu=$(cat /etc/*os-release | grep PRETTY_NAME | sed 's/PRETTY_NAME=//')

echo -e "${BLUE}Script for config network in Ubuntu with NMCLI Tools${END}"

echo -e "${BLUE}Download and Install NMCLI${END}"

#sudo apt-get update -y
#sudo apt install network-manager -y


clear

nmcli device wifi list

echo "####################################"
echo -n -e "${GREEN}SSID want to connect: ${END}"
read _ssidName
echo -n -e "${GREEN}Password: ${END}"
read -s _password

echo "####################################"
nmcli device wifi connect $_ssidName password $_password




