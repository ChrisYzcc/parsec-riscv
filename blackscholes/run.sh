RUN_DIR="$(pwd)/build/${PLATFORM}/run"

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p ${RUN_DIR}
else
    rm -rf ${RUN_DIR}/*
fi

mkdir -p ${RUN_DIR}/outputs

# Unzip input file
echo "Unzipping input file..."
tar -xvf inputs/input_${INPUT}.tar -C ${RUN_DIR}
echo "Unzipping completed."
echo

# Specify Input
case $INPUT in
    "test") ARGS="${RUN_DIR}/in_4.txt ${RUN_DIR}/outputs/out.txt" ;;
    "simdev") ARGS="${RUN_DIR}/in_1K.txt ${RUN_DIR}/outputs/out.txt" ;;
    "simsmall") ARGS="${RUN_DIR}/in_4K.txt ${RUN_DIR}/outputs/out.txt" ;;
    "simmedium") ARGS="${RUN_DIR}/in_16K.txt ${RUN_DIR}/outputs/out.txt" ;;
    "simlarge") ARGS="${RUN_DIR}/in_64K.txt ${RUN_DIR}/outputs/out.txt" ;;
    *) echo "Invalid input size specified!"; exit 1 ;;
esac

$(pwd)/build/${PLATFORM}/${USAGE}/bin/blackscholes-${VERSION} ${THREADS} $ARGS