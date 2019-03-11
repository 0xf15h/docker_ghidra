FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV GHIDRA_REPOS_PATH /svr/repositories
ENV GHIDRA_INSTALL_PATH /opt
ENV GHIDRA_VERSION 9.0
ENV GHIDRA_SHA_256 3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2

ENV JAVA_11_URL https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
ENV JAVA_DIR_NAME jdk-11.0.2

# Create ghidra user.
RUN useradd -m ghidra && \
    adduser ghidra sudo && \
    echo "ghidra:password" | chpasswd && \
    usermod -aG sudo ghidra && \
    mkdir -p ${GHIDRA_REPOS_PATH} && \
    chown -R ghidra: ${GHIDRA_REPOS_PATH}

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    sudo 

# Install Java 11.
RUN cd /home/ghidra && \
    wget --progress=bar:force -O openjdk.tar.gz ${JAVA_11_URL} && \
    mkdir /usr/lib/jvm && \
    tar -xzf openjdk.tar.gz --directory /usr/lib/jvm && \
    rm openjdk.tar.gz && \
    echo "/usr/lib/jvm/${JAVA_DIR_NAME}/bin:${PATH}" > /etc/environment
ENV PATH "/usr/lib/jvm/${JAVA_DIR_NAME}/bin:${PATH}"

# Get Ghidra.
RUN cd ${GHIDRA_INSTALL_PATH} && \
    wget --progress=bar:force -O ghidra_${GHIDRA_VERSION}.zip https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip && \
    sha256sum ghidra_${GHIDRA_VERSION}.zip | awk '{print $1}' | grep -q $GHIDRA_SHA_256 && \
    unzip ghidra_${GHIDRA_VERSION}.zip && \
    mv ghidra_${GHIDRA_VERSION} ghidra && \
    rm ghidra_${GHIDRA_VERSION}.zip && \
    chown -R ghidra: ${GHIDRA_INSTALL_PATH}/ghidra

# Setup Ghidra's version tracking repositories volume.
VOLUME ${GHIDRA_REPOS_PATH}

# Install Ghidra server.
RUN echo password | sudo -S "PATH=$PATH" ${GHIDRA_INSTALL_PATH}/ghidra/server/svrInstall

# Setup user environment.
USER ghidra
WORKDIR /home/ghidra
ENV HOME /home/ghidra

# Ghidra's default ports.
EXPOSE 13100
EXPOSE 13101
EXPOSE 13102

COPY --chown=ghidra:ghidra start_server.sh /home/ghidra/