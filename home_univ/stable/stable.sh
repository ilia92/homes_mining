#!/bin/bash

uptm=`uptime`
uptm_chk=`printf "$uptm" | grep "0 min\|1 min\|2 min"`
date=`date +"%Y-%m-%d %T"`

if [ "$uptm_chk" ]; then
printf "1st cron run, nothing done\n"
exit 0;
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e $DIR/stable.conf ]; then
source $DIR/stable.conf
else
printf "Missing config file, exiting"
exit 1;
fi

count=`cat $DIR/$counter_file 2> /dev/null`

if [[ $count -ge $counter_trsh ]]; then
printf "\nRestarts exceeded! Check RIG!\n"
exit
fi

raw_curl=`timeout $curl_timeout curl --silent localhost:3333 | html2text`
zero_hashes=`echo -e "$raw_curl" | grep "GPUs.*0.000 MH/s" | tail -1`

card_type=`timeout 10 lspci | grep controller`

if [ "$(printf "$card_type" | grep AMD)" ]; then

printf "AMD Cards!\n"
cards_count=`ls -la /sys/class/drm/ | grep 'card[0-9][0-9] ->\|card[0-9] ->' | wc -l`
mem_load_info="MEM_load:" && for i in $( seq 0 $((cards_count-1))) ; do mem_load_info=`printf "${mem_load_info}__$i:\`cat /sys/class/drm/card$i/device/mem_busy_percent 2> /dev/null\`"` ; done

elif [ "$(printf "$card_type" | grep NVIDIA)" ]; then
printf "NVIDIA Cards!"

else
printf "Unknown Cards type"
fi

# Check if miner shows output
if ! [ $res_criteria == "card_down" ] && ! [ $res_criteria == "full_down" ]; then
printf "Unknown criteria, will not proceed further!\n"

elif ! [ "$raw_curl" ] && ([ $res_criteria == "full_down" ] || [ $res_criteria == "card_down" ]) ; then

printf "full_down: NO curl selfcheck result!\n"
count=$(($count+1))
echo $count > $DIR/$counter_file
printf "$date full_down:$count $mem_load_info\n" >> $DIR/$log_file
sleep 30
echo b > /proc/sysrq-trigger

elif ([ "$zero_hashes" ] || ! [ "$raw_curl" ]) && [[ $res_criteria == "card_down" ]]; then

     printf "card_down: There is stopped card!\n"
     count=$(($count+1))
     echo $count > $DIR/$counter_file
     printf "$date card_down:$count $mem_load_info\n" >> $DIR/$log_file
     sudo su -c 'screen -S ethm -X stuff "1"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "2"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "3"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "4"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "5"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "6"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "7"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "8"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "9"' -s /bin/sh $user
     sudo su -c 'screen -S ethm -X stuff "010"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "011"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "012"' -s /bin/sh $user
     sleep 1
     sudo su -c 'screen -S ethm -X stuff "013"' -s /bin/sh $user
     sleep 30
     echo b > /proc/sysrq-trigger

else
printf "All up and running!\n"

fi
