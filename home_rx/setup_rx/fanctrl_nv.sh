#!/bin/bash

# fanctrl_nv.sh VERSION 1.0

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

fan_speed=$1
fan_num=$2

if [ "$2" ]; then

amdcovc fanspeed:$fan_num=$fan_speed | grep Setting

exit

elif [ "$1" ]; then
fan_speed=$1

printf "\nOnly 1 parameter set, will use it for FAN speed for ALL fans\n\n"
cards_count=`amdcovc | grep Adapter | wc -l`

for i in `seq 0 $(($cards_count-1))`;
        do
amdcovc fanspeed:$i=$fan_speed | grep Setting
done

else
printf "\n\nScript usage example (run as user):\n./fan_ctrl.sh [speed] [fan_number]\n\n"
printf "\nIf only 1 parameter set, will set as FAN speed for ALL fans\n"
exit

fi

