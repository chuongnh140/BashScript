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

echo -e "${BLUE}Script for config network in Ubuntu with NMCLI Tools${END}"


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

function addConNetwork() {
  echo -e "${YELLOW}Only can add type Ethernet in this Script!!!${END}"
  sleep 3
  nmcli con add con-name $1 ifname $1 type ethernet
}

function configNetworkFile() {
  cat <<EOF > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
[keyfile]
unmanaged-devices=none
EOF
systemctl restart NetworkManager
}


echo -e "${BLUE}Download and Install NMCLI${END}"

sudo apt-get update -y
sudo apt install network-manager -y

_deviceConnect=$(nmcli d | grep -v DEVICE |awk '$3 == "connected"{print $1}')
_deviceDisConnect=$(nmcli d | grep -v DEVICE |awk '$3 == "disconnected"{print $1}')
_deviceUnmanage=$(nmcli d | grep -v DEVICE |awk '$3 == "unmanaged"{print $1}')
clear
echo -e "${BLUE}Check network_card...${END}"
echo "#############################################"
echo -e "${YELLOW}Network card existing: ${END}"
echo -e "${GREEN}$_deviceConnect${END}"
echo "---------------------------------------------"
echo -e "${REDLI}$_deviceDisConnect${END}"
echo "---------------------------------------------"
echo -e "${BLULI}$_deviceUnmanage${END}"
echo "---------------------------------------------"
echo -e """${YELLOW}Notice:
  ${GREEN}Green Color${END} stand for network_Card can edit!!!
  ${REDLI}Red Color${END} stand for can't edit, need to add connection to modify this device!!!
  ${BLULI}Blue Color${END} stand for unManage Device, need to be config file service NetworkManager!!!
${END}
"""
echo "#############################################"



while [[ true ]]; do
 echo -n -e "${BLUE}Type name of network_card want to modify: ${END}"
 read _cardName
 if [[ $_cardName != "" ]]; then
   break
 fi
done



_checkStatus=$(nmcli d | grep $_cardName | awk '{print $3}')
if [[ $_checkStatus == "disconnected" ]]; then
  echo -e "${GREEN}Network Card need to be add Connection!!!${END}"
  addConNetwork $_cardName
elif [[ $_checkStatus == "unmanaged" ]]; then
  echo -e "${GREEN}Edit file of Service NetworkManger and Restart Service!!!${END}"
  configNetworkFile
  addConNetwork $_cardName
else
  addConNetwork $_cardName
fi

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
echo "Done"
