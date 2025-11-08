#!/bin/bash
rm -rf build/${PLATFORM}

export CXXFLAGS="${CXXFLAGS} -fexceptions"
export PHYSBAM="${PARSECDIR}/facesim/build/${PLATFORM}/obj"

mkdir -p ${PARSECDIR}/facesim/build/${PLATFORM}/obj
cp -r src/* ${PARSECDIR}/facesim/build/${PLATFORM}/obj

make -C ${PARSECDIR}/facesim/build/${PLATFORM}/obj version=${VERSION}
make -C ${PARSECDIR}/facesim/build/${PLATFORM}/obj install version=${VERSION}