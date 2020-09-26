#!/bin/bash

# pho/start.sh VERSION 1.0

#export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

DIR="$(dirname "$(readlink -f "$0")")"

$DIR/PhoenixMiner &&

printf "\n\nMINER Will restart in 30 seconds !!!\n\nCTRL+C to stop it\n\n"

sleep 33

/home/$LOGNAME/stable/stable.sh
