#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 1.64.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

# For RTEMS, it's not a "cross" build-- it's a symlink!!
if [[ $TARGET =~ "RTEMS"* ]]; then
    cd "$EPICS_PACKAGE_TOP/boost/$VER"
    mkdir -p $TARGET
    cd $TARGET
    if [ ! -L include ]; then
        ln -v -s ../buildroot-2019.08-x86_64/include ./include
    fi
    echo "Created symlink..."
    exit 0
fi

D=boost_$(echo $VER | sed 's/\./_/g')

mkdir -p $EPICS_PACKAGE_TOP/boost/$VER/build/$TARGET
cd $EPICS_PACKAGE_TOP/boost/$VER/src/$D

if [ ! -f "../boost-build/bin/b2" ]; then
    cd tools/build

    ./bootstrap.sh
    ./b2 --prefix="$PWD/../boost-build"
fi

cp -fv "$TOP/boost-jamfiles/"* .
if [[ $TARGET =~ buildroot-* ]]; then
    cp -fv "$TOP/boost-jamfiles/project-config.jam_$TARGET" ./project-config.jam
fi

../boost-build/bin/b2 --build-dir="$EPICS_PACKAGE_TOP/boost/$VER/build/$TARGET" --prefix="$EPICS_PACKAGE_TOP/boost/$VER/$TARGET" install
