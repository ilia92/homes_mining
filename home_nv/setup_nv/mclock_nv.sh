#!/bin/bash

export DISPLAY=:0

#sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

mclock=$1
card_num=$2

if [ "$3" ]; then
nstate=$3
else
nstate=3
fi

if [ "$2" ]; then
nvidia-settings -a [gpu:$card_num]/GPUMemoryTransferRateOffset[$nstate]=$mclock
exit

elif [ "$1" ]; then

printf "\nOnly one parameter set, will use it for MEMORY clock for ALL cards\n"
cards_count=`nvidia-smi -L | wc -l`

for i in `seq 0 $(($cards_count-1))`;
        do
	nvidia-settings -a [gpu:$card_num]/GPUMemoryTransferRateOffset[$nstate]=$mclock
done

else
printf "\n\nScript usage example (run as user):\n./mclock_nv.sh [mem_clock] [card_number] [clock_state]\n\n"
printf "\nIf Only one parameter set, will set as MEMORY clock for ALL cards\n"
exit

fi

