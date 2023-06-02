`timescale 1ns / 1ps

/*******************************************************************
*
* Module: InstMem.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that models the instruction memory in RISCV, takes in address of instruction 
* to be fetched, and retrieves it from memory array, which is initialized from the .hex file given to it
*
* Change history: 09/04/2023 - adapted from lab tasks
*                 10/04/2023 - added read from file functionality    
*                 11/04/2023 - chaged memory from word addressable to byte addressable              
*
*
**********************************************************************/

module InstMem(input [7:0] addr, output [31:0] data_out);
    reg [7:0] mem [0:255];  // Byte Addressable
    //reg [31:0] mem [0:63]; 
    assign data_out[31:0] = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; 
    //assign data_out = mem[addr];

    initial begin
        $readmemh("C:\\Users\\mohamed-sherif\\Desktop\\ARCH_P1\\Project1\\Project1.srcs\\sources_1\\new\\hex_split\\test_fencebreakcall.hex", mem);
    end
endmodule