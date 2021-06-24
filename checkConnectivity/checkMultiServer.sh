#!/usr/bin/env bash
#import color to script
#file chua ip phai thua 1 dong cuoi moi check dc het IP(co the se ko can)
. ../color.sh
_fileIP="./listServer"

#cat /r o cuoi moi dong (co the co hoac khong)
#sed -i 's/\r//g' $_fileIP

while IFS= read -r ip
do
   #echo $ip
   #IFS= (or IFS='') prevents leading/trailing whitespace from being trimmed.
   #-r prevents backslash escapes from being interpreted.
   ping -c 1 $ip &> /dev/null
   if [[ $? == 0 ]]; then
       echo -e "${GREEN} $ip is okay${END}"
    else
        echo -e "${REDLI} $ip can't connect${END}" 
   fi
done <$_fileIP
