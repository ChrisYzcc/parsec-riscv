export PARSECDIR=$(pwd)

PLATFORM=native
PROGRAM=blackscholes
VERSION=pthreads
ALL="blackscholes bodytrack canneal dedup facesim ferret fluidanimate freqmine streamcluster swaptions x264"

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
export CFLAGS=" -O3 -g -funroll-loops ${PORTABILITY_FLAGS} -static"
export CXXFLAGS="-O3 -g -funroll-loops -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98 -static"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie -static"
export LIBS=""
export EXTRA_LIBS=""

# RISC-V Version Tools
RV_LIB_PREFIX="/home/yzcc"
export OPENSSL_RV_DIR="${RV_LIB_PREFIX}/riscv64-openssl"
export ZLIB_RV_DIR="${RV_LIB_PREFIX}/riscv64-zlib"
export GSL_RV_DIR="${RV_LIB_PREFIX}/riscv64-gsl"
export LIBJPEG_RV_DIR="${RV_LIB_PREFIX}/riscv64-libjpeg"
export GLIB_RV_DIR="${RV_LIB_PREFIX}/riscv64-glib"
export LIBXML2_RV_DIR="${RV_LIB_PREFIX}/riscv64-libxml2"

if [ "$PLATFORM" = "rv64" ]; then
    CROSS_COMPILE_PREFIX=riscv64-linux-gnu-
    export CFLAGS="$CFLAGS \
        -I${OPENSSL_RV_DIR}/include/ \
        -I${ZLIB_RV_DIR}/include/ \
        -I${GSL_RV_DIR}/include/ \
        -I${LIBJPEG_RV_DIR}/include/ \
        -I${GLIB_RV_DIR}/include/ \
        -I${LIBXML2_RV_DIR}/include/"
    export CXXFLAGS="$CXXFLAGS \
        -I${OPENSSL_RV_DIR}/include/ \
        -I${ZLIB_RV_DIR}/include/ \
        -I${GSL_RV_DIR}/include/ \
        -I${LIBJPEG_RV_DIR}/include/ \
        -I${GLIB_RV_DIR}/include/ \
        -I${LIBXML2_RV_DIR}/include/"
    export LDFLAGS="$LDFLAGS \
        -L${OPENSSL_RV_DIR}/lib \
        -L${ZLIB_RV_DIR}/lib \
        -L${GSL_RV_DIR}/lib \
        -L${LIBJPEG_RV_DIR}/lib \
        -L${GLIB_RV_DIR}/lib \
        -L${LIBXML2_RV_DIR}/lib"
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

if [ "${PROGRAM}" = "all" ]; then


    FAILED_LIST=""
    for prog in $ALL; do
        echo "============================================================================"
        echo "  Building Target : ${prog}"
        echo "  Platform        : ${PLATFORM}"
        echo "  Version         : ${VERSION}"
        echo "============================================================================"
        cd ${prog}
        ./build.sh
        if [ $? -ne 0 ]; then
            echo -e "\033[31m[ERROR] Build failed for ${prog}!\033[0m"
            FAILED_LIST="$FAILED_LIST $prog"
        fi
        cd ..
    done

    echo "============================================================================"
    echo "  Build of all programs completed."
    echo "============================================================================"
    if [ -n "$FAILED_LIST" ]; then
        echo -e "\033[31m[ERROR] The following programs failed to build:$FAILED_LIST\033[0m"
        exit 1
    fi
    exit 0
else
    echo "============================================================================"
    echo "  Building Target : ${PROGRAM}"
    echo "  Platform        : ${PLATFORM}"
    echo "  Version         : ${VERSION}"
    echo "============================================================================"


    cd ${PROGRAM}
    ./build.sh
    if [ $? -ne 0 ]; then
        echo -e "\033[31m[ERROR] Build failed for ${PROGRAM}!\033[0m"
        cd ..
        exit 1
    fi
    cd ..

    echo "============================================================================"
    echo "  Build of ${PROGRAM} completed."
    echo "============================================================================"
fi