if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of Swaptions is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/swaptions/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/swaptions/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/swaptions/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/swaptions/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/swaptions/build/${PLATFORM}/${USAGE}/bin/swaptions-${VERSION} ]; then
    exit 1
fi