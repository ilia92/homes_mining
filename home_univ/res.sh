#!/bin/bash

# res.sh VERSION 1.0

user=miner

# Stop each card

printf "Stopping cards ...\n"

su -c 'screen -S ethm -X stuff "1"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "2"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "3"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "4"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "5"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "6"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "7"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "8"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "9"' -s /bin/sh $user
sleep 0.2

if [ -e ~/rig_algo-miner ]; then

source ~/rig_algo-miner

        if [ "$miner" = "pho" ]; then

su -c 'screen -S ethm -X stuff "010"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "011"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "012"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "013"' -s /bin/sh $user
sleep 0.2
	else
su -c 'screen -S ethm -X stuff "a"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "b"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "c"' -s /bin/sh $user
sleep 0.2
su -c 'screen -S ethm -X stuff "0"' -s /bin/sh $user
	fi
fi

sleep 2
# END Stop each card

pkill -9 start.sh

screen -dm bash -c 'sleep 3; echo b > /proc/sysrq-trigger'

ps -U $LOGNAME | grep -v "screen\|sleep\|bash" | awk '{print $1}' | grep -v PID | xargs -t kill
