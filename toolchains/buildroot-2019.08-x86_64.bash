export TOOLCHAIN_PATH="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/host/linux-x86_64/x86_64/"

export TOOLCHAIN_SYSROOT="${TOOLCHAIN_PATH}/x86_64-buildroot-linux-gnu/sysroot"
export CC="${TOOLCHAIN_PATH}/bin/x86_64-buildroot-linux-gnu-gcc"
export CXX="${TOOLCHAIN_PATH}/bin/x86_64-buildroot-linux-gnu-g++"
export AR="${TOOLCHAIN_PATH}/bin/x86_64-buildroot-linux-gnu-gcc-ar"
export TARGET_SYSTEM=x86_64-buildroot-linux-gnu
