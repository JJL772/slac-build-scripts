#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
ARCH="$2"
# SSH tunnel is optional in case you are having trouble with http proxies
SSH_TUNNEL="$3"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch> [ssh tunnel]"
    echo "ssh tunnel is optional. You can downlading using another machine that you have access"
    echo "Ex:"
    echo " $0 1.0.8 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$ARCH" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/bzip2/$VER
cd $EPICS_PACKAGE_TOP/bzip2/$VER

# Download and extract if not already
if [ ! -d src ]; then
    echo "Downloading bzip2 tarball"
    if [ -z "$3" ]; then
        # We aren't using SSH tunnel
        wget http://sourceware.org/pub/bzip2/bzip2-$VER.tar.gz
    else
        ssh $3 "wget -q -O - https://sourceware.org/pub/bzip2/bzip2-$VER.tar.gz" >> bzip2-$VER.tar.gz
    fi
    tar -xzf bzip2-$VER.tar.gz
    mv bzip2-$VER src
fi

mkdir $ARCH
cd src

if [ -f "$TOP/toolchains/$ARCH.bash" ]; then
    source "$TOP/toolchains/$ARCH.bash"
fi

make -j$(nproc)

make install PREFIX="$PWD/../$ARCH"
