#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

IPS=( 13.56.233.14 54.153.124.198 13.57.253.255 54.67.121.67)
PORT=22
#for ((i=1;i<5;i++)); do
#        #if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
#        #ip=127.17.0.$num
#        IP=192.168.2.1$i
#	IPS=( ${IPS[@]} $IP )
#done
MASTER=${IPS[0]}

echo " IPS:"
length=${#IPS[@]}
for ((i=0; i<length; i++))
do
	echo -e "${GREEN}	${IPS[$i]}${END}"
done
echo -e " PORT:${GREEN}$PORT${END}"
echo -e " MASTER:${GREEN}$MASTER${END}"
