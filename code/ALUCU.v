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
*                 26/04/2023 - edited module to add support for RISCV-32M instructions
*
**********************************************************************/

module ALUCU(
      input [2:0] ALUOp,
      input [14:12] Inst,
      input Inst30,
      input Inst25,
      output reg [4:0]ALUSelection
    );
    
always@(*) begin
casex({ALUOp, Inst, Inst30, Inst25})
    8'b100xxxxx:
        ALUSelection = `ALU_PASS; // LUI
    8'b000xxxxx: 
        ALUSelection = `ALU_ADD; // lw & sw offset add/*
    8'b101xxxxx:
        ALUSelection = `ALU_ADD; // JALR
    {3'b011, `F3_ADD, 2'bxx}:
        ALUSelection = `ALU_ADD; // I-format addi
    {3'b011, `F3_AND, 2'bxx}: 
        ALUSelection = `ALU_AND; // I-format ANDI
    {3'b011, `F3_OR, 2'bxx}: 
        ALUSelection = `ALU_OR; // I-format ORI
    {3'b011, `F3_XOR, 2'bxx}: 
        ALUSelection = `ALU_XOR; // I-format XORI
    {3'b011, `F3_SLL, 2'b0x}:
        ALUSelection = `ALU_SLL; // I-format SLLI
    {3'b011, `F3_SLT, 2'bxx}: 
        ALUSelection = `ALU_SLT; // I-format SLTI
    {3'b011, `F3_SLTU, 2'bxx}:
        ALUSelection = `ALU_SLTU; // I-format SLTIU
    {3'b011, `F3_SRL, 2'b0x}:
        ALUSelection = `ALU_SRL; // I-format SRLI
    {3'b011, `F3_SRL, 2'b1x}:
        ALUSelection = `ALU_SRA; // I-format SRAI
    8'b001xxxxx: 
        ALUSelection = `ALU_SUB; // branch sub
    8'b01000000: 
        ALUSelection = `ALU_ADD; // R-format add
    8'b01000010: 
        ALUSelection = `ALU_SUB; // R-format sub
    {3'b010, `F3_AND, 2'b00}: 
        ALUSelection = `ALU_AND; // R-format AND
    {3'b010, `F3_OR, 2'b00}: 
        ALUSelection = `ALU_OR; // R-format OR
    {3'b010, `F3_XOR, 2'b00}: 
        ALUSelection = `ALU_XOR; // R-format XOR
    {3'b010, `F3_SLL, 2'b00}:
        ALUSelection = `ALU_SLL; // R-format SLL
    {3'b010, `F3_SLT, 2'b00}: 
        ALUSelection = `ALU_SLT; // R-format SLT
    {3'b010, `F3_SLTU, 2'b00}:
        ALUSelection = `ALU_SLTU; // R-format SLTU
    {3'b010, `F3_SRL, 2'b00}:
        ALUSelection = `ALU_SRL; // R-format SRL
    {3'b010, `F3_SRL, 2'b10}:
        ALUSelection = `ALU_SRA; // R-format SRA
    {3'b010, `F3_MUL, 2'b01}:
        ALUSelection = `ALU_MUL; // R-format MUL
    {3'b010, `F3_MULH, 2'b01}:
        ALUSelection = `ALU_MULH; // R-format MULH
    {3'b010, `F3_MULSU, 2'b01}:
        ALUSelection = `ALU_MULSU; // R-format MULSU
    {3'b010, `F3_MULU, 2'b01}:
        ALUSelection = `ALU_MULU; // R-format MULU
    {3'b010, `F3_DIV, 2'b01}:
        ALUSelection = `ALU_DIV; // R-format DIV
    {3'b010, `F3_DIVU, 2'b01}:
        ALUSelection = `ALU_DIVU; // R-format DIVU
    {3'b010, `F3_REM, 2'b01}:
        ALUSelection = `ALU_REM; // R-format REM
    {3'b010, `F3_REMU, 2'b01}:
        ALUSelection = `ALU_REMU; // R-format REMU
    default: 
        ALUSelection = `ALU_PASS; // default pass b
endcase
end
endmodule