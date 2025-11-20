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
    "test") ARGS="octahedron.obj -automove -nthreads ${THREADS} -frames 1 -res 1 1";;
    "simdev") ARGS="bunny.obj -automove -nthreads ${THREADS} -frames 1 -res 16 16";;
esac

# Run raytrace
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/rtview-${VERSION} ${ARGS}
cd ${BENCH_DIR}