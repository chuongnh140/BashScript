#!/bin/bash


echo -n "Amount of file want to creat: "
read _amount

for (( i = 1; i <= $_amount; i++ )); do
	echo -n "Name of file: "
	read _name
	mkdir $_name
done
