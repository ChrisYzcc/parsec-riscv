export PARSECDIR=$(pwd)

PLATFORM=native
PROGRAM=blackscholes
VERSION=pthreads
ALL="blackscholes bodytrack canneal dedup facesim ferret fluidanimate freqmine streamcluster swaptions x264 vips"

USAGE="normal"
ENABLE_CHECKPOINT=false

while getopts "p:ru:hv:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        u) USAGE=$OPTARG ;;
        v) VERSION=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-u usage] [-h]"
           echo "  -p program   : specify the program to build. Default: barnes"
           echo "  -r           : set platform to rv64"
           echo "  -v           : set version: pthreads, openmp. Default: pthreads"
           echo "  -u           : set usage: normal, profiling, checkpoint. Default: normal"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

# Check Version
if [ "${VERSION}" != "pthreads" ] && [ "${VERSION}" != "openmp" ]; then
    echo "\033[31m[ERROR] Unknown version: ${VERSION}\033[0m"
    exit 1
fi

# Arguments to use
export CFLAGS=" -O3 -g -funroll-loops ${PORTABILITY_FLAGS}"
export CXXFLAGS="-O3 -g -funroll-loops -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie"
export LIBS=""
export EXTRA_LIBS=""

# RISC-V Version Tools
RV_LIB_PREFIX=${PARSECDIR}/parsec_rv_libs
export OPENSSL_RV_DIR="${RV_LIB_PREFIX}/riscv64-openssl"
export ZLIB_RV_DIR="${RV_LIB_PREFIX}/riscv64-zlib"
export GSL_RV_DIR="${RV_LIB_PREFIX}/riscv64-gsl"
export LIBJPEG_RV_DIR="${RV_LIB_PREFIX}/riscv64-libjpeg"
export GLIB_RV_DIR="${RV_LIB_PREFIX}/riscv64-glib"
export LIBXML2_RV_DIR="${RV_LIB_PREFIX}/riscv64-libxml2"
export LIBFFI_RV_DIR="${RV_LIB_PREFIX}/riscv64-libffi"
export PCRE2_RV_DIR="${RV_LIB_PREFIX}/riscv64-pcre2"

if [ "$PLATFORM" = "rv64" ]; then
    CROSS_COMPILE_PREFIX=riscv64-linux-gnu-
    export CFLAGS="$CFLAGS \
        -I${OPENSSL_RV_DIR}/include/ \
        -I${ZLIB_RV_DIR}/include/ \
        -I${GSL_RV_DIR}/include/ \
        -I${LIBJPEG_RV_DIR}/include/ \
        -I${GLIB_RV_DIR}/include/ \
        -I${LIBXML2_RV_DIR}/include/ \
        -I${LIBFFI_RV_DIR}/include/ \
        -I${PCRE2_RV_DIR}/include/"
    export CXXFLAGS="$CXXFLAGS \
        -I${OPENSSL_RV_DIR}/include/ \
        -I${ZLIB_RV_DIR}/include/ \
        -I${GSL_RV_DIR}/include/ \
        -I${LIBJPEG_RV_DIR}/include/ \
        -I${GLIB_RV_DIR}/include/ \
        -I${LIBXML2_RV_DIR}/include/ \
        -I${LIBFFI_RV_DIR}/include/ \
        -I${PCRE2_RV_DIR}/include/"
    export LDFLAGS="$LDFLAGS \
        -L${OPENSSL_RV_DIR}/lib \
        -L${ZLIB_RV_DIR}/lib \
        -L${GSL_RV_DIR}/lib \
        -L${LIBJPEG_RV_DIR}/lib \
        -L${GLIB_RV_DIR}/lib \
        -L${LIBXML2_RV_DIR}/lib \
        -L${LIBFFI_RV_DIR}/lib \
        -L${PCRE2_RV_DIR}/lib"
else
    CROSS_COMPILE_PREFIX=
fi

