#!/bin/bash

BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

# Unzip input file
echo "Unzipping input file..."
tar -xvf ${BENCH_DIR}/inputs/input_${INPUT}.tar -C ${RUN_DIR}
echo "Unzipping completed."
echo

case $INPUT in
    "test") ARGS="5 100 10.nets 1";;
    "simdev") ARGS="100 300 100.nets 2";;
esac

# Run canneal
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/canneal-${VERSION} ${THREADS} ${ARGS}
cd ${BENCH_DIR}