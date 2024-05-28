# RISCV on FPGA
Goal of this project is to implement a riscv soft-core and explore various other architectures .

## Requirements

- Board used: **Arty Z7-20**
- Vitis design Suite with Vivado

## Building

We are using vivado's non-project workflow for this project

- Open powershell in the project directory
- Make sure you have path to vivado execuatble in your environmental variables
- Inorder to run vivada in tcl mode run the following command: `vivado -mode tcl`
- Again make sure you are in project directory 
- execute the build script: `source Scripts/build.tcl`