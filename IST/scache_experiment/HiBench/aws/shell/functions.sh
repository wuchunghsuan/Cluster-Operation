#!/bin/bash
. ./ip.sh

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

PASSWD=1234qwer
HADOOP_DIR=/root/hadoop-2.7.5
HADOOP_CONF_DIR=${HADOOP_DIR}/etc/hadoop

export SHELL=/bin/bash

echo -e "-> [${YELLOW}LOAD FUNCTIONS${END}]"

function tar_hadoop() {
	echo -e " tar -xf ${BLUE}../tar/hadoop-2.7.5.tar ../bin/${END}"
	tar -xf ../tar/hadoop-2.7.5.tar ../bin/
}
function tar_HiBench() {
	echo -e " tar -xf ${BLUE}../tar/HiBench.tar ../bin/${END}"
        tar -xf ../tar/HiBench.tar ../bin/
}
function scp_function() {
	IP=$1
	PORT=$2
	FROM=$3
	TO=$4
	PASSWD=$5
	echo -e " SCP IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} FROM:${BLUE}$FROM${END} TO:${BLUE}$TO${END}"
	CMD="scp -P $PORT $FROM $IP:$TO"
	
	expect_function "$CMD" $PASSWD
}
function ssh_function() {
	IP=$1
	PORT=$2
	RUN=$3
	PASSWD=$4
	echo -e " SSH IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} CMD:${BLUE}$CMD${END}"
	CMD="ssh -p $PORT $IP \"${RUN}\""	

	expect_function "$CMD" $PASSWD
}
function expect_function() {
	CMD=$1
	PASSWD=$2
	expect -c "
		set timeout 2000
		spawn $CMD;
		expect {
			\"password:\" {send \"${PASSWD}\r\"; exp_continue}
			\"(yes/no)?\" {send \"yes\r\"; exp_continue}
		}
	"
}

function scp_hadoop() {
	FROM=../tar/hadoop-2.7.5.tar
	TO=/root/

	echo -e "-> [${YELLOW}SCP HADOOP${END}]"

	export -f scp_function expect_function
	parallel scp_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD
}
function tar_hadoop() {
	CMD="tar -xf /root/hadoop-2.7.5.tar && rm hadoop-2.7.5.tar"

	echo -e "-> [${YELLOW}TAR HADOOP${END}]"
	
	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD
}
function start_hadoop() {
	CMD1=${HADOOP_DIR}/sbin/yarn-daemon.sh start resourcemanager
	CMD2=${HADOOP_DIR}/sbin/yarn-daemon.sh start nodemanager

	echo -e "-> [${YELLOW}START HADOOP${END}]"

	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: $CMD2 ::: $PASSWD
}
function conf_hadoop() {
        FILE=${HADOOP_CONF_DIR}/${1}
        KEY=$2
        VALUE=$3

        #LINE=`grep -n ${KEY} ${HADOOP_CONF_DIR}/${FILE} | grep "[0-9]*" -o`
        #LINE=`expr $LINE + 1`

        sed -i "/${KEY}/{n;s/<value>.*<\/value>/<value>${VALUE}<\/value>/}" $FILE
        echo -e "$BLUE [${KEY}]${END} = ${GREEN}${VALUE}${END}"
}











