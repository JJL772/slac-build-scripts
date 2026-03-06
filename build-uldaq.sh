#!/usr/bin/env bash

set -e

TOP="$PACKAGE_SITE_TOP/build-scripts"

VERSION="$1"
TARGET="$2"

mkdir -p "$PACKAGE_SITE_TOP/uldaq"
cd "$PACKAGE_SITE_TOP/uldaq"

if [ -z "$VERSION" ] || [ -z "$TARGET" ]; then
    echo "USAGE: $0 1.2.1 rhel9-x86_64"
    exit 1
fi

mkdir -p "$VERSION"
cd "$VERSION"

if [ ! -d src ]; then
    git clone https://github.com/mccdaq/uldaq.git src
fi

cd src

# Apply patches
if [ ! -f .patches-applied ]; then
    for f in "$TOP/patches/*-uldaq.diff"; do
        git apply $f
    done
    touch .patches-applied
fi

autoreconf -vif
cd ..

mkdir -p "build/$TARGET"
cd "build/$TARGET"

# Add libusb to PKG_CONFIG path
#export PKG_CONFIG_PATH="$PACKAGE_SITE_TOP/libusb/v1.0.0/$TARGET/lib/pkgconfig:/usr/lib64/pkgconfig"

LIBUSB="$PACKAGE_SITE_TOP/libusb/v1.0.20/$TARGET"
export CFLAGS="-I$LIBUSB/include -isystem $LIBUSB/include"
export CXXFLAGS="-I$LIBUSB/include -isystem $LIBUSB/include"
export LDFLAGS="-L$LIBUSB/lib"

../../src/configure --prefix="$PWD/../../$TARGET" --disable-udev-install CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" CPPFLAGS="$CFLAGS"

make && make install

