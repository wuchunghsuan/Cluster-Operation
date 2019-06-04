#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

. ./ip.sh

JOB_ID=$1
#WORKERS=(192.168.2.16 192.168.2.12)
EXPOSE_DIR=/log/nodemanager/log/*
OUTPUT_DIR=/root/log-scale-test
OPS_LOG=/root/ops.log

echo -e "${BLUE}Pull log ${RED}$JOB_ID${END}"

mkdir $OUTPUT_DIR

for WORKER in ${IPS[@]}; do
	echo -e "${BLUE}SCP log from ${RED}${WORKER}${GREEN}:${EXPOSE_DIR}${BLUE} to ${GREEN}${OUTPUT_DIR}/${END}"
	scp -q -r ${WORKER}:${EXPOSE_DIR} ${OUTPUT_DIR}/worker-${WORKER}

	scp -q -r ${WORKER}:${OPS_LOG} ${OUTPUT_DIR}/worker-${WORKER}
done
