#!/bin/bash
function work() {
        command="ssh root@$1 \"source /etc/profile \n /root/hadoop-2.7.5/sbin/hadoop-daemon.sh start datanode\""

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

/root/hadoop-2.7.5/sbin/hadoop-daemon.sh start namenode
/root/hadoop-2.7.5/sbin/hadoop-daemon.sh start datanode

ips=()
for ((i=2;i<5;i++)); do
#        if [ $i -lt 10 ]; then num=0$i; else num=$i; fi
        ip=192.168.0.17$i
        ips=( ${ips[@]} $ip )
done

export -f work
parallel work ::: "${ips[@]}"
