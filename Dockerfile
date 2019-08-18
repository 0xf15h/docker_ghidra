FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ENV GHIDRA_REPOS_PATH /svr/repositories
ENV GHIDRA_INSTALL_PATH /opt
ENV GHIDRA_VERSION 9.0.4
ENV GHIDRA_SHA_256 a50d0cd475d9377332811eeae66e94bdc9e7d88e58477c527e9c6b78caec18bf

ENV JAVA_11_URL https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
ENV JAVA_DIR_NAME jdk-11.0.2
ENV JAVA_HOME /usr/lib/jvm/${JAVA_DIR_NAME}

# Create ghidra user.
RUN useradd -m ghidra && \
    adduser ghidra sudo && \
    echo "ghidra:password" | chpasswd && \
    usermod -aG sudo ghidra

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
    wget --progress=bar:force -O ghidra_${GHIDRA_VERSION}.zip https://ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip && \
    sha256sum ghidra_${GHIDRA_VERSION}.zip | awk '{print $1}' | grep -q $GHIDRA_SHA_256 && \
    unzip ghidra_${GHIDRA_VERSION}.zip && \
    mv ghidra_${GHIDRA_VERSION} ghidra && \
    rm ghidra_${GHIDRA_VERSION}.zip && \
    chown -R ghidra: ${GHIDRA_INSTALL_PATH}/ghidra

# Install Ghidra server.
RUN cd ${GHIDRA_INSTALL_PATH}/ghidra/server && \
    cp server.conf server.conf.bak && \
    mkdir -p ${GHIDRA_REPOS_PATH} && \
    sed 's|ghidra.repositories.dir=.*|ghidra.repositories.dir='"${GHIDRA_REPOS_PATH}"'|' server.conf.bak > server.conf && \
    echo password | sudo -S "PATH=$PATH" ${GHIDRA_INSTALL_PATH}/ghidra/server/svrInstall && \
    chown -R ghidra: ${GHIDRA_REPOS_PATH} && \
    cd /home/ghidra && \
    ln -s ${GHIDRA_INSTALL_PATH}/ghidra/server/svrAdmin svrAdmin && \
    ln -s ${GHIDRA_INSTALL_PATH}/ghidra/server/server.conf server.conf && \
    ln -s ${GHIDRA_INSTALL_PATH}/ghidra/server/svrInstall svrInstall && \
    ln -s ${GHIDRA_INSTALL_PATH}/ghidra/server/svrUninstall svrUninstall && \
    ln -s ${GHIDRA_INSTALL_PATH}/ghidra/server/ghidraSvr ghidraSvr 

VOLUME ${GHIDRA_REPOS_PATH}

# Setup user environment.
USER ghidra
WORKDIR /home/ghidra
ENV HOME /home/ghidra

# Ghidra's default ports.
EXPOSE 13100
EXPOSE 13101
EXPOSE 13102

COPY --chown=ghidra:ghidra start_server.sh /home/ghidra
ENTRYPOINT [ "./start_server.sh" ]