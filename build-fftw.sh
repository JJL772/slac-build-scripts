#!/usr/bin/env bash
# vim: ts=4 sw=4 et
set -e
VER="$1"
TARGET="$2"

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function usage {
    echo "USAGE: $0 <version> <arch>"
    echo "Ex:"
    echo " $0 3.2.2 rhel9-x86_64"
    exit 1
}

if [ -z "$VER" ]; then
    usage
fi
if [ -z "$TARGET" ]; then
    usage
fi

mkdir -p $PACKAGE_SITE_TOP/fftw/fftw-$VER
cd $PACKAGE_SITE_TOP/fftw/fftw-$VER

# Grab tarball
if [ ! -d "fftw-$VER" ]; then
    curl -OL "https://fftw.org/pub/fftw/fftw-$VER.tar.gz"
    tar -xf "fftw-${VER}.tar.gz"
fi

mkdir -p "build/$TARGET"
cd "build/$TARGET"

# Need to build for both default and single precision floats
for type in default single; do

    mkdir -p ${type}
    pushd ${type} > /dev/null
    echo "Building for ${type}"

    if [ "${type}" = "single" ]; then
        EXTRA_ARGS="--enable-single"
    fi

    if [[ $TARGET = *"rtems"* ]]; then
        echo "Building for RTEMS"

        . ${TOP}/toolchains/${TARGET}.bash
        # Bit of a hack; otherwise some application we can't disable won't link
        export LDFLAGS="$LDFLAGS -Wl,-u,main"
    
        ../../../fftw-${VER}/configure --prefix="${PWD}/../../../${TARGET}" --disable-fortran --with-our-malloc16 --host ${TARGET_SYSTEM} $EXTRA_ARGS

    elif [[ $TARGET = *"buildroot"* ]]; then
        echo "Building for buildroot"

        . $TOP/toolchains/$TARGET.bash
        export PATH="${TOOLCHAIN_PATH}/bin:$PATH"

        ../../../fftw-${VER}/configure --prefix="${PWD}/../../../${TARGET}" --disable-fortran --with-our-malloc16 --host ${TARGET_SYSTEM} $EXTRA_ARGS

    else
        # Standard Linux build
        ../../../fftw-${VER}/configure --prefix="${PWD}/../../../${TARGET}" $EXTRA_ARGS
    fi

    make -j$(nproc) install

    popd > /dev/null
done

