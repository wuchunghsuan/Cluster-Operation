#!/bin/bash
. ./functions.sh

KEY1=PermitRootLogin
KEY2=PasswordAuthentication
FILE=/etc/ssh/sshd_config

CMD1="echo -e \\\"1234qwer\\\n1234qwer\\\" | sudo passwd"

CMD2="chmod +x $FILE && sed -i \\\"/$KEY1/{s/$KEY1.*/$KEY1 yes/}\\\" $FILE && sed -i \\\"/$KEY2/{s/$KEY2.*/$KEY2 yes/}\\\" $FILE && systemctl restart sshd"

export -f ssh_pem_function expect_function
#parallel ssh_pem_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD1" ::: ../pem/renrui_california.pem

export -f ssh_function
parallel ssh_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: $PASSWD
