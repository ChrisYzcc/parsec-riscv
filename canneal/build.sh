if [ "${VERSION}" = "openmp" ]; then
    # display warning message for unsupported version in yellow color
    echo "\033[33m[warning] OpenMP version of Canneal is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/canneal/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/canneal/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/canneal/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/canneal/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/canneal/build/${PLATFORM}/${USAGE}/bin/canneal-${VERSION} ]; then
    exit 1
fi