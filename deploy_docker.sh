#!/usr/bin/env bash

echo "####################################"
echo "Script to Deploy Docker Engine - CLI"
echo "####################################"


echo "1. Remove docker exist..."
sudo yum remove docker \
                 docker-client \
                 docker-client-latest \
                 docker-common \
                 docker-latest \
                 docker-latest-logrotate \
                 docker-logrotate \
                 docker-engine
sleep 2

echo "2. Install Yum-utilitys..."
sudo yum install -y yum-utils

echo "3. Add repo of Docker!!!"

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sleep 2

echo "4. Install Docker!!!"
sudo yum install docker-ce docker-ce-cli containerd.io -y

echo Done
echo "#######################################"
docker run hello-world 
