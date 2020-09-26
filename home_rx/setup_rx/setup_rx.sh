#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

# setup_rx.sh VERSION 1.1

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

user="miner"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

conf_file="$DIR/config_rx.txt"

conf_file_read=`cat $conf_file`

conf_file_filtered=`printf "$conf_file_read" | cut -f1 -d"#" | sed '/^\s*$/d' | sed 's/ //g'`

#cards_count=`amdcovc | grep Adapter | wc -l`


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


def_core_uv=`printf "$conf_file_filtered" | grep "core_uv=" | sed "s/core_uv=//g"`
def_cstate_uv=`printf "$conf_file_filtered" | grep "cstate_uv=" | sed "s/cstate_uv=//g"`
def_mem_uv=`printf "$conf_file_filtered" | grep "mem_uv=" | sed "s/mem_uv=//g"`
def_mstate_uv=`printf "$conf_file_filtered" | grep "mstate_uv=" | sed "s/mstate_uv=//g"`
def_mclock=`printf "$conf_file_filtered" | grep "mclock=" | sed "s/mclock=//g"`
tt=`printf "$conf_file_filtered" | grep "tt=" | sed "s/tt=//g"`

printf "\n\n"

# Undervolting the RX cards
for i in `seq 0 $(($cards_count-1))`;

        do
        core_uv=`printf "$conf_file_filtered" | grep "core_uv$i=" | sed -e "s|core_uv$i=||g"`
        cstate_uv=`printf "$conf_file_filtered" | grep "cstate_uv$i=" | sed -e "s|cstate_uv$i=||g"`

        mem_uv=`printf "$conf_file_filtered" | grep "mem_uv$i=" | sed -e "s|mem_uv$i=||g"`
        mstate_uv=`printf "$conf_file_filtered" | grep "mstate_uv$i=" | sed -e "s|mstate_uv$i=||g"`


        if ! [[ "$core_uv" ]]; then
	core_uv=$def_core_uv
        fi
        if ! [[ "$cstate_uv" ]]; then
	cstate_uv=$def_cstate_uv
        fi
        if ! [[ "$mem_uv" ]]; then
	mem_uv=$def_mem_uv
        fi
        if ! [[ "$mstate_uv" ]]; then
	mstate_uv=$def_mstate_uv
        fi

        if [[ $i -ge $non_card ]];then
        j=$(($i+1))
        else
        j=$i
        fi
printf "Card $i: actual - $j\n"
sudo ohgodatool -i $j --core-state $cstate_uv --core-vddc-idx $core_uv
sudo ohgodatool -i $j --mem-state $mstate_uv --mem-vddc-idx $mem_uv

printf "===============================\n"
#$DIR/core_uv.sh $core_uv $i $cstate_uv
#$DIR/mem_uv.sh $core_uv $i $cstate_uv

done
# CORE Undervolting the RX cards


# END OVERCLOCK the RX cards
for i in `seq 0 $(($cards_count-1))`;

        do
        mclock=`printf "$conf_file_filtered" | grep "mclock$i=" | sed -e "s|mclock$i=||g"`

        if ! [[ "$mclock" ]]; then
        mclock=$def_mclock
        fi

printf "Card $i: \n"
$DIR/mclock.sh $mclock $i

printf "===============================\n"
done
# END OVERCLOCK the RX cards

# END set HIGH state
$DIR/high_state.sh
# END set HIGH state

# Fan management
#screen -dmS fanmgmt $DIR/fanmgmt_rx.sh $tt
# END fan management

printf "===============================\n"

# Mem Tweak

memtw=`printf "$conf_file_filtered" | grep -m1 "\-\-" | sed "s|=| |g"`

printf "memtweak: $memtw\n"

amdmemtweak $memtw

# END Mem Tweak

if [ "$1" = "--start-miner" ]; then
sleep 2
su -c "/home/$user/miner_launcher.sh" -s /bin/sh $user
fi
