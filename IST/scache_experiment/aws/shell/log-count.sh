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

                        TEST=`cat $LOG_FILE |grep shuffle-start`
                        if [ $TEST ]; then
                                shuffle_start=`cat $LOG_FILE |grep shuffle-start`
                                shuffle_stop=`cat $LOG_FILE |grep shuffle-stop`
                                reduce_start=`cat $LOG_FILE |grep reduce-start`
                                reduce_stop=`cat $LOG_FILE |grep reduce-stop`
                                echo ${shuffle_start} >> $OUTPUT_TIME_FILE
                                echo ${shuffle_stop} >> $OUTPUT_TIME_FILE
                                echo ${reduce_start} >> $OUTPUT_TIME_FILE
                                echo ${reduce_stop} >> $OUTPUT_TIME_FILE
                                task=`cat $LOG_FILE |grep task`
                        	#Shuffle
                                TIME=`expr \`echo ${shuffle_stop} | awk -F - '{print $2}'\` - \`echo ${shuffle_start} | awk -F - '{print $2}'\``
                                NAME_SIZE=`echo $task |awk -F - '{print $2"\t"$3}'`
                                echo "Shuffle	${NAME_SIZE}   ${TIME}" >> $OUTPUT_FILE
                                #Reduce
                                TIME=`expr \`echo ${reduce_stop} |awk -F - '{print $2}'\` - \`echo ${reduce_start} |awk -F - '{print $2}'\``
                                NAME=`echo ${reduce_stop} |awk -F - '{print $3}'`
                                echo "Reduce    ${NAME}   ${TIME}" >> $OUTPUT_FILE
                        fi
                        TEST=`cat $LOG_FILE |grep map-start`
                        if [ $TEST ]; then
                                map_start=`cat $LOG_FILE |grep map-start`
                                map_stop=`cat $LOG_FILE |grep map-stop`
                                echo ${map_start} >> $OUTPUT_TIME_FILE
                                echo ${map_stop} >> $OUTPUT_TIME_FILE
                                #Map
                                TIME=`expr \`echo ${map_stop} | awk -F - '{print $2}'\` - \`echo ${map_start} | awk -F - '{print $2}'\``
                                NAME=`echo ${map_stop} | awk -F - '{print $3}'`
                                echo "Map       ${NAME}   ${TIME}" >> $OUTPUT_FILE
                        fi

                fi
        done
done
