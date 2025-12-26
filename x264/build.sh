BENCH_DIR=${PARSECDIR}/x264
BUILD_DIR=${PARSECDIR}/x264/build/${PLATFORM}

# Set lower optimization level to avoid segmentation faults during runtime
export CFLAGS="${CFLAGS} -O0"
export CXXFLAGS="${CXXFLAGS} -O0"

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