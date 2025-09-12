export TOOLCHAIN_PATH="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/host/linux-x86_64/i686/"

export TOOLCHAIN_SYSROOT="${TOOLCHAIN_PATH}/i686-buildroot-linux-gnu/sysroot"
export CC="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-gcc"
export CXX="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-g++"
export AR="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-gcc-ar"
export TARGET_SYSTEM=i686-buildroot-linux-gnu
