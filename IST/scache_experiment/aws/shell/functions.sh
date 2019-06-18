#!/bin/bash
. ./ip.sh

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

PASSWD=1234qwer
HADOOP_DIR=/root/hadoop-2.8.5
HADOOP_CONF_DIR=${HADOOP_DIR}/etc/hadoop
HOME=/root/Cluster-Operation/IST/scache_experiment/aws

export SHELL=/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/

echo -e "-> [${YELLOW}LOAD FUNCTIONS${END}]"

### TOOL FUNCTIONS ###
function scp_function() {
	IP=$1
	PORT=$2
	FROM=$3
	TO=$4
	PASSWD=$5
	#echo -e " SCP IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} FROM:${BLUE}$FROM${END} TO:${BLUE}$TO${END}"
	CMD="scp -P $PORT $FROM $IP:$TO"
	
	expect_function "$CMD" $PASSWD
}
function scp_pem_function() {
	IP=$1
        PORT=$2
        FROM=$3
        TO=$4
        PEM=$5

	scp -i $PEM -P $PORT $FROM ec2-user@$IP:$TO
}
function scp_dir_function() {
        IP=$1
        PORT=$2
        FROM=$3
        TO=$4
        PASSWD=$5
        #echo -e " SCP IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} FROM:${BLUE}$FROM${END} TO:${BLUE}$TO${END}"
        CMD="scp -P $PORT -r $FROM $IP:$TO"

        expect_function "$CMD" $PASSWD
}
function ssh_function() {
	IP=$1
	PORT=$2
	RUN=$3
	PASSWD=$4
	#echo -e " SSH IP:${GREEN}$IP${END} PORT:${GREEN}$PORT${END} CMD:${BLUE}$RUN${END}"
	CMD="ssh -p $PORT $IP \"${RUN}\""	
	
	expect_function "$CMD" $PASSWD
}
function ssh_pem_function() {
	IP=$1
        PORT=$2
        RUN=$3
        PEM=$4

	#ssh -i $PEM -p $PORT $IP "${RUN}"
	CMD="ssh -i $PEM -p $PORT ec2-user@$IP \"${RUN}\""
	
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
function conf_hadoop_function_ip() {
	IP=$1
	PORT=$2
	FILE=$3
	KEY=$4
	VALUE=$6
	PASSWD=$5
	
	CMD="sed -i \\\"/${KEY}/{n;s/<value>.*<\\\/value>/<value>${IP}${VALUE}<\\\/value>/}\\\" $FILE"
	ssh_function $IP $PORT "$CMD" $PASSWD
}
function conf_hadoop_function() {
        IP=$1
        PORT=$2
        FILE=$3
        KEY=$4
        VALUE=$6
        PASSWD=$5

        CMD="sed -i \\\"/${KEY}/{n;s/<value>.*<\\\/value>/<value>${VALUE}<\\\/value>/}\\\" $FILE"
        ssh_function $IP $PORT "$CMD" $PASSWD
}

### APP FUNCTIONS ###
function scp_conf() {
        FROM=../conf/*
        TO=/root/hadoop-2.8.5/etc/hadoop/

        echo -e "-> [${YELLOW}SCP CONF${END}]"

        export -f scp_function expect_function
        parallel scp_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

        echo -e "<- [${RED}SCP CONF${END}]"
}
function scp_hadoop() {
	FROM=../tar/hadoop-2.8.5.tar
	TO=/root/

	echo -e "-> [${YELLOW}SCP HADOOP${END}]"

	export -f scp_function expect_function
	parallel scp_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

	echo -e "<- [${RED}SCP HADOOP${END}]"
}
function scp_ops() {
        FROM=../tar/ops.tar
        TO=/root/

        echo -e "-> [${YELLOW}SCP OPS${END}]"

        export -f scp_function expect_function
        parallel scp_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

        echo -e "<- [${RED}SCP OPS${END}]"
}
function scp_hosts() {
	FROM=/etc/hosts
	TO=/etc/hosts

	echo -e "-> [${YELLOW}SCP HOSTS${END}]"

	export -f scp_function expect_function
	parallel scp_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

	echo -e "<- [${RED}SCP HOSTS${END}]"
}
function scp_etcd() {
        FROM=./etcd.sh
        TO=/root/

        echo -e "-> [${YELLOW}SCP ETCD${END}]"
	ip=()
	for i in 0 1 2 3 4 5 6 7; do
		echo ${IPS[$i]}
		ip=(${ip[@]} ${IPS[$i]})
	done
	echo ${ip[@]}
        export -f scp_function expect_function
        parallel scp_function ::: ${ip[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

        echo -e "<- [${RED}SCP ETCD${END}]"
}
function start_etcd() {
	echo -e "-> [${YELLOW}START ETCD${END}]"
        ip=()
        for i in 0 1 2 3 4 5 6 7; do
                echo ${IPS[$i]}
                ip=(${ip[@]} ${IPS[$i]})
        done
        echo ${ip[@]}

	CMD1="/root/etcd.sh "
	export -f ssh_function expect_function
        parallel ssh_function ::: "${ip[@]}" ::: $PORT ::: "$CMD1" ::: $PASSWD

	echo -e "<- [${RED}STOP ETCD${END}]"
}
function scp_origin_jar() {
	tar -xf ${HOME}/jar/origin.tar
	FROM=./mapreduce
        TO=/root/hadoop-2.8.5/share/hadoop/

	echo -e "-> [${YELLOW}SCP ORIGIN JAR${END}]"

	export -f scp_dir_function expect_function
        parallel scp_dir_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

	echo -e "-> [${YELLOW}SCP ORIGIN JAR${END}]"
	
	rm -rf mapreduce
}
function scp_ops_jar() {
        tar -xf ${HOME}/jar/ops_jar.tar
        FROM=./mapreduce
        TO=/root/hadoop-2.8.5/share/hadoop/

        echo -e "-> [${YELLOW}SCP OPS JAR${END}]"

        export -f scp_dir_function expect_function
        parallel scp_dir_function ::: ${IPS[@]} ::: $PORT  ::: $FROM ::: $TO ::: $PASSWD

        echo -e "-> [${YELLOW}SCP OPS JAR${END}]"

        rm -rf mapreduce
}
function tar_ops() {
        CMD="tar -xf /root/ops.tar && rm ops.tar"

        echo -e "-> [${YELLOW}TAR OPS${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

        echo -e "<- [${RED}TAR OPS${END}]"
}
function tar_hadoop() {
	CMD="tar -xf /root/hadoop-2.8.5.tar && rm hadoop-2.8.5.tar"

	echo -e "-> [${YELLOW}TAR HADOOP${END}]"
	
	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

	echo -e "<- [${RED}TAR HADOOP${END}]"
}
function mount_disk() {
	CMD="mkfs -t ext4 /dev/xvdba && mkdir /ebs ; mount /dev/xvdba /ebs"

	echo -e "-> [${YELLOW}MOUNT DISK${END}]"
	
	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

	echo -e "<- [${RED}MOUNT DISK${END}]"
}
function mount_disk2() {
	CMD="mkfs -t ext4 /dev/xvdbb && mkdir /ebs2 ; mount /dev/xvdbb /ebs2"

	echo -e "-> [${YELLOW}MOUNT DISK${END}]"
	
	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

	echo -e "<- [${RED}MOUNT DISK${END}]"
}
function install_wondershaper() {
        CMD="yum install -y git ; git clone https://github.com/magnific0/wondershaper.git"

        echo -e "-> [${YELLOW}INSTALL WONDERSHAPER${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

        echo -e "<- [${RED}INSTALL WONDERSHAPER${END}]"
}
function run_wondershaper() {
        CMD="/root/wondershaper/wondershaper -a eth0 -d 300000 -u 300000"

        echo -e "-> [${YELLOW}RUN WONDERSHAPER${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

        echo -e "<- [${RED}RUN WONDERSHAPER${END}]"
}
function remove_wondershaper() {
        CMD="/root/wondershaper/wondershaper -c -a eth0"

        echo -e "-> [${YELLOW}REMOVE WONDERSHAPER${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

        echo -e "<- [${RED}REMOVE WONDERSHAPER${END}]"
}
function install_docker() {
#	CMD="yum update -y && yum install -y docker && systemctl start docker"
	#CMD="amazon-linux-extras install docker -y"
	CMD="systemctl start docker && docker pull quay.io/coreos/etcd:latest"

        echo -e "-> [${YELLOW}INSTALL DOCKER${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

        echo -e "<- [${RED}INSTALL DOCKER${END}]"
}
function install_java() {
	CMD="yum update -y && yum install -y java-1.8.0-openjdk-devel.x86_64"

	echo -e "-> [${YELLOW}INSTALL JAVA${END}]"

	export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD" ::: $PASSWD

	echo -e "<- [${RED}INSTALL JAVA${END}]"
}
function clean_hdfs() {
        CMD1="rm -rf /dir/hadoop/datanode/current/"

        echo -e "-> [${YELLOW}CLEAN HADOOP${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD1" ::: $PASSWD

        echo -e "<- [${RED}CLEAN HADOOP${END}]"
}
function clean_hadoop() {
        CMD1="rm -rf ${HADOOP_DIR}"

        echo -e "-> [${YELLOW}CLEAN HADOOP${END}]"

        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD1" ::: $PASSWD

        echo -e "<- [${RED}CLEAN HADOOP${END}]"
}
function start_ops() {
        CMD1="export JAVA_HOME=${JAVA_HOME} && cd /root/OPS/scripts && ./start-master.sh"
	CMD2="export JAVA_HOME=${JAVA_HOME} && cd /root/OPS/scripts && ./start-worker.sh"

        echo -e "-> [${YELLOW}START OPS${END}]"

        #$CMD1
        ssh_function $MASTER $PORT "$CMD1" $PASSWD
        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

        echo -e "<- [${RED}START OPS${END}]"
}
function stop_ops() {
        CMD1="export JAVA_HOME=${JAVA_HOME} && cd /root/OPS/scripts && ./stop.sh"
        CMD2="export JAVA_HOME=${JAVA_HOME} && cd /root/OPS/scripts && ./stop.sh"

        echo -e "-> [${YELLOW}STOP OPS${END}]"

        #$CMD1
        ssh_function $MASTER $PORT "$CMD1" $PASSWD
        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

        echo -e "<- [${RED}STOP OPS${END}]"
}
function start_yarn() {
	CMD1="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/yarn-daemon.sh start resourcemanager"
	CMD2="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/yarn-daemon.sh start nodemanager"

	echo -e "-> [${YELLOW}START YARN${END}]"

	#$CMD1
	ssh_function $MASTER $PORT "$CMD1" $PASSWD
	export -f ssh_function expect_function
	parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

	echo -e "<- [${RED}START YARN${END}]"
}
function stop_yarn() {
        CMD1="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/yarn-daemon.sh stop resourcemanager"
        CMD2="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/yarn-daemon.sh stop nodemanager"

        echo -e "-> [${YELLOW}STOP YARN${END}]"

        #$CMD1
	ssh_function $MASTER $PORT "$CMD1" $PASSWD
        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

	echo -e "<- [${RED}STOP YARN${END}]"
}
function start_hdfs() {
        CMD1="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/hadoop-daemon.sh start namenode"
        CMD2="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/hadoop-daemon.sh start datanode"

        echo -e "-> [${YELLOW}START HDFS${END}]"

        #$CMD1
	ssh_function $MASTER $PORT "$CMD1" $PASSWD
        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

        echo -e "<- [${RED}START HDFS${END}]"
}
function stop_hdfs() {
        CMD1="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/hadoop-daemon.sh stop namenode"
        CMD2="export JAVA_HOME=${JAVA_HOME} && ${HADOOP_DIR}/sbin/hadoop-daemon.sh stop datanode"

        echo -e "-> [${YELLOW}STOP HDFS${END}]"

        #$CMD1
	ssh_function $MASTER $PORT "$CMD1" $PASSWD
        export -f ssh_function expect_function
        parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD

        echo -e "<- [${RED}STOP HDFS${END}]"
}
function format_hdfs() {
        CMD1="export JAVA_HOME=${JAVA_HOME}; ${HADOOP_DIR}/bin/hadoop namenode -format"

        echo -e "-> [${YELLOW}FORMAT HDFS${END}]"

        ssh_function $MASTER $PORT "$CMD1" $PASSWD

        echo -e "<- [${RED}FORMAT HDFS${END}]"
}
function conf_hadoop_master() {
        FILE=${HADOOP_CONF_DIR}/${1}
        KEY=$2
        VALUE=$3

        #LINE=`grep -n ${KEY} ${HADOOP_CONF_DIR}/${FILE} | grep "[0-9]*" -o`
        #LINE=`expr $LINE + 1`
	echo -e "-> [${YELLOW}CONF HADOOP MASTER${END}]"
        sed -i "/${KEY}/{n;s/<value>.*<\/value>/<value>${VALUE}<\/value>/}" $FILE
        echo -e "$BLUE [${KEY}]${END} = ${GREEN}${VALUE}${END}"

	echo -e "<- [${RED}CONF HADOOP MASTER${END}]"
}
function conf_hadoop_slaves_ip() {
        FILE=${HADOOP_CONF_DIR}/${1}
        KEY=$2
	VALUE=$3

        echo -e "-> [${YELLOW}CONF HADOOP SLAVES IP${END}]"
        
	#CMD="sed -i "/${KEY}/{n;s/<value>.*<\/value>/<value>${VALUE}<\/value>/}" $FILE"
        #echo -e "$BLUE [${KEY}]${END} = ${GREEN}${VALUE}${END}"
	#echo ${VALUES[@]}
	#CMDS=()
	#for VAL in ${VALUES[*]}; do
	#	CMD="sed -i \"/${KEY}/{n;s/<value>.*<\/value>/<value>${VAL}<\/value>/}\" $FILE"
	#	CMDS=( ${CMDS[@]} "$CMD" )
	#	echo -e "$BLUE [${KEY}]${END} = ${GREEN}${VAL}${END}"
	#done


	export -f conf_hadoop_function_ip ssh_function expect_function
        parallel conf_hadoop_function_ip ::: "${IPS[@]}" ::: $PORT ::: $FILE ::: $KEY ::: $PASSWD ::: $VALUE

	echo -e "<- [${RED}CONF HADOOP SLAVES ${1}${END}]"
}
function conf_hadoop_slaves() {
        FILE=${HADOOP_CONF_DIR}/${1}
        KEY=$2
        VALUE=$3

        echo -e "-> [${YELLOW}CONF HADOOP SLAVES${END}]"

        export -f conf_hadoop_function ssh_function expect_function
        parallel conf_hadoop_function ::: "${IPS[@]}" ::: $PORT ::: $FILE ::: $KEY ::: $PASSWD ::: $VALUE

	echo -e "<- [${RED}CONF HADOOP SLAVES ${1}${END}]"
}
function test_slaves() {
	FILE=test.test
        KEY=test
        VALUE="test"
        conf_hadoop_slaves $FILE $KEY $VALUE
}







echo -e "<- [${RED}LOAD FUNCTIONS${END}]"
