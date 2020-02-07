#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

. ./ip.sh


function work() {
        echo "Scp ops jar to $1"
	scp /root/transfer/spark-nvm/* $1:/root/spark-2.4.3/jars/
}

export -f work
parallel work ::: "${IPS[@]}"
