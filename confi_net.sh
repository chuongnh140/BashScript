#!/bin/bash
###############################
#    Author: chuongnh140      #
###############################
GREEN="\e[32m"
BLUE="\e[34m"
REDLI="\e[91m"
YELLOW="\e[33m"
END="\e[0m"

echo -e "${BLUE}Script for config network in Ubuntu with NMCLI Tools${END}"

_network_card_show=$(nmcli con show | awk '{print $4}' | grep -v DEVICE)

function manualConfig() {
echo -n "Enter IP of this machine: "
read _ip
echo -n "Subnet(24,23,..): "
read _subnet
echo -n "GateWay: "
read _gateway
echo -n "DNS: "
read _dns
nmcli con mod $1 ipv4.address $_ip/$_subnet
nmcli con mod $1 ipv4.gateWay $_gateway
nmcli con mod $1 ipv4.dns $_dns
nmcli con mod $1 ipv4.method manual
nmcli con mod $1 autoconnect on
nmcli con up $1
}

function dhcpConfig() {
  nmcli con mod $1 ipv4.method auto
  nmcli con mod $1 autoconnect on
  nmcli con up $1
}

function showIP() {
  nmcli con show $1 | grep ipv4 --color
}

echo -e "${BLUE}Download and Install NMCLI${END}"

sudo apt-get update -y
sudo apt install network-manager -y

_network_card_show=$(nmcli con show | awk '{print $4}' | grep -v DEVICE)

echo -e "${BLUE}Check network_card...${END}"
if [[ $_network_card_show == '' ]]; then
  echo -e "${REDLI}Can't see any network_card${END}"
  echo -e "${REDLI}Please check and run script again!!!${END}"
  exit 1
else
  echo "#######################"
  echo -e "${YELLOW}Network card existing: ${END}"
  echo -e "${GREEN}$_network_card_show${END}"
fi

echo "#############################################"
echo -n -e "${BLUE}Type name of network_card want to modify: ${END}"
read _cardName

while [[ true ]]; do
  echo -e "${BLUE}Config method Manual or DHCP ?${END}"
  echo -e """${YELLOW}
  Type 1. Manual
  Type 2. DHCP
  ${END}"""
  echo -e -n "${BLUE}Type 1 or 2: ${END}"
  read _choise

  if [[ $_choise == 1 ]]; then
    manualConfig $_cardName
    break
  elif [[ $_choise == 2 ]]; then
    dhcpConfig $_cardName
    break
  else
    echo -e "${REDLI}Invalid choise!!!${END}"
  fi
done

showIP $_cardName