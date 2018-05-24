#!/bin/bash
echo SCP
function work() {
	echo "Scp $1."
	pw=1234qwer
        command="scp -r /root/transfer/hadoop $1:/root/hadoop-2.7.5/share/"

        expect -c "
		set timeout 2000
                spawn $command;
                expect {
                       \"password:\" {send \"$pw\r\"; exp_continue}
                       \"(yes/no)?\" {send \"yes\r\"; exp_continue}
                  }
        "

}

cp -r /root/transfer/hadoop /root/hadoop-2.7.5/share/

ips=()
for ((i=2;i<5;i++)); do
        #if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=192.168.0.17$i
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
