#!/bin/bash

./conf_slowstart.sh $1

REPORTDIR="/root/report-ST$1"
mkdir $REPORTDIR 

./run.sh 16 128 52 $REPORTDIR
./run.sh 32 256 52 $REPORTDIR
./run.sh 48 384 52 $REPORTDIR
./run.sh 64 512 52 $REPORTDIR
./run.sh 80 640 52 $REPORTDIR
./run.sh 96 768 52 $REPORTDIR
./run.sh 112 896 52 $REPORTDIR
./run.sh 128 1024 52 $REPORTDIR
./run.sh 144 1152 52 $REPORTDIR
./run.sh 160 1280 52 $REPORTDIR
