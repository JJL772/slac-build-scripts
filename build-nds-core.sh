#!/usr/bin/env bash

set -e

TOP="$PACKAGE_SITE_TOP/build-scripts"

VERSION="$1"
TARGET="$2"

mkdir -p "$PACKAGE_SITE_TOP/nds-core"
cd "$PACKAGE_SITE_TOP/nds-core"

if [ -z "$VERSION" ] || [ -z "$TARGET" ]; then
    echo "USAGE: $0 3.2.0 rhel9-x86_64"
    exit 1
fi

mkdir -p "$VERSION"
cd "$VERSION"

if [ ! -d src ]; then
    git clone https://github.com/NDSv3/nds-core.git src 
fi

mkdir -p "build/$TARGET"
cd "build/$TARGET"

cmake ../../src/CMake -DCMAKE_INSTALL_PREFIX="$PWD/../../$TARGET" -DCMAKE_BUILD_TYPE=Release

make && make install

