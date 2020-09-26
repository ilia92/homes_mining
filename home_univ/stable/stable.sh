#!/bin/bash

uptm=`uptime`
uptm_chk=`printf "$uptm" | grep " 0 min\| 1 min \| 2min"`

if [ "$uptm_chk" ];
then
#printf "1st cron run, nothing done\n"
exit 0;
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

counter_file="$DIR/restart_counter.txt"

count=`cat $counter_file`

counter_trsh=5

if [ $count -ge $counter_trsh ];
then
#printf "\nRestarts exceeded! Check RIG!\n"
exit
fi

raw_curl=`timeout 15 curl --silent localhost:3333 | html2text -width 200`
hashes=`echo -e "$raw_curl" | grep -T "$alg: G" | tail -10`

host=`cat /etc/hostname`

card_type=`timeout 10 lspci | grep controller`

if [ "$(printf "$card_type" | grep AMD)" ];
then
#printf "AMD Cards!"
cards_info=`timeout 10 amdcovc`
elif [ "$(printf "$card_type" | grep NVIDIA)" ]
then
#printf "NVIDIA Cards!"
#cards_info=`timeout --kill-after=3 --signal=SIGKILL 3s nvidia-smi -L &`
cards_info="\nNot availlable in this version \n"
else
printf "Unknown Cards type"
fi

# Send Mail function
sendmail ()
{
mail=""
subject="RIG - $host - SelfRESTART $count"
from="Miner <miner@webimage.eu>"
recipients="report@webimage.eu"
mail="Subject:$subject\nFrom:$from\n$body_mail"

echo -e "$mail" | /usr/sbin/sendmail $recipients
}
#END Send Mail function

# Check if miner shows output
if ! [ "$hashes" ];
then
#printf "\nIF case: EMPTY hashes stats! \n"

count=$(($count+1))

#some code here

echo $count > $counter_file

if [ $count -eq 5 ];
then
ifinfo="Hello,\n\nThere are no stats!\n\nThis is my LAST restart. Check ME, need attention!!!\n\nRig last uptime: $uptm\nMail sent at: $(date +"%d-%m-%y %H:%M:%S")\n\nSome stats:\n$cards_info\n\nRegards,\nYour $host\n"
body_mail="$ifinfo"
sendmail
sleep 5
echo b > /proc/sysrq-trigger
exit
fi

ifinfo="Hello,\n\nThere are no stats!\n\nI will restart myself, try to go Up again....\n\nRig last uptime: $uptm\nMail sent at: $(date +"%d-%m-%y %H:%M:%S")\n\nSome stats:\n$cards_info\n\nRegards,\nYour $host\n"

body_mail="$ifinfo"
#echo -e "$body_mail"
sendmail
sleep 5
echo b > /proc/sysrq-trigger
fi
#END Check if miner shows output
