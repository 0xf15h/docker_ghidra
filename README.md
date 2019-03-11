![](https://raw.githubusercontent.com/0xf15h/docker_ghidra/master/ghidra_logo.png)
# Docker Ghidra
[![Docker Cloud Build](https://img.shields.io/docker/cloud/build/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![Docker Pulls](https://img.shields.io/docker/pulls/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![License](https://img.shields.io/github/license/0xf15h/docker_ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra)  
Ghidra is a software reverse engineering suite of tools developed by the NSA. One of Ghidra's tools is a version tracking system that enables collaborative reversing. This Docker image simplifies the setup and configuration process for people who want to install it without modifying their host system.

## Server Setup
```
docker pull 0xf15h/ghidra
docker run --network="host" -it -p 13100:13100 -e "HOST_USER=$USER" 0xf15h/ghidra
# Once you're inside the container run the start script.
./start_server.sh
```
The start server script might need to be executed more than once. When "1 command(s) queued" is output, the server has started correctly.

## Connecting to the Server
Start the Ghidra client and click on File -> New Project -> Shared Project -> Next. The server name is either localhost or the domain name that points to your Ghidra server. The port is 13100. Click Next and a pop-up will appear. The default password is 'changeme'. The steps from this point forward are self explanatory. See the Ghidra documentation for further guidance.

## Setting Up a Remote Server
According to the documentation, the version tracking server needs to be configured with a DNS that is configured for both forward and reverse lookups.

The version tracking server listens on port 13100. Make sure this port is not blocked by a firewall and that another process isn't already bound to it.

## Credits
- NSA's Research Directorate https://ghidra-sre.org/

## TODO
- Execute the start server script once
- Start server when container is started
- Support password configuration