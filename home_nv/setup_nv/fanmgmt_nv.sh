#!/bin/bash

export DISPLAY=:0

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
refresh_time=30
temp_hyst=2

else
printf "\n\nScript usage example (run as user):\n./fanmgmt_nv.sh [target_temp] [refresh_time] [temp_hyst]\n\n"
exit
fi

fan_max=85
fan_min=20

temps=`nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader`
cards_count=`printf "$temps" | wc -l`

for j in `seq 0 $(($cards_count))`;
 do
 printf "SET MAX fan speed\n"
 nvidia-settings -a [fan:$j]/GPUTargetFanSpeed=$fan_max

# fan_speed[$j]=`nvidia-smi -i $j --query-gpu=fan.speed --format=csv,noheader | sed 's| %||g'`
 fan_speed[$j]=$(($fan_max))
 fanmin_set[$j]=0
 fanmax_set[$j]=0
done

sleep $refresh_time

while [ 1 ]
do

for i in `seq 0 $(($cards_count))`;
        do
	sleep 1
	card_temp[$i]=`nvidia-smi -i $i --query-gpu=temperature.gpu --format=csv,noheader`
	fan_speed[$i]=`nvidia-smi -i $i --query-gpu=fan.speed --format=csv,noheader | sed 's| %||g'`

	fan_temp_delta[$i]=$((card_temp[$i] - target_temp))*2


if [[ ${fan_temp_delta[$i]#-} -gt $temp_hyst ]]; then

        printf "Card $i temp: ${card_temp[$i]}, temp delta: ${fan_temp_delta[$i]}\n"

        fan_speed[$i]=$((fan_speed[$i] + fan_temp_delta[$i]))

	if [[ ${fan_speed[$i]} -gt $fan_max ]]; then
	fan_speed[$i]=$fan_max
		if ! [[ ${fanmax_set[$i]} ]]; then
        	nvidia-settings -a [fan:$i]/GPUTargetFanSpeed=${fan_speed[$i]}
        	fi

        fanmax_set[$i]=1
       	fanmin_set[$i]=0
        printf "Maximal fan speed reached!\n"

	elif [[ ${fan_speed[$i]} -lt $fan_min ]]; then
        fan_speed[$i]=$fan_min
		if ! [[ ${fanmin_set[$i]} ]]; then
	        nvidia-settings -a [fan:$i]/GPUTargetFanSpeed=${fan_speed[$i]}
        	fi
        fanmin_set[$i]=1
       	fanmax_set[$i]=0
        printf "Minimal fan speed achieved!\n"

	else
	nvidia-settings -a [fan:$i]/GPUTargetFanSpeed=${fan_speed[$i]}
	fi

fi
done
sleep $refresh_time
done
