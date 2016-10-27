#/bin/bash

curl -X GET -H 'Content-Type: application/json' http://172.168.2.106:4243/containers/json?all=1 |python -mjson.tool | grep Id > container_Id
containers=()
for line in `cat container_Id`
do
        if echo $line | grep -q "Id"
                then continue;
        fi
        #echo ${line:1:64}
        containers=( ${containers[@]} ${line:1:64})
done

echo ${containers[@]}

while true
do
	rm id result
	touch id result 
	
	function work2() {
		curl -X POST -H 'Content-Type: application/json' -d '{"AttachStdin": false,"AttachStdout": true,"AttachStderr": true,"Tty": false,"Cmd":["/opt/arda/watchdog"]}' http://172.168.2.106:4243/containers/$1/exec >> id
 	}
	
	export -f work2
	parallel work2 ::: "${containers[@]}"

	#for container in ${containers[@]}
	#do
	#	curl -X POST -H 'Content-Type: application/json' -d '{"AttachStdin": false,"AttachStdout": true,"AttachStderr": true,"Tty": false,"Cmd":["/opt/arda/watchdog"]}' http://172.168.2.106:4243/containers/$container/exec >> id
	#done
	
	ids=()
	for line in `cat id` 
	do
		echo ${line:7:64}
	        ids=( ${ids[@]} ${line:7:64})
	done
	
	echo "EXEC ID:"
	echo ${ids[@]}
	
	function work() {
		echo "Start: $1"
		curl -X POST -H 'Content-Type: application/json' -d '{"Detach": false,"Tty": false}' http://172.168.2.106:4243/exec/$1/start
	}

	export -f work
	parallel work ::: "${ids[@]}"
	sleep 2s
done
