![](./ghidra_logo.png)
# Docker Ghidra
[![Docker Cloud Build](https://img.shields.io/docker/cloud/build/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![Docker Pulls](https://img.shields.io/docker/pulls/0xf15h/ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra) [![License](https://img.shields.io/github/license/0xf15h/docker_ghidra.svg?style=popout)](https://hub.docker.com/r/0xf15h/ghidra)  
Ghidra is a software reverse engineering suite of tools developed by the NSA. One of Ghidra's tools is a version tracking system that enables collaborative reversing. This Docker container image simplifies the setup and configuration process for people that want to try it out.
## Setup
```
docker pull 0xf15h/ghidra
docker run -it -p 13100:13100 0xf15h/ghidra
# Once you're inside the container run:
./start_server.sh
```
The container has one user named ghidra. The ghidra user's password for sudo commands is 'password'. 
## Credits
- NSA's Research Directorate https://ghidra-sre.org/
## TODO
- Start server when container is started
- Support port configuration
- Support password configuration