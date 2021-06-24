#!/bin/bash
#This script to gen_Key and copy pub key to server, run on client 
#NOTICE: user was added to that server, authen with password

genkey() {
	ssh-keygen -q -N '' -m PEM -t rsa -f "$HOME/.ssh/id_rsa" <<< ""$'\n'"y" 2>&1 >/dev/null
}

if [[ ! -d $HOME/.ssh ]]; then
	genkey
fi

if [[ $? -eq 0 ]]; then
	echo "Done gen key"
fi


echo "Enter your IP"
read _myip
echo "Enter your username to ssh"
read _username
echo "Enter your password"
read -s _password



echo $_password | sshpass ssh-copy-id -f -i "$HOME/.ssh/id_rsa.pub" $_username@$_myip 2>&1 >/dev/null

#SSH to Server
ssh $_username@$_myip "cat /etc/os-release"
