rm -rf build/${PLATFORM}

make -C src clean
make -C src all version=${VERSION}
make -C src install