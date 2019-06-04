#!/bin/bash

function run() {
	JOB_ID=$1
	echo "log-count ${JOB_ID}"
	./log-count.sh $JOB_ID &
	echo "log-fetch ${JOB_ID}"
	./log-fetch.sh $JOB_ID &
}

IDS=(
application_1559633219982_0010
application_1559633219982_0011
)

for ID in ${IDS[@]}; do
	run $ID
done
./log-ops.sh
