# this Dockerfile depends on (at least):
# - github.com/koreader/koxtoolchain
# - github.com/NiLuJe/crosstool-ng
# - github.com/KindleModding/kindle-sdk
# - s3.amazonaws.com/firmwaredownloads
# truly a list of things that can vanish at any time

# FROM ghcr.io/cross-rs/armv7-unknown-linux-gnueabihf:edge
FROM docker.io/debian:trixie

# install kindle-sdk and fltk-rs build dependencies
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates build-essential git unzip curl wget \
    libarchive-dev nettle-dev sudo zlib1g-dev e2fsprogs aria2 \
    cmake \
 && rm -rf /var/lib/apt/lists/*

# prepare for sdk build
RUN useradd -m -s /bin/bash user \
 && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && mkdir -p /sdk && chown user:user /sdk

USER user
WORKDIR /sdk

# download koxtoolchain (kindlehf, kindlepw2)
RUN wget -qO- 'https://github.com/koreader/koxtoolchain/releases/download/2025.05/kindlehf.tar.gz' \
  | tar xz -C /home/user
RUN wget -qO- 'https://github.com/koreader/koxtoolchain/releases/download/2025.05/kindlepw2.tar.gz' \
  | tar xz -C /home/user
# alternatively, build koxtoolchain. takes about 30 minutes
# RUN apt-get update -y \
#  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#     automake autoconf bison flex gawk libtool libtool-bin libncurses-dev gperf help2man texinfo \
#  && rm -rf /var/lib/apt/lists/* \
#  && git clone --recursive --depth=1 'https://github.com/koreader/koxtoolchain.git' \
#  && cd koxtoolchain \
#  && git fetch --depth=1 origin 'a0f009e302c4f7a6c06df01cb8e2904cd411d888' \
#  && git checkout 'a0f009e302c4f7a6c06df01cb8e2904cd411d888' \
#  && ./gen-tc.sh kindlehf \
#  && ./gen-tc.sh kindlepw2 \
#  && cd /sdk \
#  && rm -rf koxtoolchain

# build kindle-sdk (kindlehf, kindlepw2)
RUN git clone --recursive --depth=1 'https://github.com/KindleModding/kindle-sdk.git' \
 && cd kindle-sdk \
 && git fetch --depth=1 origin '0d42abf444aa4dd50ef05428481da32be409c7e1' \
 && git checkout '0d42abf444aa4dd50ef05428481da32be409c7e1' \
 && sed -i '1119,1132d' 'KindleTool/KindleTool/kindle_tool.c' \
 && sed -i '109s|sudo mount -o loop rootfs.img mnt|sudo debugfs -R "rdump / mnt" rootfs.img|' 'gen-sdk.sh' \
 && sed -i '212d' 'gen-sdk.sh' \
 && ./gen-sdk.sh kindlehf \
 && ./gen-sdk.sh kindlepw2 \
 && cd /sdk \
 && sudo rm -rf kindle-sdk

USER root
WORKDIR /
