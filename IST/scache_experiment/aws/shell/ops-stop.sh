#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

. ./ip.sh


function work() {
        echo "Stop Ops-Worker $1"
        ssh $1 "export OPS_HOME=/root/OPS && cd /root/OPS/scripts/ && ./ops.sh worker stop"
}

export -f work
parallel work ::: "${IPS[@]}"
