TOOLCHAIN_PATH="/sdf/sw/epics/package/linuxRT/buildroot-2019.08/host/linux-x86_64/arm/"

export TOOLCHAIN_SYSROOT="${TOOLCHAIN_PATH}/arm-buildroot-linux-gnueabi/sysroot"
export CC="${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-gcc"
export CXX="${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-g++"
