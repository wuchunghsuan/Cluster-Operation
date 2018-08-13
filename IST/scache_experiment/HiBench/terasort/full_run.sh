#!/bin/bash

REPORTDIR=$1
mkdir $REPORTDIR 

#./conf_slowstart.sh $2
#./run.sh 100 400  200 $REPORTDIR
#./conf_slowstart.sh $3
#./run.sh 100 800  200 $REPORTDIR
#./conf_slowstart.sh $4
#./run.sh 100 1600 200 $REPORTDIR

#./conf_slowstart.sh $2
#./run.sh 200 400  200 $REPORTDIR
#./conf_slowstart.sh $3
#./run.sh 200 800  200 $REPORTDIR
./conf_slowstart.sh $4
./run.sh 200 1600 200 $REPORTDIR

#./conf_slowstart.sh $2
#./run.sh 400 400  200 $REPORTDIR
#./conf_slowstart.sh $3
#./run.sh 400 800  200 $REPORTDIR
#./conf_slowstart.sh $4
#./run.sh 400 1600 200 $REPORTDIR

#./conf_slowstart.sh $2
#./run.sh 800 400  200 $REPORTDIR
#./conf_slowstart.sh $3
#./run.sh 800 800  200 $REPORTDIR
#./conf_slowstart.sh $4
#./run.sh 800 1600 200 $REPORTDIR
