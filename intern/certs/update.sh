#!/bin/bash
echo SCP
function work() {
	command="ssh root@$1 \"update-ca-certificates && service docker restart\""

        pw=1234qwer

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
for ((i=10;i<=15;i++)); do
        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=node-0$num
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
