`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Shifter.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that shifts input a according to input shamt, according to input type
*
* Change history: 09/04/2023 - created the module to satisfy prv32_ALU shifting requirements
* 
*
**********************************************************************/

module Shifter(
    input   wire [31:0] a,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	input   wire [1:0]  type
);
    
    always @(*) begin
        case (type) 
            2'b00: r = a >> shamt ; // shift right logical (pad with zeros)
            2'b01: r =  a << shamt; // shift left logical (pad with zeros)
            2'b10: r = ($signed(a) >>> shamt); // shift right arith 
            default: r = a;
        endcase
    end

endmodule
