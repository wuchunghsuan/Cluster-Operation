#!/bin/bash
. ./functions.sh
#Terasort
cd ../../HiBench/terasort/
function pre_run() {
	ST=$1
	SIZE=$2
	MAP=$3
	REDUCE=$4
	JAR=$5
	/root/hadoop-2.7.5/bin/hadoop fs -rm -r /Hibench/HiBench/
	./prepare.sh $SIZE $MAP $REDUCE  
	./conf_slowstart.sh $ST
	./run.sh $SIZE $MAP $REDUCE "no-report" $JAR
}
function pre() {
	ST=$1
	SIZE=$2
	MAP=$3
	REDUCE=$4
	JAR=$5
	./prepare.sh $SIZE $MAP $REDUCE  
}
function run() {
        ST=$1
        SIZE=$2
        MAP=$3
        REDUCE=$4
        JAR=$5
        ./conf_slowstart.sh $ST
        ./run.sh $SIZE $MAP $REDUCE "no-report" $JAR
}

scp_origin_jar
stop_yarn
start_yarn

pre 1 64 256 58 "origin"

run 1 64 256 58 "origin"

scp_scache_jar
stop_yarn
start_yarn

run 0.6 64 256 58 "scache"

#scp_origin_jar
#stop_yarn
#start_yarn
#
#pre_run 1 1600 800 800 "origin"
#
#scp_scache_jar
#stop_yarn
#start_yarn
#
#run 0.8 1600 800 800 "scache"


#pre_run 1 1200 400 400 "origin"
#pre_run 1 1200 800 800 "origin"
#pre_run 1 1200 1600 1600 "origin"
#scp_scache_jar
#stop_yarn
#start_yarn
#


