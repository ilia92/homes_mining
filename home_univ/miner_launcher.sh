#!/bin/bash

# miner_launcher.sh VERSION 1.2

export DISPLAY=:0

if [[ $(ps aux | grep "SCREEN -dmS ethm" | wc -l) -gt 1 ]]; then
# Stop each card
printf "Stopping cards ...\n"

screen -S ethm -X stuff "1" > /dev/null
sleep 0.2
screen -S ethm -X stuff "2" > /dev/null
sleep 0.2
screen -S ethm -X stuff "3" > /dev/null
sleep 0.2
screen -S ethm -X stuff "4" > /dev/null
sleep 0.2
screen -S ethm -X stuff "5" > /dev/null
sleep 0.2
screen -S ethm -X stuff "6" > /dev/null
sleep 0.2
screen -S ethm -X stuff "7" > /dev/null
sleep 0.2
screen -S ethm -X stuff "8" > /dev/null
sleep 0.2
screen -S ethm -X stuff "9" > /dev/null
sleep 0.2

if [ -e ~/rig_algo-miner ]; then

source ~/rig_algo-miner

        if [ "$miner" = "pho" ]; then

screen -S ethm -X stuff "010" > /dev/null
sleep 0.2
screen -S ethm -X stuff "011" > /dev/null
sleep 0.2
screen -S ethm -X stuff "012" > /dev/null
sleep 0.2
screen -S ethm -X stuff "013" > /dev/null
sleep 0.2
	else
screen -S ethm -X stuff "a" > /dev/null
sleep 0.2
screen -S ethm -X stuff "b" > /dev/null
sleep 0.2
screen -S ethm -X stuff "c" > /dev/null
sleep 0.2
screen -S ethm -X stuff "0" > /dev/null
	fi
fi

sleep 2
# END Stop each card
fi

pkill -9 start.sh && sleep 10

if [ -e ~/rig_wallet ]; then

source ~/rig_wallet

	if [ "$pool" ]; then
	sed -i "/pool/c\-epool $pool"  ~/pho/config.txt
	sed -i "/epool/c\-epool $pool"  ~/clay/config.txt
	fi

        if [ "$wallet" ]; then
        sed -i "/wal/c\-ewal $wallet"  ~/pho/config.txt
        sed -i "/ewal/c\-ewal $wallet"  ~/clay/config.txt
        fi

        if [ "$coin" ]; then
        sed -i "/coin/c\-coin $coin"  ~/pho/config.txt
        sed -i "/allcoins/c\-allcoins $coin"  ~/clay/config.txt
        fi

fi

if [ -e ~/rig_algo-miner ]; then

source ~/rig_algo-miner

        if [ "$miner" = "pho" ]; then
	cd ~/pho

screen -ls "fanmgmt" | (
  IFS=$(printf '\t');
  sed "s/^$IFS//" |
  while read -r name stuff; do
      screen -S "$name" -X quit
  done
)

	tt=`cat ~/setup_*/config_*txt | grep "tt=" | grep -o "..$"`
	screen -dmS fanmgmt ~/setup_nv/fanmgmt_nv.sh $tt
        screen -dmS fanmgmt ~/setup_rx/fanmgmt_rx.sh $tt
	screen -dmS ethm ./start.sh
	printf "ETH miner started\n"
        fi

        if [ "$algo" = "xmr" ]; then
        cd ~/clay_xmr
        screen -dmS xmrm ./start.sh
        printf "XMR miner started\n"
        elif [ "$algo" = "eth" ] && [ "$miner" = "clay" ]; then
        cd ~/clay
        screen -dmS ethm ./start.sh
        printf "ETH miner started\n"
        fi

fi

