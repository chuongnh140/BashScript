#!/bin/bash


echo -n "Amount of user want to creat: "
read _amount

for (( i = 1; i <= $_amount; i++ )); do
	  echo -n "Name of user: "
	    read _name
	      useradd $_name -m -d /home/$_name -s $(which bash)
      done
