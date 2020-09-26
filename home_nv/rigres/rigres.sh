#/bin/bash

sleep_time=40

DIR="$(dirname "$(readlink -f "$0")")"

r01='01'
r02='02'
r03='04'
r04='010'
r05='10'
r06='20'
r07='40'
r08='80'
r09='00 01'
r010='00 02'
r011='00 04'
r012='00 08'
r013='00 10'
r014='00 20'
r015='00 40'
r016='00 80'

$DIR/HidCom --path /dev/usb/hiddev0 -i 21 $((r0$1)) &

(sleep $sleep_time ; $DIR/HidCom --path /dev/usb/hiddev0 -i 21 00 ) &
