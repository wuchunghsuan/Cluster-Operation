#!/bin/bash
NAME="aggregation"
SIZE=$1
MAP=$2
REDUCE=$3
CONFFILE="/root/HiBench/conf/hibench.conf"
CONFFILE2="/root/HiBench/conf/workloads/sql/aggregation.conf"

conf(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 CONF $NAME-${SIZE}M-$MAP-$REDUCE              "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	sed -i -e '3d' -e "2a hibench.scale.profile                   huge" 			$CONFFILE
	sed -i -e '5d' -e "4a hibench.default.map.parallelism         $MAP" 			$CONFFILE
	sed -i -e '8d' -e "7a hibench.default.shuffle.parallelism     $REDUCE" 			$CONFFILE
	sed -i -e '61d' -e "60a hibench.workload.dir.name.input         Input-${SIZE}M-$MAP-$REDUCE" $CONFFILE
	sed -i -e '8d' -e "7a hibench.${NAME}.huge.uservisits                  ${SIZE}000000" 	$CONFFILE2
	sed -i -e '22d' -e "21a hibench.workload.input                  \${hibench.hdfs.data.dir}/Aggregation/Input-${SIZE}M-$MAP-$REDUCE"   $CONFFILE2
	echo "hibench.default.map.parallelism         $MAP"
	echo "hibench.default.shuffle.parallelism     $REDUCE"
	echo "hibench.${NAME}.huge.uservisits                  ${SIZE}000000"
	echo "hibench.workload.dir.name.input         Input-${SIZE}M-$MAP-$REDUCE"
	echo "hibench.workload.input                  \${hibench.hdfs.data.dir}/Aggregation/Input-${SIZE}M-$MAP-$REDUCE"
}

prepare(){
	echo "-------------------------------------------------------------------"
        echo "|                                                                 |"
        echo "|                 PREPARE $NAME-${SIZE}M-$MAP-$REDUCE              "
        echo "|                                                                 |"
        echo "-------------------------------------------------------------------"
	/root/HiBench/bin/workloads/sql/aggregation/prepare/prepare.sh
}

conf
prepare
