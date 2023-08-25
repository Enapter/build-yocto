#
# Docker image to build Yocto 4.2
#
FROM ubuntu:20.04

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y bc bison bsdmainutils build-essential curl locales \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses-dev \
        lib32z1-dev libncurses5-dev git-lfs \
        libsdl1.2-dev libxml2-utils lzop \
        openjdk-8-jdk lzop wget unzip \
        genisoimage sudo socat xterm gawk cpio texinfo \
        gettext vim diffstat chrpath \
        python-mako libusb-1.0-0-dev exuberant-ctags \
        pngcrush schedtool xsltproc zip zlib1g-dev libswitch-perl \
        screen rsync jq python3-pip docker.io parted liblz4-tool zstd \
        mtools && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install yq

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN groupadd --gid 1000 build && \
    useradd --uid 1000 --gid 1000 --create-home build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build && \
    chmod 0440 /etc/sudoers.d/build

RUN mkdir -p /home/build/tmp && chown build:build /home/build/tmp/

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV DL_DIR /home/build/downloads
ENV TMPDIR /home/build/tmp

ENV HOME /home/build
ENV USER build

ENV PATH="$PATH:/home/build/.local/bin"

USER build
WORKDIR /home/build
