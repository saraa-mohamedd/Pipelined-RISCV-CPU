`timescale 1ns / 1ps

/*******************************************************************
*
* Module: DataMem.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that models data memory of the RISCV architecture
*
* Change history: 09/04/2023 - adapted from lab tasks
*                 10/04/2023 - added read from file functionality    
*                 11/04/2023 - chaged memory from word addressable to byte addressable              
*
*
**********************************************************************/


module DataMem(input clk, input MemRead, input MemWrite, 
 input [7:0] addr, input [31:0] data_in, input [2:0] funct3, output reg [31:0] data_out); 
 
 //reg [31:0] mem [0:63]; Word Addressable
 reg[7:0] mem[0:255];
 
 always@(*) begin
 if (MemRead == 1) begin
    case (funct3)
//        3'b000: data_out = {{24{mem[addr][7]}}, mem[addr][7:0]}; // LB
//        3'b001: data_out = {{16{mem[addr][15]}}, mem[addr][15:0]}; // LH
//        3'b010: data_out = mem[addr]; // LW
//        3'b100: data_out = {{24{1'b0}}, mem[addr][7:0]}; // LBU
//        3'b101: data_out = {{16{1'b0}}, mem[addr][15:0]}; // LHU 

        3'b000: data_out = {{24{mem[addr][7]}}, mem[addr]}; // LB
        3'b001: data_out = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]}; // LH
        3'b010: data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; // LW
        3'b100: data_out = {{24{1'b0}}, mem[addr]}; // LBU
        3'b101: data_out = {{16{1'b0}}, mem[addr+1], mem[addr]}; // LHU
        default: data_out = 32'hZZZZZZZZ;
    endcase
 end   
 else
    data_out = 32'hZZZZZZZZ;
 end
 
 always@(posedge clk) begin
 if (MemWrite == 1)
    begin
        case (funct3)
//            3'b000: mem[addr] = {24'd0, data_in[7:0]}; // SB
//            3'b001: mem[addr] = {16'd0, data_in[15:0]}; // SH
//            3'b010: mem[addr] = data_in; // SW

            3'b000: mem[addr] = {data_in[7:0]}; // SB
            3'b001: {mem[addr+1], mem[addr]} = {data_in[15:0]}; // SH
            3'b010: {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = data_in; // SW
            default: mem[addr] = mem[addr];
        endcase
    end 
 else
    mem[addr] = mem[addr];  
 end
 
 initial begin 
     {mem[3], mem[2], mem[1], mem[0]} = 32'd17; 
     {mem[7], mem[6], mem[5], mem[4]} = 32'd9; 
     {mem[11], mem[10], mem[9], mem[8]} = 32'd25;
     {mem[15], mem[14], mem[13], mem[12]} = 32'hFFFFAAAA;
     {mem[19], mem[18], mem[17], mem[16]} = 32'hFFFFABCD;
 end
endmodule 