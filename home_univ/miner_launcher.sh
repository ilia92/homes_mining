#!/bin/bash

# miner_launcher.sh VERSION 1.2

export DISPLAY=:0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Changing worker name
worker=`hostname`
sed -i "/worker/c\-worker $worker"  $DIR/pho/config.txt
sed -i "/eworker/c\-eworker $worker"  $DIR/clay/config.txt

if [[ $(ps aux | grep "SCREEN -dmS ethm" | wc -l) -gt 1 ]]; then
# Stop each card
printf "Stopping cards ...\n"
# For TeamRedMiner
screen -S ethm -X stuff "d" > /dev/null
sleep 0.5

screen -S ethm -X stuff "1" > /dev/null
sleep 1
screen -S ethm -X stuff "2" > /dev/null
sleep 1
screen -S ethm -X stuff "3" > /dev/null
sleep 1
screen -S ethm -X stuff "4" > /dev/null
sleep 1
screen -S ethm -X stuff "5" > /dev/null
sleep 1
screen -S ethm -X stuff "6" > /dev/null
sleep 1
screen -S ethm -X stuff "7" > /dev/null
sleep 1
screen -S ethm -X stuff "8" > /dev/null
sleep 1
screen -S ethm -X stuff "9" > /dev/null
sleep 1

if [ -e $DIR/rig_algo-miner ]; then

source $DIR/rig_algo-miner

        if [ "$miner" = "pho" ]; then

screen -S ethm -X stuff "010" > /dev/null
sleep 0.5
screen -S ethm -X stuff "011" > /dev/null
sleep 0.5
screen -S ethm -X stuff "012" > /dev/null
sleep 0.5
screen -S ethm -X stuff "013" > /dev/null
sleep 0.5
	else
screen -S ethm -X stuff "a" > /dev/null
sleep 0.5
screen -S ethm -X stuff "b" > /dev/null
sleep 0.5
screen -S ethm -X stuff "c" > /dev/null
sleep 0.5
screen -S ethm -X stuff "0" > /dev/null
	fi
fi

sleep 2
# END Stop each card
fi

kill -9 $(ps aux | grep -e start.*.sh | awk '{ print $2 }') 2>/dev/null && sleep 10
if [ -e $DIR/rig_wallet ]; then

source $DIR/rig_wallet

#	if [ "$pool" ]; then
#	sed -i "/pool/c\-epool $pool"  $DIR/pho/config.txt 2> /dev/null
#	sed -i "/epool/c\-epool $pool"  $DIR/clay/config.txt 2> /dev/null
#        sed -i "/pool=/c\pool=$pool"  $DIR/trm/start.sh 2> /dev/null
#	fi
#
#        if [ "$wallet" ]; then
#        sed -i "/wal/c\-ewal $wallet"  $DIR/pho/config.txt 2> /dev/nul
#        sed -i "/ewal/c\-ewal $wallet"  $DIR/clay/config.txt 2> /dev/nul
#        sed -i "/wallet=/c\wallet=$wallet"  $DIR/trm/start.sh 2> /dev/null
#        fi
#
#        if [ "$coin" ]; then
#        sed -i "/coin/c\-coin $coin"  $DIR/pho/config.txt 2> /dev/nul
#        sed -i "/allcoins/c\-allcoins $coin"  $DIR/clay/config.txt 2> /dev/nul
#        fi
else
printf "Missing rig_wallet file!\n"

fi

if [ -e $DIR/rig_algo-miner ]; then

source $DIR/rig_algo-miner

   if [ "$miner" = "pho" ]; then
   cd $DIR/pho
        sed -i "/pool/c\-epool $pool"  $DIR/pho/config.txt
        sed -i "/wal/c\-ewal $wallet"  $DIR/pho/config.txt
        sed -i "/coin/c\-coin $coin"  $DIR/pho/config.txt

	screen -ls "fanmgmt" | (
	  IFS=$(printf '\t');
	  sed "s/^$IFS//" |
	  while read -r name stuff; do
	      screen -S "$name" -X quit
	  done
	)

	tt=`cat $DIR/setup_*/config_*txt | grep "tt=" | grep -o "..$"`
	if ! [[ "$tt" ]]; then
        tt=57
        fi
	screen -dmS fanmgmt $DIR/setup_nv/fanmgmt_nv.sh $tt
#        screen -dmS fanmgmt $DIR/setup_rx/fanmgmt_rx.sh $tt
	screen -dmS ethm -L -Logfile /dev/tty1 ./start.sh
	printf "ETH miner started: Phoenix\n"
   fi

   if [ "$miner" = "trm" ] && [ "$algo" = "eth" ]; then
	cd $DIR/trm
        sed -i "/pool=/c\pool=$pool"  $DIR/trm/start.sh 2> /dev/null
        sed -i "/wallet=/c\wallet=$wallet"  $DIR/trm/start.sh 2> /dev/null

        screen -dmS ethm -L -Logfile /dev/tty1 ./start.sh
        printf "ETH miner started: TeamRedMiner\n"
   fi

   if [ "$miner" = "trm" ] && [ "$algo" = "kawpow" ]; then
	cd $DIR/trm
        sed -i "/pool=/c\pool=$pool"  $DIR/trm/start_kaw.sh 2> /dev/null
        sed -i "/wallet=/c\wallet=$wallet"  $DIR/trm/start_kaw.sh 2> /dev/null

        screen -dmS ethm -L -Logfile /dev/tty1 ./start_kaw.sh
        printf "Raven miner started: TeamRedMiner\n"
   fi

   if [ "$algo" = "xmr" ]; then
        cd $DIR/clay_xmr
        sed -i "/epool/c\-epool $pool"  $DIR/clay/config.txt 2> /dev/null
        sed -i "/ewal/c\-ewal $wallet"  $DIR/clay/config.txt 2> /dev/nul
        sed -i "/allcoins/c\-allcoins $coin"  $DIR/clay/config.txt 2> /dev/nul

        screen -dmS xmrm ./start.sh
        printf "XMR miner started: Claymore\n"
   elif [ "$miner" = "clay" ] && [ "$algo" = "eth" ]; then
        cd $DIR/clay
        screen -dmS ethm -L -Logfile /dev/tty1 ./start.sh
        printf "ETH miner started: Claymore\n"
   fi
fi

