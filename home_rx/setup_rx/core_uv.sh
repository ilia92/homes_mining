#!/bin/bash

# core_uv.sh VERSION 1.0

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

# Check internal VGA

cards_count=`amdcovc | grep Adapter | wc -l`
for i in `seq 0 $cards_count`;
        do
                in_vga=`ls -la /sys/class/drm/card$i/device/pp_table | grep 'No such file or directory'`
#printf "Card: $i: $i\t\tIn VGA: $in_vga\n"
                if [ "$in_vga" ]; then
                non_card=$i
                break
                else
                non_card=100
                fi
        done
# END Check internal VGA

core_uv=$1
card_num=$2
cstate_uv=$3

if [ "$3" ]; then
cstate_uv=$3
else
cstate_uv=7
fi


if [ "$2" ]; then

printf "Card $card_num:\t"
        if [[ $card_num -gt $non_card ]];then
        card_num=$(($card_num+1))
        fi
sudo ohgodatool -i $card_num --core-state $cstate_uv --core-vddc-idx $core_uv

exit

elif [ "$1" ]; then
core_uv=$1

printf "\nOnly one parameter set, will use it for CORE UNDERVOLT for ALL cards\n\n"

for i in `seq 0 $(($cards_count-1))`;
do
        if [[ $i -ge $non_card ]];then
        j=$(($i+1))
        else
        j=$i
        fi
printf "Card $i: actual - $j\n"
sudo ohgodatool -i $j --core-state $cstate_uv --core-vddc-idx $core_uv
done

else
printf "\n\nScript usage example (run as user):\n./core_uv.sh [core_uv] [card_number] [core_state]\n\n"
printf "\nIf Only one parameter set, will set as CORE UNDERVOLT for ALL cards\n"
exit

fi
