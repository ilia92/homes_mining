#!/bin/bash

# cclock.sh VERSION 1.0

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

mclock=$1
card_num=$2

if [ "$2" ]; then

amdcovc coreclk:$card_num=$mclock | grep Setting

exit

elif [ "$1" ]; then
mclock=$1

printf "\nOnly 1 parameter set, will use it for CORE clock for ALL cards\n\n"
cards_count=`amdcovc | grep Adapter | wc -l`

for i in `seq 0 $(($cards_count-1))`;
        do
amdcovc coreclk:$i=$mclock | grep Setting
done

else
printf "\n\nScript usage example (run as user):\n./cclock_nv.sh [core_clock] [card_number]\n\n"
printf "\nIf only 1 parameter set, will set as CORE clock for ALL cards\n"
exit

fi
