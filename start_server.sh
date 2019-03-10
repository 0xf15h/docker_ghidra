#!/bin/bash

cd /home/ghidra/ghidra/server
echo "password" | sudo -S "PATH=$PATH" ./ghidraSvr start
sleep 5
echo "password" | sudo -S "PATH=$PATH" ./svrAdmin -add $HOST_USER