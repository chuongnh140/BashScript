#!/bin/bash


#import color to script
. ../color.sh
_host=$1
ping -c 1 $_host > /dev/null 2>&1

if [[ $? != 0 ]]; then
    echo -e "${REDLI}Can't connect to $_host${END}"
    #${REDLI}Invalid choise!!!${END}
else
    echo -e "${GREEN}Connect Successfully to $_host${END}"
fi

