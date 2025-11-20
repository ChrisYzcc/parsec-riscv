BENCH_DIR="$(pwd)"

RUN_DIR="$(pwd)/build/${PLATFORM}/run"
if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

if [ "$INPUT" = "test" ]; then
    echo "Test input is not supported."
    exit 0
fi

# Unzip input file
echo "Unzipping input file..."
tar -xvf inputs/input_${INPUT}.tar -C ${RUN_DIR}
echo "Unzipping completed."
echo

# Run facesim
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/facesim-${VERSION} -timing -threads ${THREADS}
cd ${BENCH_DIR}