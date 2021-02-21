#!/bin/sh

# These environment variables should be set to for the driver to allow max mem allocation from the gpu(s).
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1

# This example file sets up ETH+ZIL mining with two outgoing pool connections and the TRM
# "'min_epoch" pool strategy for best results. This strategy always selects the lowest available
# epoch among the connected pools, therefore switching to ZIL mining during the ZIL mining
# windows, otherwise mining ETH directly to your pool of choice.
#
# Note 1: the first pool MUST be a plain ETH mining pool. The second pool should be a ZIL+ETH
# switching pool.
#
# Note 2: you SHOULD run this setup with --eth_dag_cache=0, meaning both the ETH and ZIL DAG
# will always be available. The reason is that many ZIL pools tend to disconnect multiple times
# during the ZIL window, and then you'll be switched multiple times between ETH and ZIL. This
# means that B/C-mode is not available. Therefore, --eth_config=A is included here to force all
# gpus into A-mode.
#
# Please change the wallets below to your own before mining.

./teamredminer -a ethash --pool_strategy=min_epoch --eth_dag_cache=0 -o stratum+tcp://eu1.ethermine.org:4444 -u 0x02197021fefa795fec661a45f60e47a6f6605281.trmtest -p x -o stratum+tcp://eu-zil.rustpool.xyz:9009 -u 0x02101Ff031529661dcAb36614d0Fa5a76e4721B4.trmtest_zil -p zil14fw7uxmrjrlsxdfsjp6razax6ysk2eerc7uryy@eth-eu1.nanopool.org:9999@4G --eth_config=A
