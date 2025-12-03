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

# Specify Input
case $INPUT in
    "test") ARGS="${RUN_DIR}/sequenceB_1 4 1 100 3 0" ;;
    "simdev") ARGS="${RUN_DIR}/sequenceB_1 4 1 100 3 0" ;;
    "simsmall") ARGS="${RUN_DIR}/sequenceB_1 4 1 1000 5 0" ;;
    "simmedium") ARGS="${RUN_DIR}/sequenceB_2 4 2 2000 5 0" ;;
    "simlarge") ARGS="${RUN_DIR}/sequenceB_4 4 4 4000 5 0" ;;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

$(pwd)/build/${PLATFORM}/bin/bodytrack-${VERSION} $ARGS ${THREADS}