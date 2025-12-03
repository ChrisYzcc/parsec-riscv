BENCH_DIR="$(pwd)"
RUN_DIR="$(pwd)/build/${PLATFORM}/run"

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

# Unzip input file
echo "Unzipping input file..."
tar -xvf inputs/input_${INPUT}.tar -C ${RUN_DIR}
echo "Unzipping completed."
echo

case $INPUT in
    "test") ARGS="im_benchmark barbados_256x288.v output.v";;
    "simdev") ARGS="im_benchmark barbados_256x288.v output.v";;
    "simsmall") ARGS="im_benchmark pomegranate_1600x1200.v output.v";;
    "simmedium") ARGS="im_benchmark vulture_2336x2336.v output.v";;
    "simlarge") ARGS="im_benchmark bigben_2662x5500.v output.v";;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

# Run vips
cd ${RUN_DIR}
export IM_CONCURRENCY=${THREADS}
${BENCH_DIR}/build/${PLATFORM}/bin/vips-${VERSION} ${ARGS}
cd ${BENCH_DIR}