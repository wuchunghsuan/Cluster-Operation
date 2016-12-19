#!/bin/bash
echo SCP
function work() {
	echo "Scp $1."
	pw=yourpw
        command="scp hostname-$1 root@$1:/etc/hostname"

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
        ip=172.1.1.1$num
	echo "Node-0$i" > hostname-$ip
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
