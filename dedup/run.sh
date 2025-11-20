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

case $INPUT in
    "test") ARGS="-c -p -v -i test.dat -o output.dat.ddp";;
    "simdev") ARGS="-c -p -v -i hamlet.dat -o output.dat.ddp";;
esac

# Run dedup
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/dedup-${VERSION} ${ARGS} -t ${THREADS} 
cd ${BENCH_DIR}