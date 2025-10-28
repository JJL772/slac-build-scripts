export TOOLCHAIN_PATH="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/host/linux-x86_64/i686/"

export TOOLCHAIN_SYSROOT="${TOOLCHAIN_PATH}/i686-buildroot-linux-gnu/sysroot"
export CC="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-gcc"
export CXX="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-g++"
export AR="${TOOLCHAIN_PATH}/bin/i686-buildroot-linux-gnu-gcc-ar"
export TARGET_SYSTEM=i686-buildroot-linux-gnu

# For aes-stream-drivers:
export ARCH=i686
export CROSS_COMPILE="${TOOLCHAIN_PATH}/bin/$ARCH-buildroot-linux-gnu-"
export KERNELDIR="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/buildroot-2019.08-$ARCH/output/build/linux-4.14.139"
