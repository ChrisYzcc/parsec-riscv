if [ "${VERSION}" = "openmp" ]; then
    echo "\033[33m[warning] OpenMP version of facesim is not supported. Automatically switching to pthreads version.\033[0m"
    VERSION="pthreads"
fi

export CXXFLAGS="${CXXFLAGS} -fexceptions"
export PHYSBAM="${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/obj"

mkdir -p ${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/obj
cp -r src/* ${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/obj

make -C ${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/obj version=${VERSION}
make -C ${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/obj install version=${VERSION}

# check if the build was successful
if [ ! -f ${PARSECDIR}/facesim/build/${PLATFORM}/${USAGE}/bin/facesim-${VERSION} ]; then
    exit 1
fi