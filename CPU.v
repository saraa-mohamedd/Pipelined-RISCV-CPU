`timescale 1ns / 1ps
`include "defines.v"


/*******************************************************************
*
* Module: CPU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: top module of the complete single-cycle implementation of the RISCV-32 processor
*
* Change history: 09/04/2023 - adapted from lab tasks, edited literals using defines.v added branchCU to schematic
*                 10/04/2023 - edited size of inputs according to changes in sizes of signals
*                 11/04/2023 - added three multiplexers for FENCE, EBREAK, ECALL, AUIPC, LUI, JAL, and JALR instructions, 
*                              more wires, and adjusted inputs and outputs of modules
*
*
**********************************************************************/

module CPU(input clk, rst);
    wire [31:0] PCIn;
    wire [31:0] PCOut;
    wire [31:0] PC4_Out;
    wire [31:0] PCImm_Out;
    
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, PCLoad, Jump;
    wire [1:0] RegWriteSrc, PCSrc;
    wire [2:0] ALUOp;
    wire [3:0] ALUSelection;
    wire [31:0] IR;
    wire signed [31:0] Immediate;
    wire signed [31:0] ShiftedImmediate;
    
    wire signed [31:0] RFReadData1, RFReadData2, RFWriteData;
    wire signed [31:0] RFMuxALUOut;
    wire signed [31:0] ALUOut;
    wire zeroFlag, carryFlag, overflowFlag, signFlag;
    wire signed [31:0] DataMemoryOut;
    wire BranchResult;
    
    wire signed [31:0] DataMemMuxALU;
    wire [31:0] BranchOrNot;
    
    // Upper Branch (PC)
    Nbit_reg  #(32)PC(.clk(clk), .reset(rst), .load(PCLoad), .shiften(0), .data(PCIn), .Q(PCOut));
    RCA Add4PC(.A(PCOut), .B(32'd4), .carryIn(0), .Sum(PC4_Out));
    RCA AddPCImm(.A(PCOut), .B(Immediate), .carryIn(0), .Sum(PCImm_Out));
    BranchCU branchCU(.BR(IR[`IR_funct3]), .zf(zeroFlag), .cf(carryFlag), .vf(overflowFlag), .sf(signFlag), .branch(Branch), .branchResult(BranchResult));
    Nbit_2x1mux #(32) BranchOrJalorNotMux(.A(PC4_Out), .B(PCImm_Out), .select(BranchResult | Jump), .out(BranchOrNot));
    Nbit_4x1mux #(32) PCMux(.A(PC4_Out), .B(BranchOrNot), .C(ALUOut), .D(32'd0), .select(PCSrc), .out(PCIn));
    
    // Lower Branch
//    InstMem InstructionMemory(.addr(PCOut[7:2]), .data_out(IR)); // Word Addressable
    InstMem InstructionMemory(.addr(PCOut[7:0]), .data_out(IR));
    CU ControlUnit(.inst(IR[`IR_opcode]), .inst20(IR[20]), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ALUOp(ALUOp), .RegWriteSrc(RegWriteSrc), .PCSrc(PCSrc), .PCLoad(PCLoad), .Jump(Jump));
    rv32_ImmGen ImmediateGenerator(.IR(IR), .Imm(Immediate));
    ALUCU ALUControl(.ALUOp(ALUOp), .Inst(IR[`IR_funct3]), .Inst30(IR[30]), .ALUSelection(ALUSelection));
   
    RegFile RegistersFile(.ReadReg1(IR[`IR_rs1]), .ReadReg2(IR[`IR_rs2]), .WriteReg(IR[`IR_rd]), .WriteData(RFWriteData), .RegWrite(RegWrite), .Reset(rst), .Clock(clk), .ReadData1(RFReadData1), .ReadData2(RFReadData2));
    Nbit_2x1mux #(32) RFMuxALU(.A(RFReadData2), .B(Immediate), .select(ALUSrc), .out(RFMuxALUOut));
    prv32_ALU  ALU(.a(RFReadData1), .b(RFMuxALUOut), .shamt(RFMuxALUOut), .alufn(ALUSelection), .r(ALUOut), .zf(zeroFlag), .cf(carryFlag), .vf(overflowFlag), .sf(signFlag));
    DataMem DataMemory(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUOut[7:0]), .data_in(RFReadData2), .funct3(IR[`IR_funct3]), .data_out(DataMemoryOut)); 
    Nbit_2x1mux #(32) DataMemMuxRF(.A(ALUOut), .B(DataMemoryOut), .select(MemtoReg), .out(DataMemMuxALU));
    Nbit_4x1mux #(32) RFWriteMux(.A(DataMemMuxALU), .B(PC4_Out), .C(PCImm_Out), .D(32'd0), .select(RegWriteSrc), .out(RFWriteData));

endmodule
