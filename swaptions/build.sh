rm -rf build/${PLATFORM}

if [ "${VERSION}" == "openmp" ]; then
    echo "OpenMP version of Swaptions is not supported."
    exit 1
fi


mkdir -p ${PARSECDIR}/swaptions/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/swaptions/build/${PLATFORM}/obj

make -C ${PARSECDIR}/swaptions/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/swaptions/build/${PLATFORM}/obj install version=${VERSION}