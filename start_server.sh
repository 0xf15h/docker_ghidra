#!/bin/bash

cd $GHIDRA_INSTALL_PATH/ghidra/server
echo "password" | sudo -S "PATH=$PATH" ./ghidraSvr console