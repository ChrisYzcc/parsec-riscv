#!/bin/bash

export CXXFLAGS="${CXXFLAGS} -fexceptions"

BUILD_DIR=${PARSECDIR}/bodytrack/build/${PLATFORM}
if [ ! -d "${BUILD_DIR}" ]; then
    mkdir -p ${BUILD_DIR}
else
    rm -rf ${BUILD_DIR}/*
fi

cd src

VERSION_SUFFIX="threads"
if [ "${VERSION}" == "openmp" ]; then
    VERSION_SUFFIX="openmp"
elif [ "${VERSION}" == "tbb" ]; then
    VERSION_SUFFIX="tbb"
fi

if [ "${PLATFORM}" == "riscv64" ]; then
    ./configure --prefix=${BUILD_DIR} --enable-${VERSION_SUFFIX} --host=riscv64-unknown-linux-gnu
else
    ./configure --prefix=${BUILD_DIR} --enable-${VERSION_SUFFIX}
fi

make version=${VERSION} clean
make version=${VERSION} -j$(nproc)
make version=${VERSION} install

# Rename the executable to include platform and version info
mv ${BUILD_DIR}/bin/bodytrack ${BUILD_DIR}/bin/bodytrack-${VERSION}