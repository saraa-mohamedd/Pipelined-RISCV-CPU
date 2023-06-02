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

module InstMem(input [31:0] addr, output [31:0] data_out);
    reg [7:0] mem [0:1020];  // Byte Addressable
    //reg [31:0] mem [0:63]; 
    assign data_out[31:0] = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; 
    //assign data_out = mem[addr];

    initial begin
        $readmemh("C:\\Users\\mohamed-sherif\\Desktop\\ARCH_P1\\MS2\\MS2.srcs\\sources_1\\new\\hex_split\\test_I-Arithmetic.hex", mem);
    end
    
//        initial begin 
//        {mem[3], mem[2], mem[1], mem[0]} = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//        {mem[7], mem[6], mem[5], mem[4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//        {mem[11], mem[10], mem[9], mem[8]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//        {mem[15], mem[14], mem[13], mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//        {mem[19], mem[18], mem[17], mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//        {mem[23], mem[22], mem[21], mem[20]}=32'b0000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 16 
//        {mem[27], mem[26], mem[25], mem[24]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//        {mem[31], mem[30], mem[29], mem[28]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
//        {mem[35], mem[34], mem[33], mem[32]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//        {mem[39], mem[38], mem[37], mem[36]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
//        {mem[43], mem[42], mem[41], mem[40]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
//        {mem[47], mem[46], mem[45], mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
//        {mem[51], mem[50], mem[49], mem[48]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
//        {mem[55], mem[54], mem[53], mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, addr 
//    end

endmodule