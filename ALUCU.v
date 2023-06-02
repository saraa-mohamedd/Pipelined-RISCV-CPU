`timescale 1ns / 1ps
`include "defines.v"

/*******************************************************************
*
* Module: ALUCU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: ALU control unit that takes ALUOp and parts of instruction to produce control lines for ALU 
*
* Change history: 09/04/2023 - adapted from lab tasks 
*                 09/04/2023 - used defines.v file to add uniformity to code 
*                 10/04/2023 - added cases for immediate operations
*                 11/04/2023 - added cases for remaining instructions
* 
*
**********************************************************************/

module ALUCU(
      input [2:0] ALUOp,
      input[14:12]Inst,
      input Inst30,
      output reg [3:0]ALUSelection
    );
    
always@(*) begin
casex({ALUOp, Inst, Inst30})
    7'b100xxxx:
        ALUSelection = `ALU_PASS; // LUI
    7'b000xxxx: 
        ALUSelection = `ALU_ADD; // lw & sw offset add/*
    7'b101xxxx:
        ALUSelection = `ALU_ADD; // JALR
    {3'b011, `F3_ADD, 1'bx}:
        ALUSelection = `ALU_ADD; // I-format addi
    {3'b011, `F3_AND, 1'bx}: 
        ALUSelection = `ALU_AND; // I-format ANDI
    {3'b011, `F3_OR, 1'bx}: 
        ALUSelection = `ALU_OR; // I-format ORI
    {3'b011, `F3_XOR, 1'bx}: 
        ALUSelection = `ALU_XOR; // I-format XORI
    {3'b011, `F3_SLL, 1'b0}:
        ALUSelection = `ALU_SLL; // I-format SLLI
    {3'b011, `F3_SLT, 1'bx}: 
        ALUSelection = `ALU_SLT; // I-format SLTI
    {3'b011, `F3_SLTU, 1'bx}:
        ALUSelection = `ALU_SLTU; // I-format SLTIU
    {3'b011, `F3_SRL, 1'b0}:
        ALUSelection = `ALU_SRL; // I-format SRLI
    {3'b011, `F3_SRL, 1'b1}:
        ALUSelection = `ALU_SRA; // I-format SRAI
    7'b001xxxx: 
        ALUSelection = `ALU_SUB; // branch sub
    7'b0100000: 
        ALUSelection = `ALU_ADD; // R-format add
    7'b0100001: 
        ALUSelection = `ALU_SUB; // R-format sub
    {3'b010, `F3_AND, 1'b0}: 
        ALUSelection = `ALU_AND; // R-format AND
    {3'b010, `F3_OR, 1'b0}: 
        ALUSelection = `ALU_OR; // R-format OR
    {3'b010, `F3_XOR, 1'b0}: 
        ALUSelection = `ALU_XOR; // R-format XOR
    {3'b010, `F3_SLL, 1'b0}:
        ALUSelection = `ALU_SLL; // R-format SLL
    {3'b010, `F3_SLT, 1'b0}: 
        ALUSelection = `ALU_SLT; // R-format SLT
    {3'b010, `F3_SLTU, 1'b0}:
        ALUSelection = `ALU_SLTU; // R-format SLTU
    {3'b010, `F3_SRL, 1'b0}:
        ALUSelection = `ALU_SRL; // R-format SRL
    {3'b010, `F3_SRL, 1'b1}:
        ALUSelection = `ALU_SRA; // R-format SRA
    default: 
        ALUSelection = `ALU_PASS; // default pass b
endcase
end
endmodule