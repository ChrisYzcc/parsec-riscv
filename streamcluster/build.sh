rm -rf build/${PLATFORM}

if [ "${VERSION}" == "openmp" ]; then
    echo "OpenMP version of Streamcluster is not supported."
    exit 1
fi


mkdir -p ${PARSECDIR}/streamcluster/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/streamcluster/build/${PLATFORM}/obj

make -C ${PARSECDIR}/streamcluster/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/streamcluster/build/${PLATFORM}/obj install version=${VERSION}