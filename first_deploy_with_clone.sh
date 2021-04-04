#!/bin/#!/usr/bin/env bash

echo -n "Enter hostname: "

read _hostname

hostnamectl set-hostname $_hostname

echo "##########################"
_nameOfNetworkCard=`ip a | grep ens | sed -n '1p' | awk '{print $2}' | sed 's/://'`
echo "Config IP Address with NMCLI"
echo -n "Enter IP of this machine: "
read _ip
echo -n "Subnet: "
read _subnet
echo -n "GateWay: "
read _gateway
echo -n "DNS: "
read _dns
echo "Method manual is default"
nmcli con mod $_nameOfNetworkCard ipv4.address $_ip/$_subnet
nmcli con mod $_nameOfNetworkCard ipv4.gateWay $_gateway
nmcli con mod $_nameOfNetworkCard ipv4.dns $_dns
nmcli con mod $_nameOfNetworkCard ipv4.method manual
nmcli con mod $_nameOfNetworkCard autoconnect on


echo "##########################"
echo "Config SELINUX..."
sleep 5
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

echo "Machine is restarting..."
echo "Ctrl C and connect again after 30 second!!!"
nmcli con up $_nameOfNetworkCard
init 6

 
