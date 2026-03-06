#!/usr/bin/env bash
set -e

VERSION="$1"
TARGET="$2"

if [ -z "$VERSION" ] || [ -z "$TARGET" ]; then
    echo "USAGE: $0 v1.0.20 rhel9-x86_64"
    exit 1
fi

mkdir -p "$PACKAGE_SITE_TOP/libusb/$VERSION"
cd "$PACKAGE_SITE_TOP/libusb/$VERSION"

if [ ! -d src ]; then
    git clone https://github.com/libusb/libusb.git src -b "$VERSION"
fi

cd src
NOCONFIGURE=1 ./autogen.sh
cd ..

mkdir -p "build/$TARGET"
cd "build/$TARGET"

../../src/configure --prefix="$PWD/../../$TARGET"

make && make install
