#!/usr/bin/env bash


echo "####################################"
echo "Script to Deploy Docker Engine - CLI"
echo "####################################"


echo "1. Remove docker exist..."
sudo apt-get remove docker docker-engine docker.io containerd runc

sleep 2

echo "2. Install Yum-utilitys..."
sudo apt update -y

echo "3. Add repo of Docker!!!"

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sleep 2

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null



echo "4. Install Docker!!!"
 sudo apt-get update -y

 sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo Done
echo "#######################################"

systemctl enable --now docker 
docker run hello-world