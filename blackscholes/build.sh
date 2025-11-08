rm -rf build

make -C src clean
make -C src all
make -C src install