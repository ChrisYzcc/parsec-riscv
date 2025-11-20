rm -rf build/${PLATFORM}

if [ "${VERSION}" == "pthreads" ]; then
    echo "Pthread version of Freqmine is not supported."
    exit 1
fi

export CXXFLAGS="${CXXFLAGS} -fopenmp"

mkdir -p ${PARSECDIR}/freqmine/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/freqmine/build/${PLATFORM}/obj

make -C ${PARSECDIR}/freqmine/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/freqmine/build/${PLATFORM}/obj install version=${VERSION}