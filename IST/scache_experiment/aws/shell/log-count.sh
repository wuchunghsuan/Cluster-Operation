#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
END="\033[0m"

JOB_ID=$1
EXPOSE_DIR=/root/log-scale-test
OUTPUT_DIR=/root/report-scale-test/$JOB_ID
OUTPUT_FILE=${OUTPUT_DIR}/report
OUTPUT_TIME_FILE=${OUTPUT_DIR}/report_time

echo -e "${BLUE}Count phase time ${RED}$JOB_ID${END}"

mkdir -p $OUTPUT_DIR
if [ -e $OUTPUT_FILE ]; then
	rm -f $OUTPUT_FILE
fi
touch $OUTPUT_FILE

for WORKER_DIR in `ls $EXPOSE_DIR | grep worker`; do
        for LOG_DIR in `ls $EXPOSE_DIR/$WORKER_DIR/$JOB_ID`; do
                if [ -d $EXPOSE_DIR/$WORKER_DIR/$JOB_ID/$LOG_DIR ]; then
                        LOG_FILE=$EXPOSE_DIR/$WORKER_DIR/$JOB_ID/$LOG_DIR/stdout

                        TEST=`cat $LOG_FILE |grep reduceTask`
                        if [ $TEST ]; then
                                log=`cat $LOG_FILE |grep reduceTask`
                                echo ${log} >> $OUTPUT_FILE
                        fi
                        TEST=`cat $LOG_FILE |grep mapTask`
                        if [ $TEST ]; then
                                log=`cat $LOG_FILE |grep mapTask`
                                echo ${log} >> $OUTPUT_FILE
                        fi

                fi
        done
done
