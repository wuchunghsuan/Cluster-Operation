#!/bin/bash
. ./functions.sh

KEY1=PermitRootLogin
KEY2=PasswordAuthentication
FILE=/etc/ssh/sshd_config
#chmod +x $FILE
CMD="chmod +x $FILE && sed -i \"/$KEY1/{s/$KEY1.*/$KEY1 yes/}\" $FILE && sed -i \"/$KEY2/{s/$KEY2.*/$KEY2 yes/}\" $FILE && systemctl restart sshd"

#ssh -p 1022 192.168.2.11 "$CMD"

export -f ssh_pem_function
parallel ssh_pem_function ::: "${IPS[@]}" ::: $PORT ::: $CMD ::: ../pem/renrui.pem
