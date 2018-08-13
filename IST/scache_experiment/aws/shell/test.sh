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
	/root/hadoop-2.7.5/bin/hadoop fs -rm -r /Hibench/HiBench/Terasort/Input*
	./prepare.sh $SIZE $MAP $REDUCE  
	./conf_slowstart.sh $ST
	./run.sh $SIZE $MAP $REDUCE "no-report" $JAR
}


scp_origin_jar
stop_yarn
start_yarn

pre_run 1 400 400 200 "origin"
pre_run 1 400 800 200 "origin"
pre_run 1 400 1600 200 "origin"
scp_scache_jar
stop_yarn
start_yarn

pre_run 1 400 400 200 "scache"
pre_run 1 400 800 200 "scache"
pre_run 1 400 1600 200 "scache"

