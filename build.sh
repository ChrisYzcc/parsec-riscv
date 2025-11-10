#!/bin/bash

export PARSECDIR=$(pwd)

PLATFORM=native
PROGRAM=blackscholes
VERSION=pthreads

while getopts "p:rv:h" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        v) VERSION=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-h]"
           echo "  -p program : specify the program to build, default: blackscholes"
           echo "  -r          : set platform to rv64"
           echo "  -v version  : specify the version (pthreads, openmp, tbb), default: pthreads"
           echo "  -h          : display this help message"
           exit 0 ;;
    esac
done

# Arguments to use
export CFLAGS=" -O3 -g -funroll-loops -fprefetch-loop-arrays ${PORTABILITY_FLAGS}"
export CXXFLAGS="-O3 -g -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie"
export LIBS=""
export EXTRA_LIBS=""

# RISC-V Version Tools
export OPENSSL_RV_DIR="/home/yzcc/riscv64-openssl"
export ZLIB_RV_DIR="/home/yzcc/riscv64-zlib"

if [ "$PLATFORM" == "rv64" ]; then
    CROSS_COMPILE_PREFIX=riscv64-linux-gnu-
    export CFLAGS="$CFLAGS -I${OPENSSL_RV_DIR}/include/ -I${ZLIB_RV_DIR}/include/"
    export CXXFLAGS="$CXXFLAGS -I${OPENSSL_RV_DIR}/include/ -I${ZLIB_RV_DIR}/include/"
    export LDFLAGS="$LDFLAGS -L${OPENSSL_RV_DIR}/lib -L${ZLIB_RV_DIR}/lib"
else
    CROSS_COMPILE_PREFIX=
fi

# Compilers and preprocessors
CC_HOME=/usr/bin
export CC="${CC_HOME}/${CROSS_COMPILE_PREFIX}gcc"
export CXX="${CC_HOME}/${CROSS_COMPILE_PREFIX}g++"
export CPP="${CC_HOME}/${CROSS_COMPILE_PREFIX}cpp"

# GNU Binutils
BINUTIL_HOME=/usr/bin
export LD="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}ld"
export NM="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}nm"
export STRIP="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}strip"
export AR="${CC_HOME}/${CROSS_COMPILE_PREFIX}ar"
export RANLIB="${CC_HOME}/${CROSS_COMPILE_PREFIX}ranlib"

# GNU Tools
export M4=/usr/bin/m4
export MAKE=/usr/bin/make

export PLATFORM
export VERSION

echo "============================================================================"
echo "  Building Target : ${PROGRAM}"
echo "  Platform        : ${PLATFORM}"
echo "  Version         : ${VERSION}"
echo "============================================================================"

cd ${PROGRAM}
./build.sh
cd ..

echo "============================================================================"
echo "  Build of ${PROGRAM} completed."
echo "============================================================================"