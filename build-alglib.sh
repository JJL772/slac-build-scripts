#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 3.14.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $EPICS_PACKAGE_TOP/alglib/$VER
cd $EPICS_PACKAGE_TOP/alglib/$VER

# Clone alglib-gnubld if not already
if [ ! -d alglib-gnubld ]; then
    git clone git@github.com:slac-epics/alglib-gnubld.git --recursive
    cd alglib-gnubld
    autoreconf -i
    cd ..
fi

# Grab tarball
if [ ! -f "alglib-$VER.cpp.gpl.tgz" ]; then
    wget "https://www.alglib.net/translator/re/alglib-$VER.cpp.gpl.tgz"
    tar -xf "alglib-$VER.cpp.gpl.tgz"
    ln -s ./cpp/src ./src
fi

mkdir -p "build/$TARGET"
cd "build/$TARGET"

if [[ $TARGET = *"rtems"* ]]; then
    echo "Building for RTEMS"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$TARGET.bash
    ../../alglib-gnubld/configure --prefix="$PWD/../../$TARGET" --enable-rtemsbsp="${RTEMS_BSPS}" --exec-prefix="${EPICS_PACKAGE_TOP}/alglib/$VER/RTEMS-\${rtems_bsp}" --with-rtems-top="${RTEMS_TOP}"
elif [[ $TARGET = *"buildroot"* ]]; then
    echo "Building for buildroot"
    . $EPICS_PACKAGE_TOP/build-scripts/toolchains/$TARGET.bash
    export PATH="${TOOLCHAIN_PATH}/bin:$PATH"
    ../../alglib-gnubld/configure --prefix="$PWD/../../$TARGET" --host $TARGET_SYSTEM
else
    ../../alglib-gnubld/configure --prefix="$PWD/../../$TARGET"
fi

make -j$(nproc) install

