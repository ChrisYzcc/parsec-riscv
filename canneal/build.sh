rm -rf build/${PLATFORM}

if [ "${VERSION}" = "openmp" ]; then
    echo "OpenMP version of Canneal is not supported."
    exit 1
fi


mkdir -p ${PARSECDIR}/canneal/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/canneal/build/${PLATFORM}/obj

make -C ${PARSECDIR}/canneal/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/canneal/build/${PLATFORM}/obj install version=${VERSION}