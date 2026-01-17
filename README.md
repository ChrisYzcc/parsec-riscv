# PARSEC Benchmark RISC-V Edition

## Command
**Get Inputs**

To install simulation scale inputs (simsmall/simmedium/simlarge):
```bash
./intall_inputs.sh
```
**Build Command**
```
Usage: ./build.sh [-p program] [-r] [-h] [-u usage]
  -p program   : specify the program to build. Default: barnes
  -r           : set platform to rv64
  -v           : set version: pthreads, openmp. Default: pthreads
  -u           : set usage: normal, profiling, checkpoint. Default: normal
  -h           : display this help message
```

**Run Command**
```
Usage: ./run.sh [-p program] [-r] [-u usage] [-v version] [-i input] [-n threads] [-h]
  -p program   : specify the program to run, default: blackscholes
  -r           : set platform to rv64
  -u usage     : set usage: normal, profiling, checkpoint. default: normal 
                     normal: normal execution; 
                     profiling: for profiling; 
                     checkpoint: for checkpointing.
  -v version   : specify the version (pthreads, openmp), default: pthreads
  -i input     : specify the input file, default: test
  -n threads   : specify the number of threads, default: 1
  -h           : display this help message
```
**RISC-V Package**

`gen_rv_pack.sh` will pack all the RISC-V bins and datas with running scripts into `parsec_rv_pack`. You can simply copy that package to the target RISC-V machine.
```
Usage: ./gen_rv_pack.sh [-i inputs] [-u usage] [-h]
  -i inputs    : specify the inputs to package. Default: test
  -u usage     : set usage: normal, profiling, checkpoint. Default: normal
  -h           : display this help message
```

## Required Libraries
| Test Name     | Extra Lib Requirements          |
| ----          | :----:                          |
| ferret        | gsl, libjpeg                    |
| raytrace      | mesa                            |
| vips          | glib, zlib, libxml2, ffi, pcre2 |
| dedup         | openssl, zlib                   |

To install extra required libraries, run `./install_rv_libs.sh` which will install libs to `parsec_rv_libs` in the PARSEC directory. Currently, libraries required by `raytrace` are not supported.

You can also use your RISC-V version libraries. Remember to change `${RV_LIB_PREFIX}` in `build.sh`.

## Tests Summary
Native Platform: x86_64, Debian on WSL2

RISC-V Platfrom: QEMU, Kunminghu Config

| Test Name     | Native Compilation    | RISC-V Compilation    | Native Run    | RISC-V Run    |
| ----          | :----:                | :----:                | :----:        | :----:        |
| blackscholes  | *                     | *                     | *             | *             |
| bodytrack     | *                     | *                     | *             | *             |
| canneal       | *                     | *                     | *             | *             |
| dedup         | *                     | *                     | *             | *             |
| facesim       | *                     | *                     | *             | *             |
| ferret        | *                     | *                     | *             | *             |
| fluidanimate  | *                     | *                     | *             | *             |
| freqmine      | *                     | *                     | *             | *             |
| raytrace      | *                     | x                     | ?             | x             |
| streamcluster | *                     | *                     | *             | *             |
| swaptions     | *                     | *                     | *             | *             |
| vips          | *                     | *                     | *             | *             |
| x264          | *                     | *                     | *             | *             |

* `raytrace`: Need mesa(openGL etc.) RISC-V support. In progress. To run `raytrace` on native environment, you need to remove `-static` option in `build.sh`. Not stable in native environment (sometimes cannot exit).

## Future Work
- [x] `ferret` assertion fail.
- [x] Static compilation for `vips`.
- [x] Packed extra libraries.
- [x] `sim` size inputs.
- [ ] Solution for `raytrace`.
