#!/bin/bash

cd $GHIDRA_INSTALL_PATH/ghidra/server
echo $PASSWORD | ./ghidraSvr console
