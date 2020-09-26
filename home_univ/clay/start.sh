#!/bin/bash

#export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$DIR/ethdcrminer64 &&

printf "\n\nMINER Will restart in 30 seconds !!!\n\nCTRL+C to stop it\n\n"

sleep 33

/home/$LOGNAME/stable/stable.sh
