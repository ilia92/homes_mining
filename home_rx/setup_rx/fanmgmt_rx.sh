#!/bin/bash

# fanmgmt_rx.sh VERSION 1.0

if [ "$3" ]; then

target_temp=$1
refresh_time=$2
temp_hyst=$3

elif [ "$2" ]; then

target_temp=$1
refresh_time=$2
temp_hyst=2

elif [ "$1" ]; then

target_temp=$1
refresh_time=15
temp_hyst=2

else
printf "\n\nScript usage example (run as user):\n./fanmgmt_rx.sh [target_temp] [refresh_time] [temp_hyst]\n\n"
exit
fi

fan_max=90
fan_min=20

cards_count=`amdcovc | grep Adapter | wc -l`

for j in `seq 0 $(($cards_count-1))`;
 do
 amdcovc fanspeed:$j=$fan_max
# fan_speed[$j]=`amdcovc -a $j | grep -o -P '(?<=Fan: ).*(?=%)'| cut -d. -f1`
 fan_speed[$j]=$(($fan_max))
 fanmin_set[$j]=0
 fanmax_set[$j]=0

done

sleep $refresh_time

while [ 1 ]
do

temps=`amdcovc | grep -o -P '(?<=Temp: ).*(?= C)'| cut -d. -f1`
printf "Card temps:\n$temps\n\n"

for i in `seq 0 $(($cards_count-1))`;

        do
	card_temp[$i]=`amdcovc -a $i | grep -o -P '(?<=Temp: ).*(?= C)'| cut -d. -f1`
	fan_speed[$i]=`amdcovc -a $i | grep -o -P '(?<=Fan: ).*(?=%)'| cut -d. -f1`

	fan_temp_delta[$i]=$((card_temp[$i] - target_temp))*2


if [[ ${fan_temp_delta[$i]#-} -gt $temp_hyst ]]; then

        printf "Card $i temp: ${card_temp[$i]}, temp delta: ${fan_temp_delta[$i]}\n"

        fan_speed[$i]=$((fan_speed[$i] + fan_temp_delta[$i]))

	if [[ ${fan_speed[$i]} -gt $fan_max ]]; then
	fan_speed[$i]=$fan_max
	elif [[ ${fan_speed[$i]} -lt $fan_min ]]; then
        fan_speed[$i]=$fan_min

	fi
	amdcovc fanspeed:$i=${fan_speed[$i]}
	printf "\n"
fi
done
sleep $refresh_time
done
