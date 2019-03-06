![](./ghidra_logo.png)
# Docker Ghidra
[![Docker Cloud Build](https://img.shields.io/docker/cloud/build/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![Docker Pulls](https://img.shields.io/docker/pulls/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![License](https://img.shields.io/github/license/0xf15h/docker_ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra)  
Ghidra is a software reverse engineering suite of tools developed by the NSA. One of Ghidra's tools is a version tracking system that enables collaborative reversing. This Docker container image simplifies the setup and configuration process for people that want to try it out without modifying their host system.
## Server Setup
```
docker pull 0xf15h/ghidra
# Windows users should replace $USER with your username.
docker run --network="host" -it -p 13100:13100 -e "HOST_USER=$USER" 0xf15h/ghidra
# Once you're inside the container run the start script.
./start_server.sh
```
## Connecting to the Server
Start the Ghidra client and click on File -> New Project -> Shared Project -> Next. The server name is localhost and the port is 13100. Click Next and a pop-up will appear. The default password is 'changeme'. The steps from this point forward are self explanatory. See the Ghidra documentation for further guidance.
## Credits
- NSA's Research Directorate https://ghidra-sre.org/
## TODO
- Start server when container is started
- Support port configuration
- Support password configuration