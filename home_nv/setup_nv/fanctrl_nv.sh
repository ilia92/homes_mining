#!/bin/bash

export DISPLAY=:0

fan_speed=$1
fan_num=$2

if [ "$2" ]; then

nvidia-settings -a [gpu:$fan_num]/GPUFanControlState=1
nvidia-settings -a [fan:$fan_num]/GPUTargetFanSpeed=$fan_speed
exit

elif [ "$1" ]; then
fan_speed=$1

printf "\nOnly one parameter set, will use it for FAN speed for ALL fans\n\n"
cards_count=`nvidia-smi -L | wc -l`

for i in `seq 0 $(($cards_count-1))`;
        do
        nvidia-settings -a [gpu:$i]/GPUFanControlState=1
        nvidia-settings -a [fan:$i]/GPUTargetFanSpeed=$fan_speed
done

else
printf "\n\nScript usage example (run as user):\n./fan_ctrl.sh [speed] [fan_number]\n\n"
printf "\nIf Only one parameter set, will set as FAN speed for ALL fans\n"
exit

fi
