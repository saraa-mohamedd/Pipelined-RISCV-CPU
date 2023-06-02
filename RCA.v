`timescale 1ns / 1ps


/*******************************************************************
*
* Module: RCA.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: ripple carry adder to add two wires, with size according to parameter
*
* Change history: 09/04/2023 - adapted from lab tasks, no further changes
* 
*
**********************************************************************/

module RCA #(parameter N = 32) 
    (input [N-1:0] A, B,
     input carryIn,
     output [N-1:0] Sum);
    genvar i;
    wire [N-1:0] carry;

    FullAdder first(A[0], B[0], carryIn, Sum[0], carry[0]);
    
    generate 
        for(i=1; i<N; i = i+1) begin
            FullAdder temp(A[i], B[i], carry[i-1], Sum[i], carry[i]);
        end
    endgenerate 
    
endmodule
