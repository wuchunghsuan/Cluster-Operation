#!/bin/bash
. ./functions.sh
#Terasort
cd ../../HiBench/terasort/
#scp_origin_jar
#stop_yarn
#start_yarn
./full_prepare.sh
#./full_run.sh "/root/report-terasort-origin" 1 1 1
#scp_scache_jar
#stop_yarn
#start_yarn
#./full_run.sh "/root/report-terasort" 0.6 0.8 0.9

