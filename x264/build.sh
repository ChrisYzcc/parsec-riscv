BENCH_DIR=${PARSECDIR}/x264
BUILD_DIR=${PARSECDIR}/x264/build/${PLATFORM}/${USAGE}

# Set lower optimization level to avoid segmentation faults during runtime
export CFLAGS="${CFLAGS} -O0"
export CXXFLAGS="${CXXFLAGS} -O0"

mkdir -p ${PARSECDIR}/x264/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/x264/build/${PLATFORM}/${USAGE}/obj

cd ${PARSECDIR}/x264/build/${PLATFORM}/${USAGE}/obj
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

# check if the build was successful
if [ ! -f ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/x264-${VERSION} ]; then
    exit 1
fi