# Setup TestRIG
- Run this script to automatically setup the repo, subrepos and install dependecies on NixOS:
  ```sh
  ./testrig_install.sh
  ```

# TestRIG
Framework for testing RISC-V processors with Random Instruction Generation.

- added xcelium with basic coverage for cva6
- build & compile cva6 with:
  ```sh
  ./riscv-implementations/cva6-cheri-dv/testrig/xlm/testrig_xlm_build.sh
  ```
- run with
  ```sh
  ./utils/scripts/runTestRIG.py -a sail -b cva6_cov -r rv64ixcheri --no-support-misaligned
  ```
- top level tb for CVA6 found at
  ```
  ./riscv-implementations/cva6-cheri-dv/testrig/tb/cva6_testrig_tb_top.sv
  ```
