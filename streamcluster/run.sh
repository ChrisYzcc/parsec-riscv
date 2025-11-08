#!/bin/bash

if [ -z "$NDIVS" ]; then
    NDIVS=${THREADS}
fi


BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

case $INPUT in
    "test") ARGS="2 5 1 10 10 5 none";;
    "simdev") ARGS="3 10 3 16 16 10 none";;
esac

# Run streamcluster
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/streamcluster-${VERSION} ${ARGS} output.txt ${THREADS}
cd ${BENCH_DIR}