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
    "test") ARGS="1 ${RUN_DIR}/in_5K.fluid" ;;
    "simdev") ARGS="3 ${RUN_DIR}/in_15K.fluid" ;;
    "simsmall") ARGS="5 ${RUN_DIR}/in_35K.fluid" ;;
    "simmedium") ARGS="5 ${RUN_DIR}/in_100K.fluid" ;;
    "simlarge") ARGS="5 ${RUN_DIR}/in_300K.fluid" ;;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

# Run fuildanimate
$(pwd)/build/${PLATFORM}/${USAGE}/bin/fluidanimate-${VERSION} ${THREADS} ${ARGS} 
