if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of ferret is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/ferret/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/ferret/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/ferret/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/ferret/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/ferret/build/${PLATFORM}/${USAGE}/bin/ferret-${VERSION} ]; then
    exit 1
fi