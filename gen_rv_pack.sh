PARSECDIR=$(pwd)

ALL="blackscholes bodytrack canneal dedup facesim ferret fluidanimate freqmine streamcluster swaptions x264 vips"

INPUTS="test"
USAGE="normal"

while getopts "i:u:h" opt; do
    case "$opt" in
        i) INPUTS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) echo "Usage: $0 [-i inputs] [-u usage] [-h]"
           echo "  -i inputs    : specify the inputs to package. Default: test"
           echo "  -u usage     : set usage: normal, profiling, checkpoint. Default: normal"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

if [ ! -d "${PARSECDIR}/parsec_rv_pack" ]; then
    mkdir -p ${PARSECDIR}/parsec_rv_pack
else
    rm -rf ${PARSECDIR}/parsec_rv_pack/*
fi

if [ "$USAGE" != "normal" ] && [ "$USAGE" != "profiling" ] && [ "$USAGE" != "checkpoint" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

INPUT_LIST=""
if [ "$INPUTS" = "test" ]; then
    INPUT_LIST="test"
else
    echo "\033[31m[ERROR] Unknown inputs: $INPUTS\033[0m"
    exit 1
fi

echo "==========================================================="
echo "  Input sets to package   : $INPUT_LIST"
echo "  Usage mode              : $USAGE"
echo "==========================================================="

for PROGRAM in $ALL; do
    mkdir -p ${PARSECDIR}/parsec_rv_pack/${PROGRAM}

    # Copy binaries
    mkdir -p ${PARSECDIR}/parsec_rv_pack/${PROGRAM}/build/rv64/${USAGE}
    cp -r ${PARSECDIR}/${PROGRAM}/build/rv64/${USAGE}/bin ${PARSECDIR}/parsec_rv_pack/${PROGRAM}/build/rv64/${USAGE}/bin
    # Copy inputs and run script
    if [ -d "${PARSECDIR}/${PROGRAM}/inputs" ]; then
        mkdir -p ${PARSECDIR}/parsec_rv_pack/${PROGRAM}/inputs
        for INPUT in $INPUT_LIST; do
            INPUT_TAR="input_${INPUT}.tar"
            if [ -f "${PARSECDIR}/${PROGRAM}/inputs/${INPUT_TAR}" ]; then
                cp ${PARSECDIR}/${PROGRAM}/inputs/${INPUT_TAR} ${PARSECDIR}/parsec_rv_pack/${PROGRAM}/inputs/${INPUT_TAR}
            else
                echo "\033[33m[WARNING] Input ${INPUT_TAR} does not exist for program ${PROGRAM}\033[0m"
            fi
        done
    fi

    cp -r ${PARSECDIR}/${PROGRAM}/run.sh ${PARSECDIR}/parsec_rv_pack/${PROGRAM}/
done

echo "  Generating package completed."
echo "==========================================================="

cp -r ${PARSECDIR}/run.sh ${PARSECDIR}/parsec_rv_pack/
sed -i 's|^\./run\.sh$|/bin/sh ./run.sh|' ${PARSECDIR}/parsec_rv_pack/run.sh