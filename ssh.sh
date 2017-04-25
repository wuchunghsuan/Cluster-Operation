#!/bin/bash
function work() {
	command="ssh root@$1 \"echo 123\""

        pw=passwd

        expect -c "
                set timeout 2000
                spawn $command;
                expect {
                       \"password:\" {send \"$pw\r\"; exp_continue}
                       \"(yes/no)?\" {send \"yes\r\"; exp_continue}
                  }
        "
}

ips=()
for ((i=1;i<11;i++)); do
        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=yourip-0$num
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
