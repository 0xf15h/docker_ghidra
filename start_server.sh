#!/bin/bash

source .env
new_password=true
if [ -z $NEW_PASSWORD ]; then
    new_password=false
fi
if [ "$new_password" == true ]; then
    echo $PASSWORD | sudo -S sh -c "echo \"ghidra:$NEW_PASSWORD\" | chpasswd"
    PASSWORD=$NEW_PASSWORD
fi

cd $GHIDRA_INSTALL_PATH/ghidra/server
echo $PASSWORD | sudo -S "PATH=$PATH" ./ghidraSvr console