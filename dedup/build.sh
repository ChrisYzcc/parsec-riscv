if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of dedup is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/dedup/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/dedup/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/dedup/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/dedup/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/dedup/build/${PLATFORM}/${USAGE}/bin/dedup-${VERSION} ]; then
    exit 1
fi