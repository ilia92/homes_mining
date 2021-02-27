#!/bin/sh

#Please check Help\Other\Eth-Etc-Zil.txt for an explanation of this example
#This is an example you can edit and use
#There are numerous parameters you can set, please check Help and Examples folder
#Start miner with administrator privileges to enable gpu-boost

export GPU_MAX_HEAP_SIZE=100
export GPU_MAX_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100
export GPU_MAX_SINGLE_ALLOC_PERCENT=100
export GPU_ENABLE_LARGE_ALLOCATION=100
export GPU_MAX_WORKGROUP_SIZE=1024

#change --wallet etc-wallet.zilliqa-wallet\;etc-wallet.zilliqa-wallet --worker ezil-worker-zil\;ezil-worker-etc
#to your own wallet's and worker names

./SRBMiner-MULTI --disable-cpu --multi-algorithm-job-mode 3 --a0-is-zil --algorithm etchash\;etchash --pool eu.etc.ezil.me:4444\;eu.etc.ezil.me:4444 --wallet etc-wallet.zilliqa-wallet\;etc-wallet.zilliqa-wallet --worker ezil-worker-zil\;ezil-worker-etc --gpu-boost 3\;0

