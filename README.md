# Pipelined-RISCV-CPU
A verilog implementation of a pipelined processor for the RISC-V architecture, with support for all 40 instructions of the RV32I instruction set, as well as an additional 8 for the RV32M instruction set. 
This project also supports implementation on a Nexys A7 board, with push buttons for incrementing the program counter, as well as seven-segment displays and LEDs for program counter value and significant wires.\

#### Inputs
Inputs to the processor can be entered through a file with the proper format. Since the RISCV architecture supports a byte addressable, little endian memory, input from file should be in hex, split up into bytes in little endian format. Refer to the *Report* pdf of this repository for examples and more details.

#### Outputs
Output calues can be viewed using an IDE for Verilog HDL (such as Vivado by XILINX) either through a simulation (see ```CPU_tb.v``` for the testbench) or through generating the bitstream and coding it onto a Nexys A7 board.

## Testing
For testing, refer to the ***Testing*** section in the *Report* pdf of this repository.
