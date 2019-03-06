FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV GHIDRA_VERSION 9.0
ENV GHIDRA_SHA_256 3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2

ENV JAVA_11_URL https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
ENV JAVA_DIR_NAME jdk-11.0.2

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    sudo

# Install Java 11.
RUN mkdir -p /home/ghidra && \
    cd /home/ghidra && \
    wget --progress=bar:force -O openjdk.tar.gz ${JAVA_11_URL} && \
    mkdir /usr/lib/jvm && \
    tar -xzf openjdk.tar.gz --directory /usr/lib/jvm && \
    rm openjdk.tar.gz
ENV PATH "/usr/lib/jvm/${JAVA_DIR_NAME}/bin/:${PATH}"

# Get Ghidra.
RUN cd /home/ghidra && \
    wget --progress=bar:force -O /home/ghidra/ghidra_${GHIDRA_VERSION}.zip https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip && \
    sha256sum ghidra_9.0.zip | awk '{print $1}' | grep -q $GHIDRA_SHA_256 && \
    unzip ghidra_${GHIDRA_VERSION}.zip && \
    mv ghidra_${GHIDRA_VERSION} ghidra && \
    rm ghidra_${GHIDRA_VERSION}.zip

# Create non-root user.
RUN useradd -m ghidra && \
    adduser ghidra sudo && \
    echo "ghidra:password" | chpasswd && \
    usermod -aG sudo ghidra

# Setup user environment.
USER ghidra
WORKDIR /home/ghidra
ENV HOME /home/ghidra

# Install Ghidra server.
RUN cd /home/ghidra/ghidra/server && \
    echo password | sudo -S "PATH=$PATH" ./svrInstall

# Ghidra's default port.
EXPOSE 13100

# $ echo password | sudo -S "PATH=$PATH" /home/ghidra/ghidra/server/ghidraSvr start
#ENTRYPOINT ["echo", "password", "|", "sudo", "-S", "\"PATH=$PATH\"", "/home/ghidra/ghidra/server/ghidraSvr", "start"]
ENTRYPOINT ["/bin/echo password | /usr/bin/sudo -S \"PATH=$PATH\" /home/ghidra/ghidra/server/ghidraSvr start"]
