#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSIONS="1.0.8"
CROSS_TARGETS="buildroot-2025.02-x86_64 buildroot-2019.08-x86_64 buildroot-2019.08-i686 buildroot-2019.08-arm RTEMS-beatnik RTEMS-mvme3100 RTEMS-uC5282"
SSH_TUNNEL="$1"

for ver in $VERSIONS; do
	./build-bzip2.sh $ver $EPICS_HOST_ARCH $SSH_TUNNEL
	for target in $CROSS_TARGETS; do
        # ssh_tunnel is optional
		./build-bzip2.sh $ver $target $SSH_TUNNEL
	done
done
