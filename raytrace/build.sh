BENCH_DIR=${PARSECDIR}/raytrace
BUILD_DIR=${BENCH_DIR}/build/${PLATFORM}/${USAGE}

export CXXFLAGS="${CXXFLAGS} -fexceptions -fno-strict-aliasing -fno-align-labels -DNDEBUG -D_MM_NO_ALIGN_CHECK"

# Compile in tmp dir
mkdir -p ${BUILD_DIR}/obj
cp -r ${BENCH_DIR}/src/* ${BUILD_DIR}/obj
cd ${BUILD_DIR}/obj

VERSION_SUFFIX="threads"
cmake -G "Unix Makefiles"\
        -D CMAKE_PREFIX_PATH=${GNUTOOL_HOME} \
        -D CMAKE_INSTALL_PREFIX=${BUILD_DIR} \
        -D CMAKE_CXX_COMPILER=${CXX} \
        -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -D USE_PBOS=1 \
        -D NEED_ARB_WRAPPERS=0 \
        -Wno-dev \
        .

rm -rf ${BUILD_DIR}/bin/*
make -j$(nproc)
make install

# Rename the executable to include platform and version info
for f in "${BUILD_DIR}/bin/"*; do
    mv "$f" "${f}-${VERSION}"
done

# check if the build was successful
if [ ! -f ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/raytrace-${VERSION} ]; then
    exit 1
fi