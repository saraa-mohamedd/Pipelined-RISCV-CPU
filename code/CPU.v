`timescale 1ns / 1ps
`include "defines.v"


/*******************************************************************
*
* Module: CPU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
*         Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: top module of the complete pipelined implementation of the RISCV-32 processor
*
* Change history: 09/04/2023 - adapted from lab tasks, edited literals using defines.v added branchCU to schematic
*                 10/04/2023 - edited size of inputs according to changes in sizes of signals
*                 11/04/2023 - added three multiplexers for FENCE, EBREAK, ECALL, AUIPC, LUI, JAL, and JALR instructions, 
*                              more wires, and adjusted inputs and outputs of modules
*                 13/04/2023 - implemented pipeline of processor
*                 18/04/2023 - added forwarding unit, hazard detection unit, and flushing mechanisms
*                 25/04/2023 - fixed clashes with stalling and jumping 
*                 25/04/2023 - turned pipeline into three step instead of five step, removed unnecessary hazard detection unit
*                 26/04/2023 - changed forwarding unit to output one bit signals instead of two, edited wires and MUXs accordingly
*
**********************************************************************/

module CPU(input clk, rst);
    wire [31:0] PCIn;
    wire [31:0] PCOut;
    wire [31:0] PC4_Out;
    wire [31:0] PCImm_Out;

    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, PCNotLoad, Jump;
    wire [1:0] RegWriteSrc, PCSrc;
    wire [2:0] ALUOp;
    wire [4:0] ALUSelection;
    wire [31:0] IR;
    wire signed [31:0] Immediate;
    wire signed [31:0] ShiftedImmediate;
    
    wire signed [31:0] RFReadData1, RFReadData2, RFWriteData;
    wire signed [31:0] ALUOut;
    wire zeroFlag, carryFlag, overflowFlag, signFlag;
    wire signed [31:0] DataMemoryOut;
    wire BranchResult;
    
    wire signed [31:0] DataMemMuxALU;
    wire [31:0] BranchOrNot;
    
    wire forwardA, forwardB;
    
    wire [31:0] InstructionMUXOut;
    wire [31:0] IF_ID_PC, IF_ID_Instruction, IF_ID_PC4_Out; 
    
    wire [31:0] ID_EX_PC, ID_EX_PC4_Out, ID_EX_ReadDataR1, ID_EX_ReadDataR2;
    wire signed [31:0] ID_EX_Immediate; 
    wire ID_EX_Ctrl_Branch, ID_EX_Ctrl_MemRead, ID_EX_Ctrl_MemtoReg, ID_EX_Ctrl_MemWrite, ID_EX_Ctrl_ALUSrc, ID_EX_Ctrl_RegWrite, ID_EX_Ctrl_PCNotLoad, ID_EX_Ctrl_Jump;
    wire [1:0] ID_EX_Ctrl_PCSrc, ID_EX_Ctrl_RegWriteSrc;
    wire [2:0] ID_EX_Ctrl_ALUOp;
    wire [2:0] ID_EX_Func3;
    wire ID_EX_Func30, ID_EX_Func25;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd; 
    // hazard MUX
    wire [14:0] ID_EX_Control_Input;
    
    wire [31:0] ALUInput1, ALUInput2;
    wire [31:0] ForwardBMuxOut;

    wire [31:0] EX_MEM_PCImm_Out, EX_MEM_PC4_Out, EX_MEM_ReadDataR2; 
    wire signed [31:0] EX_MEM_ALU_out;
    wire EX_MEM_Ctrl_Branch, EX_MEM_Ctrl_MemRead, EX_MEM_Ctrl_MemtoReg, EX_MEM_Ctrl_MemWrite, EX_MEM_Ctrl_RegWrite, EX_MEM_Ctrl_PCNotLoad, EX_MEM_Ctrl_Jump;
    wire [1:0] EX_MEM_Ctrl_PCSrc, EX_MEM_Ctrl_RegWriteSrc; 
    wire [4:0] EX_MEM_Rd; 
    wire [2:0] EX_MEM_Func3;
    wire EX_MEM_ZF, EX_MEM_CF, EX_MEM_VF, EX_MEM_SF; 
    
    // flush
    wire [10:0] EX_MEM_Ctrl_FLushMUXOut;
    
    wire [31:0] MEM_WB_PCImm_Out, MEM_WB_PC4_Out, MEM_WB_Mem_out;
    wire signed [31:0] MEM_WB_ALU_out; 
    wire MEM_WB_Ctrl_MemtoReg, MEM_WB_Ctrl_RegWrite; 
    wire [1:0] MEM_WB_Ctrl_RegWriteSrc;
    wire [4:0] MEM_WB_Rd; 


    /*******************************************************************
    *  Instruction Fetch - IF Stage
    ********************************************************************/
    Nbit_reg  #(32)PC(.clk(!clk), .reset(rst), .load(EX_MEM_Ctrl_Jump || BranchResult || ~EX_MEM_Ctrl_PCNotLoad), .shiften(1'b0), .data(PCIn), .Q(PCOut));
    RCA Add4PC(.A(PCOut), .B(32'd4), .carryIn(1'b0), .Sum(PC4_Out));
    Nbit_2x1mux #(32) BranchOrJalorNotMux(.A(PC4_Out), .B(EX_MEM_PCImm_Out), .select(BranchResult | EX_MEM_Ctrl_Jump), .out(BranchOrNot));
    Nbit_4x1mux #(32) PCMux(.A(PC4_Out), .B(BranchOrNot), .C(EX_MEM_ALU_out), .D(32'd0), .select(EX_MEM_Ctrl_PCSrc), .out(PCIn));
    
    // flush
    Nbit_2x1mux #(32) InstructionFlushMux(.A(IR), .B(32'h00000033), .select(EX_MEM_Ctrl_Jump || BranchResult), .out(InstructionMUXOut)); // check for jalr
    
    /*******************************************************************
    *  IF/ID Register
    ********************************************************************/
    Nbit_reg #(96) IF_ID (
        .clk(!clk), .reset(rst), .load(EX_MEM_Ctrl_Jump || BranchResult || ~EX_MEM_Ctrl_PCNotLoad), .shiften(1'b0),
        .data({PCOut, PC4_Out, InstructionMUXOut}),
        .Q({IF_ID_PC, IF_ID_PC4_Out, IF_ID_Instruction})
    ); 
    
    /*******************************************************************
    *  Instruction Decode - ID Stage
    ********************************************************************/
    RegFile RegistersFile(
        .ReadReg1(IF_ID_Instruction[`IR_rs1]), .ReadReg2(IF_ID_Instruction[`IR_rs2]),
        .WriteReg(MEM_WB_Rd), .WriteData(RFWriteData), .RegWrite(MEM_WB_Ctrl_RegWrite),
        .Reset(rst), .Clock(!clk), 
        .ReadData1(RFReadData1), .ReadData2(RFReadData2)
    );
    rv32_ImmGen ImmediateGenerator(.IR(IF_ID_Instruction), .Imm(Immediate));
    Nbit_4x1mux #(32) RFWriteMux(.A(DataMemMuxALU), .B(MEM_WB_PC4_Out), .C(MEM_WB_PCImm_Out), .D(32'd0), .select(MEM_WB_Ctrl_RegWriteSrc), .out(RFWriteData));
    CU ControlUnit(
        .inst(IF_ID_Instruction[`IR_opcode]), .inst20(IF_ID_Instruction[20]),
        .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ALUOp(ALUOp),
        .RegWriteSrc(RegWriteSrc), .PCSrc(PCSrc), .PCNotLoad(PCNotLoad), .Jump(Jump)
    );
    
    // flush
    Nbit_2x1mux #(15) ID_EX_Control_Stall_Mux(.A({Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, PCNotLoad, Jump, PCSrc, RegWriteSrc, ALUOp}), .B(15'd0), .select(EX_MEM_Ctrl_Jump || BranchResult), .out(ID_EX_Control_Input));

    /*******************************************************************
    *  ID/EX Register
    ********************************************************************/
    Nbit_reg #(195) ID_EX (
       .clk(clk), .reset(rst), .load(~EX_MEM_Ctrl_PCNotLoad), .shiften(1'b0),
       .data({ID_EX_Control_Input, IF_ID_PC, IF_ID_PC4_Out, RFReadData1, RFReadData2, Immediate, IF_ID_Instruction[30], IF_ID_Instruction[25],
               IF_ID_Instruction[`IR_funct3], IF_ID_Instruction[`IR_rs1], IF_ID_Instruction[`IR_rs2], IF_ID_Instruction[`IR_rd]}), 
       .Q({ID_EX_Ctrl_Branch, ID_EX_Ctrl_MemRead, ID_EX_Ctrl_MemtoReg, ID_EX_Ctrl_MemWrite, ID_EX_Ctrl_ALUSrc, ID_EX_Ctrl_RegWrite, ID_EX_Ctrl_PCNotLoad, ID_EX_Ctrl_Jump, 
              ID_EX_Ctrl_PCSrc, ID_EX_Ctrl_RegWriteSrc, ID_EX_Ctrl_ALUOp, ID_EX_PC, ID_EX_PC4_Out, ID_EX_ReadDataR1, ID_EX_ReadDataR2, ID_EX_Immediate, 
              ID_EX_Func30, ID_EX_Func25, ID_EX_Func3,
              ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd}) 
    ); 

    /*******************************************************************
    *  Execution - EX Stage
    ********************************************************************/
    ALUCU ALUControl(.ALUOp(ID_EX_Ctrl_ALUOp), .Inst(ID_EX_Func3), .Inst30(ID_EX_Func30), .Inst25(ID_EX_Func25), .ALUSelection(ALUSelection));
    RCA AddPCImm(.A(ID_EX_PC), .B(ID_EX_Immediate), .carryIn(1'b0), .Sum(PCImm_Out));
    Nbit_2x1mux #(32) ForwardAMux(.A(ID_EX_ReadDataR1), .B(RFWriteData), .select(forwardA), .out(ALUInput1));
    Nbit_2x1mux #(32) ForwardBMux(.A(ID_EX_ReadDataR2), .B(RFWriteData), .select(forwardB), .out(ForwardBMuxOut));
    Nbit_2x1mux #(32) RFMuxALU(.A(ForwardBMuxOut), .B(ID_EX_Immediate), .select(ID_EX_Ctrl_ALUSrc), .out(ALUInput2));
    prv32_ALU  ALU(.a(ALUInput1), .b(ALUInput2), .shamt(ALUInput2[4:0]), .alufn(ALUSelection), .r(ALUOut), .zf(zeroFlag), .cf(carryFlag), .vf(overflowFlag), .sf(signFlag));
    
    // flush
    Nbit_2x1mux #(11) EX_MEM_Flush (
        .A({ID_EX_Ctrl_Branch, ID_EX_Ctrl_MemRead, ID_EX_Ctrl_MemtoReg, ID_EX_Ctrl_MemWrite, ID_EX_Ctrl_RegWrite, 
               ID_EX_Ctrl_PCNotLoad, ID_EX_Ctrl_Jump, ID_EX_Ctrl_PCSrc, ID_EX_Ctrl_RegWriteSrc}), 
        .B(11'd0), 
        .select(EX_MEM_Ctrl_Jump || BranchResult), 
        .out(EX_MEM_Ctrl_FLushMUXOut)
    );
    
    /*******************************************************************
    *  EX/MEM Register
    ********************************************************************/
    Nbit_reg #(151) EX_MEM (
        .clk(!clk), .reset(rst), .load(~EX_MEM_Ctrl_PCNotLoad), .shiften(1'b0),
        .data({PCImm_Out, ID_EX_PC4_Out, ALUOut, ForwardBMuxOut, EX_MEM_Ctrl_FLushMUXOut, ID_EX_Rd, zeroFlag, carryFlag, overflowFlag, signFlag, ID_EX_Func3}), 
        .Q({EX_MEM_PCImm_Out, EX_MEM_PC4_Out, EX_MEM_ALU_out, EX_MEM_ReadDataR2, EX_MEM_Ctrl_Branch, EX_MEM_Ctrl_MemRead, EX_MEM_Ctrl_MemtoReg, EX_MEM_Ctrl_MemWrite, 
               EX_MEM_Ctrl_RegWrite, EX_MEM_Ctrl_PCNotLoad, EX_MEM_Ctrl_Jump, EX_MEM_Ctrl_PCSrc, EX_MEM_Ctrl_RegWriteSrc, EX_MEM_Rd, 
               EX_MEM_ZF, EX_MEM_CF, EX_MEM_VF, EX_MEM_SF, EX_MEM_Func3} )
    );     
    
    /*******************************************************************
    *  Memory - MEM Stage
    ********************************************************************/
    BranchCU branchCU(.BR(EX_MEM_Func3), .zf(EX_MEM_ZF), .cf(EX_MEM_CF), .vf(EX_MEM_VF), .sf(EX_MEM_SF), .branch(EX_MEM_Ctrl_Branch), .branchResult(BranchResult));
    
    /*******************************************************************
    *  MEM/WB Register
    ********************************************************************/
    Nbit_reg #(137) MEM_WB (
        .clk(clk), .reset(rst), .load(1'b1), .shiften(1'b0),
        .data({EX_MEM_PCImm_Out, EX_MEM_PC4_Out, DataMemoryOut, EX_MEM_ALU_out, EX_MEM_Ctrl_MemtoReg, EX_MEM_Ctrl_RegWrite, EX_MEM_Ctrl_RegWriteSrc, EX_MEM_Rd}), 
        .Q({MEM_WB_PCImm_Out, MEM_WB_PC4_Out, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Ctrl_MemtoReg, MEM_WB_Ctrl_RegWrite, MEM_WB_Ctrl_RegWriteSrc, MEM_WB_Rd})
    );
        
    /*******************************************************************
    *  WriteBack - WB Stage
    ********************************************************************/
    Nbit_2x1mux #(32) DataMemMuxRF(.A(MEM_WB_ALU_out), .B(MEM_WB_Mem_out), .select(MEM_WB_Ctrl_MemtoReg), .out(DataMemMuxALU));
    
    /*******************************************************************
    *  Single Memory
    ********************************************************************/
    // A of mux is inputs to read Instruction from memory
    // B of mux is inputs to read/write data from memory
    
    wire SingleMemInput_MemRead, SingleMemInput_MemWrite;
    wire [2:0] SingleMemInput_Funct3;
    wire [31:0] SingleMemInput_Addr, SingleMemInput_DataIn;
    wire [31:0] SingleMemOutput;
    
    Nbit_2x1mux #(69) SingleMemoryInput(
        .A({1'b1, 1'b0, PCOut, 32'd0, 3'b010}),
        .B({EX_MEM_Ctrl_MemRead, EX_MEM_Ctrl_MemWrite, EX_MEM_ALU_out, EX_MEM_ReadDataR2, EX_MEM_Func3}),
        .select(!clk), 
        .out({SingleMemInput_MemRead, SingleMemInput_MemWrite, SingleMemInput_Addr, SingleMemInput_DataIn, SingleMemInput_Funct3})
    );
    
    SingleMem SingleMemory(
        .clk(clk),
        .MemRead(SingleMemInput_MemRead), .MemWrite(SingleMemInput_MemWrite),
        .addr(SingleMemInput_Addr), .data_in(SingleMemInput_DataIn),
        .funct3(SingleMemInput_Funct3),
        .data_out(SingleMemOutput)
    );
    
    Nbit_1x2Decoder singleMemoryDecoder(.in(SingleMemOutput), .select(clk), .firstOut(IR), .secondOut(DataMemoryOut));

    
    /*******************************************************************
    *  Hazards & Forwarding Unit & Hazard Detection Unit
    ********************************************************************/
    ForwardingUnit forwardingUnit(
        .ID_EX_RegisterRs1(ID_EX_Rs1), .ID_EX_RegisterRs2(ID_EX_Rs2),
        .MEM_WB_RegisterRd(MEM_WB_Rd), .MEM_WB_RegWrite(MEM_WB_Ctrl_RegWrite),
        .forwardA(forwardA), .forwardB(forwardB)
    );
 
endmodule
