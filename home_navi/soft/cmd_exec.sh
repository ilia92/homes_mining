#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


cp -rpv $DIR/amdcovc /usr/bin/
cp -rpv $DIR/amdvbflash /usr/bin/

cp -rpv $DIR/rocm-smi /usr/bin/
cp -rpv $DIR/rocm_smi.py /usr/bin/
cp -rpv $DIR/rocminfo /usr/bin/

cp -rpv $DIR/pbec /usr/bin/
cp -rpv $DIR/amdmemtweak /usr/bin/

cp -rpv $DIR/busy /usr/bin/
