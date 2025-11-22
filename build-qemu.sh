#!/usr/bin/env bash

set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 v9.1.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/qemu/$VER
cd $EPICS_PACKAGE_TOP/qemu/$VER

# Download and extract if not already
if [ ! -d src ]; then
    git clone --depth=1 https://github.com/qemu/qemu.git src -b $VER
fi

mkdir -p build/$TARGET
cd build/$TARGET

source $EPICS_PACKAGE_TOP/anaconda/envs/python3.10envs/v1.0/bin/activate

../../src/configure --target-list="ppc-softmmu arm-softmmu aarch64-softmmu riscv32-softmmu riscv64-softmmu i386-softmmu x86_64-softmmu m68k-softmmu" \
    --prefix="$PWD/../../$TARGET" --disable-docs --disable-containers --disable-opengl --disable-sdl --enable-slirp

make -j$(nproc) && make install -j$(nproc)
