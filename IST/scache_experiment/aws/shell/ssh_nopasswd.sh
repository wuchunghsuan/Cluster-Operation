#!/bin/bash
. ./functions.sh

ssh-keygen -t rsa
cp -r /root/.ssh ../

function ssh_copy_function() {
        IP=$1
        PORT=$2
        FROM=$3
        PASSWD=$4
        #echo -e " SCP IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} FROM:${BLUE}$FROM${END} TO:${BLUE}$TO${END}"
        CMD="ssh-copy-id -i $FROM -p $PORT $IP"

        expect_function "$CMD" $PASSWD
}

FROM=~/.ssh/id_rsa.pub
export -f ssh_copy_function expect_function
parallel ssh_copy_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $PASSWD
