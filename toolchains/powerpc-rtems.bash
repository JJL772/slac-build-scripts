export RTEMS_TOP="${EPICS_PACKAGE_TOP}/rtems/4.10.2/target/rtems_p3"

export PATH="${EPICS_PACKAGE_TOP}/rtems/4.10.2/host/amd64_linux26/bin:$PATH"

export CC="powerpc-rtems-gcc"
export CXX="powerpc-rtems-g++"
export AR="powerpc-rtems-gcc-ar"

export RTEMS_BSPS="beatnik mvme3100 svgm"

