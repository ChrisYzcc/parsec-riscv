#!/bin/bash

BENCH_DIR=${PARSECDIR}/bodytrack

export CXXFLAGS="${CXXFLAGS} -fexceptions"
export VPATH="${BENCH_DIR}/src"

BUILD_DIR=${PARSECDIR}/bodytrack/build/${PLATFORM}
if [ ! -d "${BUILD_DIR}" ]; then
    mkdir -p ${BUILD_DIR}
else
    rm -rf ${BUILD_DIR}/*
fi

cd src
autoreconf -fiv
cd ..

# Compile in tmp dir
mkdir -p ${BUILD_DIR}/obj
cd ${BUILD_DIR}/obj

VERSION_SUFFIX="threads"
if [ "${VERSION}" == "openmp" ]; then
    VERSION_SUFFIX="openmp"
elif [ "${VERSION}" == "tbb" ]; then
    VERSION_SUFFIX="tbb"
fi

if [ "${PLATFORM}" == "riscv64" ]; then
    ${BENCH_DIR}/src/configure --prefix=${BUILD_DIR} --enable-${VERSION_SUFFIX} --host=riscv64-unknown-linux-gnu
else
    ${BENCH_DIR}/src/configure --prefix=${BUILD_DIR} --enable-${VERSION_SUFFIX}
fi

make -C ${BUILD_DIR}/obj version=${VERSION} -j$(nproc)
make -C ${BUILD_DIR}/obj version=${VERSION} install

# Rename the executable to include platform and version info
mv ${BUILD_DIR}/bin/bodytrack ${BUILD_DIR}/bin/bodytrack-${VERSION}