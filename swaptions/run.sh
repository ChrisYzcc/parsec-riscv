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
    "simsmall") ARGS="-ns 16 -sm 10000" ;;
    "simmedium") ARGS="-ns 32 -sm 20000" ;;
    "simlarge") ARGS="-ns 64 -sm 40000" ;;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

# Run swaptions
${BENCH_DIR}/build/${PLATFORM}/bin/swaptions-${VERSION} ${ARGS} -nt ${THREADS}