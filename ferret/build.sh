rm -rf build/${PLATFORM}

if [ "${VERSION}" == "openmp" ]; then
    echo "OpenMP version of ferret is not supported."
    exit 1
fi

mkdir -p ${PARSECDIR}/ferret/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/ferret/build/${PLATFORM}/obj

make -C ${PARSECDIR}/ferret/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/ferret/build/${PLATFORM}/obj install version=${VERSION}