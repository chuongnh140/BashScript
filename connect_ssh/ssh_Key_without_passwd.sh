#!/bin/bash
echo -n "Type username to add SSH: "
read _userName
_check_user_exist=`cat /etc/passwd | grep $_userName`

if [[ $_check_user_exist != '' ]]; then
	echo "User $_userName is exist!!!"
else
	useradd $_userName -s $(which bash) -m -d /home/$_userName
	echo "Done add user $_userName!!!"
fi	



mkdir -p /home/$_userName/.ssh
chmod 700 /home/$_userName/.ssh
chown $_userName:$_userName /home/$_userName/.ssh


echo """
In there, cut/paste your public ssh key, on ONE LINE (That is very important!!!)

Do not add the email@example.com at the end of the line.
Do not add the BEGIN PUBLIC KEY or END PUBLIC KEY.
Do not add the rsa-key-20090614 at the end.
Make sure, there is ssh-rsa at the beginning.
"""
echo "Paste publicKey of $_userName"
read _pubKey

echo "$_pubKey" > /home/$_userName/.ssh/authorized_keys
chown $_userName:$_userName /home/$_userName/.ssh/authorized_keys
chmod 600 /home/$_userName/.ssh/authorized_keys 

echo "$_userName  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

echo "Done!!! Now you can SSH to Server with user $_userName"
