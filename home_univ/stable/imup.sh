#!/bin/bash

host=`cat /etc/hostname`
ip=`ip a | grep -o "inet .*brd " | awk '{print $2}' | sed 's|/.*$||'`

subject="RIG - $host - I'm UP"
from="Miner <miner@webimage.eu>"
recipients="report@webimage.eu"
body_mail="Hello,\n\nI'm UP maan, don't worry!\n\nMy IP is: $ip\n\nMail sent at: $(date +"%d-%m-%y %H:%M:%S")\n\nRegards,\nYour $host"
mail="Subject:$subject\nFrom:$from\n$body_mail" 


echo -e "$mail" | /usr/sbin/sendmail $recipients

