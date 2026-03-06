#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 4.4.2 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/dhcp/$VER
cd $EPICS_PACKAGE_TOP/dhcp/$VER

mkdir -p "build/$TARGET"
cd "build/$TARGET"

if [[ $TARGET = *"buildroot"* ]]; then
    echo "Building for buildroot"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$TARGET.bash
    export PATH="${TOOLCHAIN_PATH}/bin:$PATH"
    ../../dhcp-$VER/configure --prefix="$PWD/../../$TARGET" --host $TARGET_SYSTEM --with-randomdev=no
else
    ../../dhcp-$VER/configure --prefix="$PWD/../../$TARGET" --with-randomdev=no
fi

make && make install

