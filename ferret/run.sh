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
    "test") ARGS="corel lsh queries 5 5";;
    "simdev") ARGS="corel lsh queries 50 5";;
esac

# Run ferret
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/ferret-${VERSION} ${ARGS} ${THREADS} output.txt
cd ${BENCH_DIR}