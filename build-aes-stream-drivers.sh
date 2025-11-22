#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"
# SSH tunnel is optional in case you are having trouble with http proxies
SSH_TUNNEL="$3"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <target>"
    echo "Ex:"
    echo " $0 v6.7.1 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/linuxKernel_Modules/aes-stream-drivers/$VER
cd $EPICS_PACKAGE_TOP/linuxKernel_Modules/aes-stream-drivers/$VER

# Download and extract if not already
if [ ! -d src ]; then
    git clone --tags git@github.com:slaclab/aes-stream-drivers.git $TARGET
fi

cd $TARGET
git checkout $VER

if [ -f "$TOP/toolchains/$TARGET.bash" ]; then
    source "$TOP/toolchains/$TARGET.bash"
fi

make -j$(nproc)
