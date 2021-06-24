#!/usr/bin/env bash

#import color to script
. ../color.sh

if [ "$#" == "0" ]; then
	echo -e "${YELLOW}Usage:bash <namefile> <ip> <port1> <port2> ... <portN>${END}"
	exit 1
fi

_ip=$1
shift
for item in "$@" ; do
    nc -zv $_ip $item > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN} $item is open on $_ip ${END}"
    else
        echo -e "${REDLI} $item is close on $_ip ${END}"
    fi
done

