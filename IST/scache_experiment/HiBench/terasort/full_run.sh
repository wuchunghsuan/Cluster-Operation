#!/bin/bash

./conf_slowstart.sh $1

REPORTDIR="/root/report-ST$1"
mkdir $REPORTDIR 

./run.sh 100 400  200 $REPORTDIR
./run.sh 100 800  200 $REPORTDIR
./run.sh 100 1600 200 $REPORTDIR

./run.sh 200 400  200 $REPORTDIR
./run.sh 200 800  200 $REPORTDIR
./run.sh 200 1600 200 $REPORTDIR

#./run.sh 400 400  200 $REPORTDIR
#./run.sh 400 800  200 $REPORTDIR
#./run.sh 400 1600 200 $REPORTDIR
#
#./run.sh 800 400  200 $REPORTDIR
#./run.sh 800 800  200 $REPORTDIR
#./run.sh 800 1600 200 $REPORTDIR
