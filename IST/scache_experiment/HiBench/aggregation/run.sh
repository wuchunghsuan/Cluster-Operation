#!/bin/bash
NAME="aggregation"
SIZE=$1
MAP=$2
REDUCE=$3
CONFFILE="/root/HiBench/conf/hibench.conf"
CONFFILE2="/root/HiBench/conf/workloads/sql/aggregation.conf"
REPORTDIR=$4
JAR=$5

conf(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 CONF $NAME-${SIZE}M-$MAP-$REDUCE              "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	sed -i -e '3d' -e "2a hibench.scale.profile                   huge" 			$CONFFILE
	sed -i -e '5d' -e "4a hibench.default.map.parallelism         $MAP" 			$CONFFILE
	sed -i -e '8d' -e "7a hibench.default.shuffle.parallelism     $REDUCE" 			$CONFFILE
	sed -i -e '18d' -e "17a hibench.report.dir              /root/report-$NAME-$JAR-${SIZE}G-$MAP-$REDUCE" $CONFFILE
	sed -i -e '61d' -e "60a hibench.workload.dir.name.input         Input-${SIZE}M-$MAP-$REDUCE" $CONFFILE
	sed -i -e '8d' -e "7a hibench.${NAME}.huge.uservisits                  ${SIZE}000000" 	$CONFFILE2
	sed -i -e '22d' -e "21a hibench.workload.input                  \${hibench.hdfs.data.dir}/Aggregation/Input-${SIZE}M-$MAP-$REDUCE"   $CONFFILE2
	echo "hibench.default.map.parallelism         $MAP"
	echo "hibench.default.shuffle.parallelism     $REDUCE"
	echo "hibench.${NAME}.huge.uservisits                  ${SIZE}000000"
}

run(){
	echo "-------------------------------------------------------------------"
	echo "|                                                                 |"
	echo "|                 RUN $NAME-${SIZE}M-$MAP-$REDUCE-$1                 "
	echo "|                                                                 |"
	echo "-------------------------------------------------------------------"
	/root/HiBench/bin/workloads/sql/aggregation/hadoop/run.sh
	echo "Sleep 60s. Wait for report."
	sleep 60
}

copy(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 COPY $NAME-${SIZE}M-$MAP-$REDUCE-$1                 "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	echo "COPY"
	echo " /root/HiBench/report/aggregation/hadoop/"
	echo "TO" 
	echo "${REPORTDIR}/report-$NAME-${SIZE}M-$MAP-$REDUCE-$1/"
	mkdir ${REPORTDIR}/report-$NAME-${SIZE}M-$MAP-$REDUCE-$1
        cp -r /root/HiBench/report/aggregation/hadoop/ ${REPORTDIR}/report-$NAME-${SIZE}M-$MAP-$REDUCE-$1/
}

conf

int=1
while(( $int<=1 ))
do
	run $int
#	copy $int
	let "int++"
done
