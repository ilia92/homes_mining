#!/bin/bash

# high_state.sh VERSION 1.0

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

# Check internal VGA

cards_count=`amdcovc | grep Adapter | wc -l`
for i in `seq 0 $cards_count`;
        do
                in_vga=`touch /sys/class/drm/card$i/device/pp_table ; echo $?`

                if [ "$in_vga" -gt 0 ]; then
                non_card=$i
                break
                else
                non_card=100
                fi
        done
# END Check internal VGA


for i in `seq 0 $(($cards_count-1))`;
do
        if [[ $i -ge $non_card ]];then
        j=$(($i+1))
        else
        j=$i
        fi

echo 0 > /sys/class/drm/card$j/device/pp_dpm_pcie

echo 7 > /sys/class/drm/card$j/device/pp_dpm_sclk

echo 1 > /sys/class/drm/card$j/device/pp_dpm_mclk

echo 2 > /sys/class/drm/card$j/device/pp_dpm_mclk

printf "Card $i: highest CORE and MEM state was set!\n"


done