USE_STATIC=yes
if [ "$USE_STATIC" = "yes" ]; then
    export CFLAGS="${CFLAGS} -static"
    export CXXFLAGS="${CXXFLAGS} -static"
    export LDFLAGS="${LDFLAGS} -static"
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

# Check usage mode
if [ "$USAGE" = "checkpoint" ]; then
    ENABLE_CHECKPOINT=true
elif [ "$USAGE" = "profiling" ]; then
    ENABLE_CHECKPOINT=true
    export CFLAGS="${CFLAGS} -DENABLE_PROFILING"
    export CXXFLAGS="${CXXFLAGS} -DENABLE_PROFILING"
elif [ "$USAGE" != "normal" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

export USAGE

# Build parsec_hook for checkpoint
if [ "${ENABLE_CHECKPOINT}" = "true" ]; then
    echo "============================================================================"
    echo "  Building Target : parsec_hooks (FOR CHECKPOINTING AND PROFILING)"
    echo "  Platform        : ${PLATFORM}"
    echo "============================================================================"

    if [ "${PLATFORM}" = "rv64" ]; then
        export CFLAGS="${CFLAGS} -DNEMU"
        export CXXFLAGS="${CXXFLAGS} -DNEMU"
    fi

    if [ ! -d "${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/lib" ]; then
        mkdir -p ${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        cp -r ${PARSECDIR}/parsec_hooks/src/* ${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        make -C ${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj
        make -C ${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/obj install

        if [ $? -ne 0 ]; then
            echo "\033[31m[ERROR] Build failed for parsec_hooks!\033[0m"
            exit 1
        else
            echo "\033[32mparsec_hooks built successfully for ${PLATFORM}, ${USAGE}.\033[0m"
        fi
    else
        echo "  parsec_hooks already built for ${PLATFORM}, ${USAGE}, skipping."
    fi

    export CFLAGS="${CFLAGS} -I${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/include -DENABLE_PARSEC_HOOKS"
    export CXXFLAGS="${CXXFLAGS} -I${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/include -DENABLE_PARSEC_HOOKS"
    export LDFLAGS="${LDFLAGS} -L${PARSECDIR}/parsec_hooks/build/${PLATFORM}/${USAGE}/lib -lhooks"
    export LIBS="${LIBS} -lhooks"

    echo "============================================================================"
    echo
fi

if [ "${PROGRAM}" = "all" ]; then
    FAILED_LIST=""
    for prog in $ALL; do
        echo "============================================================================"
        echo "  Building Target : ${prog}"
        echo "  Platform        : ${PLATFORM}"
        echo "  Version         : ${VERSION}"
        echo "  USAGE           : ${USAGE}"
        echo "============================================================================"
        cd ${prog}
        ./build.sh
        if [ $? -ne 0 ]; then
            echo "\033[31m[ERROR] Build failed for ${prog}!\033[0m"
            FAILED_LIST="$FAILED_LIST $prog"
        else
            echo "\033[32m${prog} built successfully for ${PLATFORM}, ${USAGE}.\033[0m"
        fi
        cd ${PARSECDIR}
    done

    echo "============================================================================"
    echo "  Build of all programs completed."
    echo "============================================================================"
    if [ -n "$FAILED_LIST" ]; then
        echo "\033[31m[ERROR] The following programs failed to build:$FAILED_LIST\033[0m"
        exit 1
    fi
    exit 0
else
    echo "============================================================================"
    echo "  Building Target : ${PROGRAM}"
    echo "  Platform        : ${PLATFORM}"
    echo "  Version         : ${VERSION}"
    echo "  USAGE           : ${USAGE}"
    echo "============================================================================"

    cd ${PROGRAM}
    ./build.sh
    if [ $? -ne 0 ]; then
        echo "\033[31m[ERROR] Build failed for ${PROGRAM}!\033[0m"
    else
        echo "\033[32m${PROGRAM} built successfully for ${PLATFORM}, ${USAGE}.\033[0m"
    fi
    cd ${PARSECDIR}

    echo "============================================================================"
    echo "  Build of ${PROGRAM} completed."
    echo "============================================================================"
fi