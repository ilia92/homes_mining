#!/bin/bash

if [ "$EUID" -ne 0 ]
  then printf "Script should be run as root!!!\n"
  exit
fi

user="miner"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

conf_file="$DIR/config_nv.txt"

conf_file_read=`cat $conf_file`

conf_file_filtered=`printf "$conf_file_read" | cut -f1 -d"#" | sed '/^\s*$/d' | sed 's/ //g'`

cards=`nvidia-smi -L`
cards_count=`printf "$cards" | wc -l`

def_plimit=`printf "$conf_file_filtered" | grep "plimit=" | sed "s/plimit=//g"`
def_fan=`printf "$conf_file_filtered" | grep "fan=" | sed "s/fan=//g"`
def_mclock=`printf "$conf_file_filtered" | grep "mclock=" | sed "s/mclock=//g"`
def_cclock=`printf "$conf_file_filtered" | grep "cclock=" | sed "s/cclock=//g"`
def_nstate=`printf "$conf_file_filtered" | grep "nstate=" | sed "s/nstate=//g"`
def_cstate=`printf "$conf_file_filtered" | grep "cstate=" | sed "s/cstate=//g"`
pill=`printf "$conf_file_filtered" | grep "pill=" | sed "s/pill=//g"`
tt=`printf "$conf_file_filtered" | grep "tt=" | sed "s/tt=//g"`

gui_wait=`printf "$conf_file_filtered" | grep "gui_wait=" | sed "s/gui_wait=//g"`

if ! [ "$gui_wait" ]; then
	gui_wait=20
fi

# Run the pill
if [ "$pill" = "1" ]; then
screen -dmS pill /home/miner/setup_nv/OhGodAnETHlargementPill-r2
printf "The pill for NVIDIA cards was started!\n\n"
sleep 2

su -c "/home/$user/miner_launcher.sh" -s /bin/sh $user
sleep 10
fi
# END Run the pill

nvidia-smi -pm 1

# Power limit set
for i in `seq 0 $cards_count`; #Do NOT edit end number - this should be!

        do
        plimit=`printf "$conf_file_filtered" | grep "plimit$i=" | sed -e "s|plimit$i=||g"`

        if [[ "$plimit" ]]; then
                nvidia-smi -i $i -pl $plimit
        else
                nvidia-smi -i $i -pl $def_plimit
        fi
done


# GUI reconfig and restart
nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

/etc/init.d/lightdm restart

sleep $gui_wait

graph_status=`/etc/init.d/lightdm status | grep "active (running)"`

printf "\n"

if [ "$graph_status" ]; then
         printf "\e[1;32mGUI successfully started, proceeding ...\e[0m\n"
else
         printf "\e[1;31mGUI NOT started, try again from beginning!\e[0m\n\n"
         exit
fi
# END GUI reconfig and restart


# FAN set
for i in `seq 0 $cards_count`; #Do NOT edit end number - this should be!

        do
        fan=`printf "$conf_file_filtered" | grep "fan$i=" | sed -e "s|fan$i=||g"`

        if [[ "$fan" ]]; then
		su -c "$DIR/fanctrl_nv.sh $fan $i" -s /bin/sh $user
        else
                su -c "$DIR/fanctrl_nv.sh $def_fan $i " -s /bin/sh $user
        fi

done
#END FAN set

# Memory clock set
for i in `seq 0 $cards_count`; #Do NOT edit end number - this should be!

        do
        mclock=`printf "$conf_file_filtered" | grep "mclock$i=" | sed -e "s|mclock$i=||g"`
	nstate=`printf "$conf_file_filtered" | grep "nstate$i=" | sed -e "s|nstate$i=||g"`

        if ! [[ "$nstate" ]]; then
	nstate=$def_nstate
        fi

        if [[ "$mclock" ]]; then
		su -c "$DIR/mclock_nv.sh $mclock $i $nstate" -s /bin/sh $user
        else
		su -c "$DIR/mclock_nv.sh $def_mclock $i $nstate" -s /bin/sh $user
        fi

done
# END Memory clock set

# Core clock set
for i in `seq 0 $cards_count`; #Do NOT edit end number - this should be!

        do
        cclock=`printf "$conf_file_filtered" | grep "cclock$i=" | sed -e "s|cclock$i=||g"`
        cstate=`printf "$conf_file_filtered" | grep "cstate$i=" | sed -e "s|cstate$i=||g"`

        if ! [[ "$cstate" ]]; then
        cstate=$def_cstate
        fi

        if [[ "$cclock" ]]; then
                su -c "$DIR/cclock_nv.sh $cclock $i $cstate" -s /bin/sh $user
        else
                su -c "$DIR/cclock_nv.sh $def_cclock $i $cstate" -s /bin/sh $user
        fi

done
# END Core clock set

# Fan management
su -c "screen -dmS fanmgmt $DIR/fanmgmt_nv.sh $tt" -s /bin/sh $user
# END fan management

if [ "$1" = "--start-miner" ]  && [ "$pill" != "1" ]; then
sleep 5
su -c "/home/$user/miner_launcher.sh" -s /bin/sh $user
fi
