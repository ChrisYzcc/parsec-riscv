PARSECDIR=$(pwd)

ALL="blackscholes bodytrack canneal dedup facesim ferret fluidanimate freqmine streamcluster swaptions x264"

if [ ! -d "${PARSECDIR}/rv_pack" ]; then
    mkdir -p ${PARSECDIR}/rv_pack
else
    rm -rf ${PARSECDIR}/rv_pack/*
fi

for PROGRAM in $ALL; do
    mkdir -p ${PARSECDIR}/rv_pack/${PROGRAM}

    mkdir -p ${PARSECDIR}/rv_pack/${PROGRAM}/build/rv64
    cp -r ${PARSECDIR}/${PROGRAM}/build/rv64/bin ${PARSECDIR}/rv_pack/${PROGRAM}/build/rv64/bin
    if [ -d "${PARSECDIR}/${PROGRAM}/inputs" ]; then
        cp -r ${PARSECDIR}/${PROGRAM}/inputs ${PARSECDIR}/rv_pack/${PROGRAM}/inputs
    fi
    cp -r ${PARSECDIR}/${PROGRAM}/run.sh ${PARSECDIR}/rv_pack/${PROGRAM}/
done

cp -r ${PARSECDIR}/run.sh ${PARSECDIR}/rv_pack/