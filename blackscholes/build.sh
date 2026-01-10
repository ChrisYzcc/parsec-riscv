BENCH_DIR=${PARSECDIR}/blackscholes

make -C src clean
make -C src all version=${VERSION}
make -C src install

# check if the build was successful
if [ ! -f ${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/blackscholes-${VERSION} ]; then
    exit 1
fi