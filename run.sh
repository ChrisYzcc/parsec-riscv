#!/bin/bash

PLATFORM=native
PROGRAM=blackscholes
VERSION=pthreads
INPUT=test
THREADS=1

while getopts "p:rv:hi:n:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        v) VERSION=$OPTARG ;;
        i) INPUT=$OPTARG ;;
        n) THREADS=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-h]"
           echo "  -p program : specify the program to run, default: blackscholes"
           echo "  -r          : set platform to rv64"
           echo "  -v version  : specify the version (pthreads, openmp, tbb), default: pthreads"
           echo "  -i input    : specify the input file, default: test"
           echo "  -n threads   : specify the number of threads, default: 1"
           echo "  -h          : display this help message"
           exit 0 ;;
    esac
done

export PLATFORM
export VERSION
export INPUT
export THREADS
export PROGRAM

echo "============================================================================"
echo "  Running Target : ${PROGRAM}"
echo "  Version        : ${VERSION}"
echo "  Input          : ${INPUT}"
echo "============================================================================"

cd ${PROGRAM}
./run.sh
cd ..

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"