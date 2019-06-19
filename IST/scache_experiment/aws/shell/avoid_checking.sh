#!/bin/bash
. ./functions.sh

function avoid_checking {
        IP=$1
        PORT=$2
        FROM=$3
        PASSWD=$4
        CMD="ssh -o \"StrictHostKeyChecking no\" -p $PORT $IP ls"

        expect_function "$CMD" $PASSWD
}

export -f avoid_checking expect_function
parallel avoid_checking ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $PASSWD
