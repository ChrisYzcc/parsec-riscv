if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of fluidanimate is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

mkdir -p ${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}/bin/fluidanimate-${VERSION} ]; then
    exit 1
fi