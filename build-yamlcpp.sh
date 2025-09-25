#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 yaml-cpp-0.5.3_boost-1.64.0 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

cd $EPICS_PACKAGE_TOP/yaml-cpp/$VER/src
mkdir -p ../build

if [[ $TARGET =~ "buildroot"* ]]; then
    EXTRA_CMAKE_ARGS="-DCMAKE_TOOLCHAIN_FILE=${TOP}/toolchains/${TARGET}.cmake"
fi

# Boost build? darn...
if [[ $VER =~ "boost-1.64.0" ]]; then
    BOOST_ROOT="$EPICS_PACKAGE_TOP/boost/1.64.0/$TARGET"
    EXTRA_CMAKE_ARGS="$EXTRA_CMAKE_ARGS -DBOOST_ROOT=${BOOST_ROOT} -DBoost_INCLUDE_DIR=${BOOST_ROOT}/include"
    echo "Using boost"
fi

cmake . -B../build/$TARGET -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PWD/../$TARGET" $EXTRA_CMAKE_ARGS

cd ../build/$TARGET

make -j$(nproc) install

