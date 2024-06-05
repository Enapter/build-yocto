#
# Docker image to build Yocto 5.0
#
FROM ubuntu:22.04

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gawk wget git diffstat unzip texinfo gcc build-essential chrpath \
        socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
        iputils-ping python3-git python3-jinja2 python3-subunit zstd \
        liblz4-tool file locales libacl1 bc bison curl flex gnupg gperf \
        lzop wget unzip sudo socat gettext zip screen rsync jq parted liblz4-tool \
        zstd mtools vim squashfs-tools mc rpm qemu-system && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install yq

RUN groupadd --gid 1000 build && \
    useradd --uid 1000 --gid 1000 --create-home build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build && \
    chmod 0440 /etc/sudoers.d/build

RUN mkdir -p /home/build/tmp && chown build:build /home/build/tmp/

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV HOME /home/build
ENV USER build

USER build
WORKDIR /home/build
