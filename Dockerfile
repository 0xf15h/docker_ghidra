FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GHIDRA_VERSION 9.0
ENV GHIDRA_SHA_256 3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-11-jre-headless 

# Create non-root user.
RUN useradd -m ghidra && \
  adduser ghidra sudo && \
  echo "ghidra:password" | chpasswd

# Setup user environment.
USER ghidra
WORKDIR /home/ghidra
ENV HOME /home/ghidra

# Get Ghidra.
RUN cd /home/ghidra && \
    wget --progress=bar:force -O /home/ghidra/ghidra_${GHIDRA_VERSION}.zip https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip && \
    sha256sum ghidra_9.0.zip | awk '{print $1}' | grep -q $GHIDRA_SHA_256 && \
    unzip ghidra_${GHIDRA_VERSION}.zip && \
    rm ghidra_${GHIDRA_VERSION}.zip

# Install Ghidra server.
#RUN cd /home/ghidra/ghidra_${GHIDRA_VERSION}/server && \

ENV PATH "/home/ghidra/ghidra_${GHIDRA_VERSION}:${PATH}"

#ENTRYPOINT [ "/home/ghidra/ghidra_${GHIDRA_VERSION}/server/ghidraSvr" ]
