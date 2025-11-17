#!/bin/bash

BENCH_DIR=${PARSECDIR}/vips

export CXXFLAGS="${CXXFLAGS} -fexceptions"
export LDFLAGS="${LDFLAGS} -lstdc++"

BUILD_DIR=${PARSECDIR}/vips/build/${PLATFORM}
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

if [ "${PLATFORM}" == "rv64" ]; then
    ${BENCH_DIR}/src/configure \
    --prefix=${BUILD_DIR} \
    --host=riscv64-unknown-linux-gnu \
    --disable-shared \
    --without-fftw3 \
    --without-magick \
    --without-liboil \
    --without-lcms \
    --without-OpenEXR \
    --without-matio \
    --without-pangoft2 \
    --without-tiff \
    --without-jpeg \
    --without-zip \
    --without-png \
    --without-libexif \
    --without-python \
    --without-x \
    --without-perl \
    --without-v4l \
    --without-cimg \
    --enable-threads
else
    ${BENCH_DIR}/src/configure \
    --prefix=${BUILD_DIR} \
    --disable-shared \
    --without-fftw3 \
    --without-magick \
    --without-liboil \
    --without-lcms \
    --without-OpenEXR \
    --without-matio \
    --without-pangoft2 \
    --without-tiff \
    --without-jpeg \
    --without-zip \
    --without-png \
    --without-libexif \
    --without-python \
    --without-x \
    --without-perl \
    --without-v4l \
    --without-cimg \
    --enable-threads
fi

make -C ${BUILD_DIR}/obj -j$(nproc)
make -C ${BUILD_DIR}/obj install