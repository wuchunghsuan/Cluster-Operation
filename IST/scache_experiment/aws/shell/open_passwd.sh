#!/bin/bash
. ./functions.sh

KEY1=PermitRootLogin
KEY2=PasswordAuthentication
FILE=/etc/ssh/sshd_config

CMD1="echo -e \\\"1234qwer\\\n1234qwer\\\" | sudo passwd"

CMD2="sudo chmod +x $FILE && sudo sed -i \\\"/$KEY1/{s/$KEY1.*/$KEY1 yes/}\\\" $FILE && sudo sed -i \\\"/$KEY2/{s/$KEY2.*/$KEY2 yes/}\\\" $FILE && sudo service sshd restart"

export -f ssh_pem_function expect_function
parallel ssh_pem_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD1" ::: ../pem/cn.pem

export -f ssh_pem_function
parallel ssh_pem_function ::: "${IPS[@]}" ::: $PORT ::: "$CMD2" ::: ../pem/cn.pem
