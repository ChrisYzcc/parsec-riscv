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
    "test") ARGS="--quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 -o eledream.264 eledream_32x18_1.y4m" ;;
    "simdev") ARGS="--quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 -o eledream.264 eledream_64x36_3.y4m";;
    "simsmall") ARGS="--quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 -o eledream.264 eledream_640x360_8.y4m";;
    "simmedium") ARGS="--quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 -o eledream.264 eledream_640x360_32.y4m";;
    "simlarge") ARGS="--quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 -o eledream.264 eledream_640x360_128.y4m";;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

# Run
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/x264-${VERSION} ${ARGS} --threads ${THREADS}
cd ${BENCH_DIR}