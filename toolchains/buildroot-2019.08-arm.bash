export TOOLCHAIN_PATH="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/host/linux-x86_64/arm/"

export TOOLCHAIN_SYSROOT="${TOOLCHAIN_PATH}/arm-buildroot-linux-gnueabi/sysroot"
export CC="${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-gcc"
export CXX="${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-g++"
export AR="${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-gcc-ar"
export TARGET_SYSTEM=arm-buildroot-linux-gnueabi

# For aes-stream-drivers:
export ARCH=arm
export CROSS_COMPILE="${TOOLCHAIN_PATH}/bin/$ARCH-buildroot-linux-gnueabi-"
export KERNELDIR="${EPICS_PACKAGE_TOP}/linuxRT/buildroot-2019.08/buildroot-2019.08-zynq/output/build/linux-4.14.139"
