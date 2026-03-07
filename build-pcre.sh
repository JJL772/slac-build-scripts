#!/usr/bin/env bash
set -e
VERSION="$1"
TARGET="$2"

if [ -z "$VERSION" ] || [ -z "$TARGET" ]; then
    echo "USAGE: $0 8.37 rhel9-x86_64"
    exit 1
fi

mkdir -p "$PACKAGE_SITE_TOP/pcre/$VERSION"
cd "$PACKAGE_SITE_TOP/pcre/$VERSION"

if [ ! -d pcre-$VERSION ]; then
    wget "https://sourceforge.net/projects/pcre/files/pcre/$VERSION/pcre-$VERSION.tar.gz/download" -O "pcre-$VERSION.tar.gz"
    tar -xf pcre-$VERSION.tar.gz
fi

mkdir -p "build/$TARGET"
cd "build/$TARGET"

"../../pcre-$VERSION/configure" --prefix="$PWD/../../$TARGET"

make && make install
