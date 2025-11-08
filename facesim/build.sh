#!/bin/bash

rm -rf build/${PLATFORM}

make -C src version=${VERSION}
make -C src install version=${VERSION}