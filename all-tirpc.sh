#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="1.3.5"
CROSS_TARGETS="buildroot-2025.02-x86_64 buildroot-2019.08-x86_64 buildroot-2019.08-i686 buildroot-2019.08-arm"

for ver in $VERSIONS; do
	./build-tirpc.sh $ver $EPICS_HOST_ARCH
	for target in $CROSS_TARGETS; do
		./build-tirpc.sh $ver $target
	done
done

