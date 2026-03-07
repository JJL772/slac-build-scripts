#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="3.2.2"
CROSS_TARGETS="buildroot-2019.08-x86_64 rtems-4.10.2-powerpc"

for ver in $VERSIONS; do
	./build-fftw.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-fftw.sh $ver $target
	done
done

