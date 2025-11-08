#!/bin/bash

rm -rf build/${PLATFORM}

cd src
autoreconf -fiv

if [ "${PLATFORM}" == "riscv64" ]; then
    ./configure --prefix=${PARSECDIR}/bodytrack --enable-${VERSION} --host=riscv64-unknown-linux-gnu
else
    ./configure --prefix=${PARSECDIR}/bodytrack --enable-${VERSION}
fi
