#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="v4.1.5"
CROSS_TARGETS="buildroot-2025.02-x86_64 buildroot-2019.08-x86_64 buildroot-2019.08-i686 buildroot-2019.08-arm RTEMS-beatnik RTEMS-mvme3100 RTEMS-uC5282"

for ver in $VERSIONS; do
	./build-libzmq.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-libzmq.sh $ver $target
	done
done
