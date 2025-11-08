#!/bin/bash

BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

case $INPUT in
    "test") ARGS="-ns 1 -sm 5" ;;
    "simdev") ARGS="-ns 3 -sm 50" ;;
esac

# Run swaptions
${BENCH_DIR}/build/${PLATFORM}/bin/swaptions-${VERSION} ${ARGS} -nt ${THREADS}