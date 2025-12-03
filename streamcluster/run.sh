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
    "simsmall") ARGS="10 20 32 4096 4096 1000 none";;
    "simmedium") ARGS="10 20 64 8192 8192 1000 none";;
    "simlarge") ARGS="10 20 128 16384 16384 1000 none";;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

# Run streamcluster
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/streamcluster-${VERSION} ${ARGS} output.txt ${THREADS}
cd ${BENCH_DIR}