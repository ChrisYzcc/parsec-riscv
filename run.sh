#!/bin/sh
PLATFORM=native
PROGRAM=blackscholes
VERSION=pthreads
INPUT=test
THREADS=1
USAGE="normal"

while getopts "p:rv:hi:n:u:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        v) VERSION=$OPTARG ;;
        i) INPUT=$OPTARG ;;
        n) THREADS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-u usage] [-v version] [-i input] [-n threads] [-h]"
           echo "  -p program   : specify the program to run, default: blackscholes"
           echo "  -r           : set platform to rv64"
           echo "  -u usage     : set usage: normal, profiling, checkpoint. default: normal \\n \
                    normal: normal execution; \\n \
                    profiling: for profiling; \\n \
                    checkpoint: for checkpointing."
           echo "  -v version   : specify the version (pthreads, openmp), default: pthreads"
           echo "  -i input     : specify the input file, default: test"
           echo "  -n threads   : specify the number of threads, default: 1"
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

# check version
if [ "$VERSION" != "pthreads" ] && [ "$VERSION" != "openmp" ]; then
    echo "Invalid version specified! Supported versions are: pthreads, openmp."
    exit 1
fi

export PLATFORM
export VERSION
export INPUT
export THREADS
export PROGRAM
export USAGE

echo "============================================================================"
echo "  Running Target  : ${PROGRAM}"
echo "  Threads         : ${THREADS}"
echo "  Platform        : ${PLATFORM}"
echo "  Version         : ${VERSION}"
echo "  Input           : ${INPUT}"
echo "  Usage           : ${USAGE}"
echo "============================================================================"

cd ${PROGRAM}
./run.sh
cd ..

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"