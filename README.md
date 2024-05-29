# RISC-V on FPGA
Goal of this project is to implement a risc-v soft-core and explore various architectures.

## Requirements

- Board used: **Arty Z7-20**
- Vitis design Suite with Vivado

## Building

We are using Vivado's non-project workflow

- Open powershell in the project directory
- Make sure you have path to Vivado executable in your environmental variables
- In order to run Vivado in tcl mode run the following command: `vivado -mode tcl`
- Again make sure you are in project directory 
- execute the build script from tcl shell: `source Scripts/build.tcl`