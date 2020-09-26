#!/bin/bash

# mem_uv.sh VERSION 1.0

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

# Check internal VGA

cards_count=`amdcovc | grep Adapter | wc -l`
for i in `seq 0 $cards_count`;
        do
		in_vga=`ls -la /sys/class/drm/card$i/device/pp_table | grep 'No such file or directory'`
		if [ "$in_vga" ]; then
		non_card=$i
		printf "\nThe non-RX card is: $i\n"
		break
		else
		non_card=100
		fi
	done
# END Check internal VGA

mem_uv=$1
card_num=$2
mstate_uv=$3

if [ "$3" ]; then
mstate_uv=$3
else
mstate_uv=2
fi


if [ "$2" ]; then

printf "Card $card_num:\t"
	if [[ $card_num -ge $non_card ]];then
	card_num=$(($card_num+1))
	fi
sudo ohgodatool -i $card_num --mem-state $mstate_uv --mem-vddc-idx $mem_uv

exit

elif [ "$1" ]; then
mem_uv=$1

printf "\nOnly one parameter set, will use it for MEMORY UNDERVOLT for ALL cards\n\n"

for i in `seq 0 $(($cards_count-1))`;
do
printf "Card $i:\t"
        if [[ $i -ge $non_card ]];then
        j=$(($i+1))
	else
	j=$i
        fi
printf "Card $i: actual - $j\n"
sudo ohgodatool -i $j --mem-state $mstate_uv --mem-vddc-idx $mem_uv
done

else
printf "\n\nScript usage example (run as user):\n./mem_uv.sh [mem_uv] [card_number] [mem_state]\n\n"
printf "\nIf Only one parameter set, will set as MEMORY UNDERVOLT for ALL cards\n"
exit

fi
