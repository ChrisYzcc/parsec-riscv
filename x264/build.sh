BENCH_DIR=${PARSECDIR}/x264
BUILD_DIR=${PARSECDIR}/x264/build/${PLATFORM}

# Set lower optimization level to avoid segmentation faults during runtime
export CFLAGS=" -O0 -g -funroll-loops -fprefetch-loop-arrays ${PORTABILITY_FLAGS}"
export CXXFLAGS="-O0 -g -funroll-loops -fprefetch-loop-arrays -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98"

rm -rf build/${PLATFORM}

mkdir -p ${PARSECDIR}/x264/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/x264/build/${PLATFORM}/obj

cd ${PARSECDIR}/x264/build/${PLATFORM}/obj
rm -f .depend

if [ "${PLATFORM}" = "rv64" ]; then
    ./configure --prefix=${BUILD_DIR} --enable-pthread --host=riscv64-unknown-linux-gnu
else
    ./configure --prefix=${BUILD_DIR} --enable-pthread
fi

make version=${VERSION} -j$(nproc)
make version=${VERSION} install

# Rename
mv ${BUILD_DIR}/bin/x264 ${BUILD_DIR}/bin/x264-${VERSION}