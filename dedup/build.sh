rm -rf build/${PLATFORM}

if [ "${VERSION}" = "openmp" ]; then
    echo "OpenMP version of dedup is not supported."
    exit 1
fi


mkdir -p ${PARSECDIR}/dedup/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/dedup/build/${PLATFORM}/obj

make -C ${PARSECDIR}/dedup/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/dedup/build/${PLATFORM}/obj install version=${VERSION}