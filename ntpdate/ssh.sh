#!/bin/bash
function work() {
	command="ssh root@$1 \"sed -i 's/^NTPSERVERS/#NTPSERVERS/g' /etc/default/ntpdate\""

        pw=yourpw

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
for ((i=1;i<=5;i++)); do
        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=Node-$num
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
