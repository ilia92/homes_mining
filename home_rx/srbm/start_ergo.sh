#!/bin/sh

#This is an example you can edit and use
#There are numerous parameters you can set, please check Help and Examples folder

export GPU_MAX_HEAP_SIZE=100
export GPU_MAX_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100
export GPU_MAX_SINGLE_ALLOC_PERCENT=100
export GPU_ENABLE_LARGE_ALLOCATION=100
export GPU_MAX_WORKGROUP_SIZE=1024


pool=ergo-eu1.nanopool.org:11111
wallet=9gh62LQy88YWXCnzECKFCMmqjNRKeZff8cVE7cNAkbAZdrgTz7L
name=`hostname`

./SRBMiner-MULTI --disable-cpu --algorithm autolykos2 --pool $pool --wallet $wallet.$name --gpu-boost 3 --api-enable --api-port 3333
