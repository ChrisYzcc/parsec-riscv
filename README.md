# PARSEC Benchmark RISC-V Edition

## Command
**Build Command**
```
Usage: ./build.sh [-p program] [-r] [-v version] [-h]
  -p program  : specify the program to build, default: blackscholes
  -r          : set platform to rv64
  -v version  : specify the version (pthreads, openmp), default: pthreads
  -h          : display this help message
```
**Run Command**
```
Usage: ./run.sh [-p program] [-r] [-v version] [-h]
  -p program  : specify the program to run, default: blackscholes
  -r          : set platform to rv64 (USE ON RISC-V MACHINES!)
  -v version  : specify the version (pthreads, openmp, tbb), default: pthreads
  -i input    : specify the input file, default: test
  -n threads  : specify the number of threads, default: 1
  -h          : display this help message
```
**RISC-V Package**

``gen_rv_pack.sh`` will pack all the RISC-V bins and datas with running scripts. You can simply copy that package to the target RISC-V machine.
```
Usage: ./gen_rv_pack.sh
```

## Dependent Libraries
| Test Name     | Extra Lib Requirements    |
| ----          | :----:                    |
| ferret        | gsl, libjpeg              |
| raytrace      | mesa                      |
| vips          | glib, zlib, libxml2       |
| dedup         | openssl, zlib             |

Pay attention to the variable `${RV_LIB_PREFIX}` in `build.sh`. Currently, you need to compile all these libraries for RISC-V version PARSEC.

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
| ferret        | *                     | *                     | ?             | ?             |
| fluidanimate  | *                     | *                     | *             | *             |
| freqmine      | *                     | *                     | *             | *             |
| raytrace      | *                     | x                     | *             | x             |
| streamcluster | *                     | *                     | *             | *             |
| swaptions     | *                     | *                     | *             | *             |
| vips          | *                     | *                     | *             | x             |
| x264          | *                     | *                     | *             | *             |

* `ferret`: Occasionally assertion fail.
* `raytrace`: Need mesa(openGL etc.) RISC-V support. In progress.
* `vips`: Static compilation error for RISC-V. In progress.

## Future Work
- [ ] `ferret` assertion fail.
- [ ] Solution for `raytrace`.
- [ ] Static compilation for `vips`.
- [ ] Packed extra libraries.
