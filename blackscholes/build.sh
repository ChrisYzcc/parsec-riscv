rm -rf build

make -C src clean
make -C src all version=${VERSION}
make -C src install