#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

JOB_ID=$1
EXPOSE_DIR=/root/log-scale-test
OUTPUT_DIR=/root/report-scale-test/
OUTPUT_FILE=${OUTPUT_DIR}/report_ops

echo -e "${BLUE}Count phase time ${RED}$JOB_ID${END}"

mkdir -p $OUTPUT_DIR
if [ -e $OUTPUT_FILE ]; then
	rm -f $OUTPUT_FILE
fi
touch $OUTPUT_FILE

for WORKER_DIR in `ls $EXPOSE_DIR | grep worker`; do
        LOG_FILE=$EXPOSE_DIR/$WORKER_DIR/ops.log
        for LOG in `cat $LOG_FILE |grep "\[OPS\]"`; do
             echo $LOG >> $OUTPUT_FILE
        done
done
