`timescale 1ns / 1ps

/*******************************************************************
*
* Module: CU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: control unit that produces control signals
*
* Change history: 09/04/2023 - adapted from lab tasks 
*                 09/04/2023 - increased ALUOp signal to three bits for extended functionalities in the ALU
*                 10/04/2023 - added cases for opcodes of all instructions 
*                 11/04/2023 - added RegWriteSrc, PCSrc, PCLoad, Jump signals for multiplexer select lines, and for PC freezing mechanisms
* 
*
**********************************************************************/

module CU(
      input[6:2] inst,
      input inst20,
      output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, PCLoad, Jump,
      output reg [2:0] ALUOp,
      output reg [1:0] RegWriteSrc, PCSrc
    );
    
always@(*) begin
case(inst)
    `OPCODE_Arith_R: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b010; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b1; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_Load: begin
        Branch = 1'b0;  MemRead = 1'b1; MemtoReg = 1'b1; ALUOp = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_Store: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'bx; ALUOp = 3'b000; MemWrite = 1'b1; ALUSrc = 1'b1; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_Branch: begin 
        Branch = 1'b1;  MemRead = 1'b0; MemtoReg = 1'bx; ALUOp = 3'b001; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b01; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_Arith_I: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b011; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_LUI: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b100; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_AUIPC: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b100; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b10; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_JALR: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b101; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b01; PCSrc = 2'b10; PCLoad =1'b1; Jump = 1'b0;
    end
    `OPCODE_JAL: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b101; MemWrite = 1'b0; ALUSrc = 1'b1; RegWrite =1'b1; RegWriteSrc = 2'b01; PCSrc = 2'b01; PCLoad =1'b1; Jump = 1'b1;
    end
    `OPCODE_SYSTEM: begin // ECALL & EBREAK
        if(inst20) begin
            // EBREAk
            Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b0; Jump = 1'b0;
        end 
        else begin
            // ECALL
            Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b11; PCLoad =1'b1; Jump = 1'b0;
        end
    end
    `OPCODE_Fence: begin
        Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b11; PCLoad =1'b1; Jump = 1'b0;
    end
    default :  begin 
         Branch = 1'b0;  MemRead = 1'b0; MemtoReg = 1'b0; ALUOp = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b0; RegWrite =1'b0; RegWriteSrc = 2'b00; PCSrc = 2'b00; PCLoad =1'b1; Jump = 1'b0;
    end

endcase
end
endmodule
