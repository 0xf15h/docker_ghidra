![](https://raw.githubusercontent.com/0xf15h/docker_ghidra/master/ghidra_logo.png)
# Docker Ghidra
[![Docker Cloud Build](https://img.shields.io/docker/cloud/build/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![Docker Pulls](https://img.shields.io/docker/pulls/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![License](https://img.shields.io/github/license/0xf15h/docker_ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra)  
Ghidra (pronounced Gee-druh) is a software reverse engineering suite of tools developed by the NSA. One of Ghidra's tools is a version tracking system that enables collaborative reversing. This Docker image simplifies the setup and configuration process for people who want a production ready install without modifying their host system.

## Server Setup
```
docker pull 0xf15h/ghidra
wget https://raw.githubusercontent.com/0xf15h/docker_ghidra/master/password.txt
docker run --network="host" -it -p 13100:13100 --env-file password.txt 0xf15h/ghidra
```

## Adding Users
```
docker exec -it <container_name> /bin/bash
./svrAdmin -add <user>
```
The users are added to the server with the default password 'changeme'. They will be prompted to create a new password at login.

## Connecting to the Server
Start the Ghidra client and click on File -> New Project -> Shared Project -> Next. The server name is either localhost or the domain name that points to your Ghidra server. The port is 13100. Click Next and a pop-up will appear. The default password is 'changeme'. The steps from this point forward are self explanatory. See the Ghidra documentation for further guidance.

# Server Administration
This Docker image is consistent with the offical documentation so admins can quickly learn how to customize the server. All scripts that are specified in the documentation are located in the home directory.

## Changing the Default Password
The password.txt file that is downloaded in the server setup step contains the environment variable that stores the Ghidra user's password. To change the password, open the file and add the new password to the NEW_PASSWORD variable. Run the container and then move the new password to the PASSWORD environment variable inside the password.txt file. 

It's important to store the password in a file, as opposed to a command line argument, because it prevents exposure to logging systems (e.g. ~/.bash_history) and isn't easily available to other process's on the host.

## Setting Up a Remote Server
According to the documentation, the version tracking server needs to be configured with a DNS that is configured for both forward and reverse lookups.

The version tracking server listens on port 13100. Make sure this port is not blocked by a firewall and that another process isn't already bound to it.
