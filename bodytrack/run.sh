# !/bin/bash

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
esac

$(pwd)/build/${PLATFORM}/bin/bodytrack-${VERSION} ${THREADS} $ARGS

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"