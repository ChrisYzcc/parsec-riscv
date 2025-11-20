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
    "test") ARGS="${RUN_DIR}/T10I4D100K_3.dat 1" ;;
    "simdev") ARGS="${RUN_DIR}/T10I4D100K_1k.dat 3" ;;
esac

export OMP_NUM_THREADS=${THREADS}

# Run freqmine
${BENCH_DIR}/build/${PLATFORM}/bin/freqmine-${VERSION} ${ARGS}