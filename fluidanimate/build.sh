rm -rf build/${PLATFORM}

mkdir -p ${PARSECDIR}/facesim/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/facesim/build/${PLATFORM}/obj

make -C ${PARSECDIR}/facesim/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/facesim/build/${PLATFORM}/obj install version=${VERSION}