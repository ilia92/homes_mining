#!/bin/bash

efficiency=85
mb_pow=30
offset_pow=$1 #fans

if ! [ $offset_pow ]; then
offset_pow=5
fi

printf "Offset power set to: $offset_pow W\n"

powers=`rocm-smi | grep -o -P '( ).*(?=W)' | awk {'print $3'}`

powers_count=`printf "$powers" | wc -l`

pow_full=0

for i in `seq 1 $(($powers_count+1))`;
do
pow_curr[$i]=0

done

for i in `seq 1 $(($powers_count+1))`;
do
pow_curr[$i]=`printf "$powers" | sed "$i!d" `
pow_pp=${pow_curr[$i]}
pow_full=`echo "$pow_full + $pow_pp + 25" | bc -l`
#extender power added

printf "Card power: $pow_pp W\n"
#printf "CARDS power: $pow_full W\n"

done

#Motherboard add
pow_full=`echo "$pow_full + $mb_pow + $offset_pow" |bc -l`

pow_wall=`echo "$pow_full + $pow_full * 0.01 * (100-$efficiency)" |bc -l`

printf "==================================\n"

printf "Summary power is: $pow_full\n"
printf "From the wall should be: $pow_wall\n"
