#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

. ./ip.sh

function prepare_sort() {
	SIZE=${1}000000
	MAP=$2
	REDUCE=$3
	NAME=$(($SIZE/1000000000))
	COMMAND="/root/hadoop-2.8.5/bin/hadoop \
--config /root/hadoop-2.8.5/etc/hadoop \
jar /root/hadoop-2.8.5/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar \
randomtextwriter \
-D mapreduce.randomtextwriter.totalbytes=${SIZE} \
-D mapreduce.randomtextwriter.bytespermap=$((${SIZE}/${MAP})) \
-D mapreduce.job.maps=${MAP} \
-D mapreduce.job.reduces=${REDUCE} \
hdfs://${MASTER}:9000/HiBench/Sort/Input-${NAME}G"
	echo -e "${BLUE}Docker exec hadoop-master:${END}"
	echo -e "${GREEN}$COMMAND${END}"
	#docker exec hadoop-master $COMMAND
	$COMMAND
}

function run_sort() {
        SIZE=${1}000000
        MAP=$2
        REDUCE=$3
        NAME=$(($SIZE/1000000000))
	RM_COMMAND="/root/hadoop-2.8.5/bin/hadoop fs -rm -r -skipTrash /HiBench/Sort/Output-${NAME}G"
	COMMAND="/root/hadoop-2.8.5/bin/hadoop \
--config /root/hadoop-2.8.5/etc/hadoop \
jar /root/hadoop-2.8.5/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar \
sort \
-outKey org.apache.hadoop.io.Text \
-outValue org.apache.hadoop.io.Text \
-r ${REDUCE} \
hdfs://${MASTER}:9000/HiBench/Sort/Input-${NAME}G \
hdfs://${MASTER}:9000/HiBench/Sort/Output-${NAME}G"
	echo -e "${BLUE}Docker exec hadoop-master:${END}"
	echo -e "${GREEN}$RM_COMMAND${END}"
	$RM_COMMAND
        echo -e "${GREEN}$COMMAND${END}"
        $COMMAND
}
#prepare_sort 5000 32 32

prepare_sort 102400 512 128 
sleep 10
run_sort 102400 512 128
sleep 10
run_sort 102400 512 128

