if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of Streamcluster is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/streamcluster/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/streamcluster/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/streamcluster/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/streamcluster/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/streamcluster/build/${PLATFORM}/${USAGE}/bin/streamcluster-${VERSION} ]; then
    exit 1
fi