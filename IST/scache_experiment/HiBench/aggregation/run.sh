#!/bin/bash
NAME="aggregation"
SIZE=$1
MAP=$2
REDUCE=$3
CONFFILE="/root/HiBench/conf/hibench.conf"
CONFFILE2="/root/HiBench/conf/workloads/sql/aggregation.conf"
REPORTDIR=$4

conf(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 CONF $NAME-${SIZE}G-$MAP-$REDUCE              "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	sed -i -e '3d' -e "2a hibench.scale.profile                   huge" 			$CONFFILE
	sed -i -e '5d' -e "4a hibench.default.map.parallelism         $MAP" 			$CONFFILE
	sed -i -e '8d' -e "7a hibench.default.shuffle.parallelism     $REDUCE" 			$CONFFILE
	sed -i -e '8d' -e "4a hibench.${NAME}.huge.uservisits                  ${SIZE}000000" 	$CONFFILE2
	echo "hibench.default.map.parallelism         $MAP"
	echo "hibench.default.shuffle.parallelism     $REDUCE"
	echo "hibench.${NAME}.huge.uservisits                  ${SIZE}000000"
}

prepare(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 PREPARE $NAME-${SIZE}M-$MAP-$REDUCE              "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	/root/HiBench/bin/workloads/sql/aggregation/prepare/prepare.sh
}

run(){
	echo "-------------------------------------------------------------------"
	echo "|                                                                 |"
	echo "|                 RUN $NAME-${SIZE}M-$MAP-$REDUCE-$1                 "
	echo "|                                                                 |"
	echo "-------------------------------------------------------------------"
	echo "$NAME-${SIZE}G-$MAP-$REDUCE-$1" >> ${REPORTDIR}/time.report
	(time /root/HiBench/bin/workloads/sql/aggregation/hadoop/run.sh) 2>> ${REPORTDIR}/time.report
	echo "Sleep 10s. Wait for report."
	sleep 10
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
prepare

int=1
while(( $int<=1 ))
do
	run $int
	copy $int
	let "int++"
done
