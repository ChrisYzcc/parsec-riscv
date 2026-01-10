if [ "${VERSION}" = "pthreads" ]; then
    echo "\033[33m[warning] pthread version of Freqmine is not supported. Auto-selecting OpenMP version.\033[0m"
    VERSION="openmp"
fi

export CXXFLAGS="${CXXFLAGS} -fopenmp -fno-openacc"

mkdir -p ${PARSECDIR}/freqmine/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/freqmine/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/freqmine/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/freqmine/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/freqmine/build/${PLATFORM}/${USAGE}/bin/freqmine-${VERSION} ]; then
    exit 1
fi