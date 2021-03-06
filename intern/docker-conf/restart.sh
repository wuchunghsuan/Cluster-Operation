#!/bin/bash
echo SCP
function work() {
        command="ssh root@$1 \"systemctl daemon-reload && service docker restart\""

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
for ((i=27;i<31;i++)); do
        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=Node-0$num
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
