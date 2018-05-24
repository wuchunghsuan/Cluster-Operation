#!/bin/bash
echo SCP
function work() {
	echo "Scp $1."
	pw=1234qwer
        command="scp domain.crt $1:/usr/local/share/ca-certificates"

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
for ((i=11;i<=15;i++)); do
        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=gondolin-node-0$num
        ips=( ${ips[@]} $ip )
done
ips=( ${ips[@]} 172.168.2.126 )
ips=( ${ips[@]} 172.168.2.167 )



export -f work
parallel work ::: "${ips[@]}"
#parallel work ::: "172.168.2.102"
