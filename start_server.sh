#!/bin/bash

# Clear the password from the Ghidra server process's environment variables 
# after 1 minute. This helps prevent the server from leaking credentials.
clear_password() {
    sleep 60
    PASSWORD=''
    NEW_PASSWORD=''
    echo 'Cleared the Ghidra servers password environment variables'
    exit 0
}

source .env
new_password=true
if [ -z $NEW_PASSWORD ]; then
    new_password=false
fi
if [ "$new_password" == true ]; then
    echo $PASSWORD | sudo -S sh -c "echo \"ghidra:$NEW_PASSWORD\" | chpasswd"
    PASSWORD=$NEW_PASSWORD
fi
clear_password &

cd $GHIDRA_INSTALL_PATH/ghidra/server
echo $PASSWORD | sudo -S "PATH=$PATH" ./ghidraSvr console