#!/bin/bash

./conf_slowstart.sh $1

REPORTDIR="/root/report-aggregation-ST$1"
mkdir $REPORTDIR 

./run.sh 100 56 56 $REPORTDIR
./run.sh 100 128 128 $REPORTDIR
./run.sh 100 256 256 $REPORTDIR

./run.sh 300 56 56 $REPORTDIR
./run.sh 300 128 128 $REPORTDIR
./run.sh 300 256 256 $REPORTDIR

./run.sh 500 56 56 $REPORTDIR
./run.sh 500 128 128 $REPORTDIR
./run.sh 500 256 256 $REPORTDIR

#./run.sh 1000 56 56 $REPORTDIR
./run.sh 1000 128 128 $REPORTDIR
./run.sh 1000 256 256 $REPORTDIR

#./run.sh 2000 56 56 $REPORTDIR
#./run.sh 2000 128 128 $REPORTDIR
./run.sh 2000 256 256 $REPORTDIR
