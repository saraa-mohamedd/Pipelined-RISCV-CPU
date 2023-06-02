`timescale 1ns / 1ps

/*******************************************************************
*
* Module: RegFile.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that models the Register File in RISCV. 
*
* Change history: 09/04/2023 - adapted from lab tasks 
* 
*
**********************************************************************/

module RegFile #(parameter N = 32) (
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [N-1:0] WriteData,
    input RegWrite, Reset, Clock,
    output [N-1:0] ReadData1, ReadData2
    );
    reg [N-1:0] Registers [31:0];
    
    assign ReadData1 = Registers[ReadReg1];
    assign ReadData2 = Registers[ReadReg2];
    
    integer i;
    
    always @(posedge Clock or posedge  Reset) begin
        if(Reset == 1'b1) begin
            for(i=0; i<32; i = i + 1) 
                Registers[i] = 'b0;
        end
        else if(RegWrite == 1'b1 && WriteReg != 1'b0) begin
            Registers[WriteReg] = WriteData;
        end
    end

    
endmodule
