`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Nbit_4x1mux.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: 4x1 multiplexer to choose between four wires, of size according to parameter
*
* Change history: 10/04/2023 - created module together
* 
*
**********************************************************************/


module Nbit_4x1mux #(parameter N = 32) (
    input [N-1:0] A, B, C, D,
    input [1:0] select,
    output reg [N-1:0] out
);
    always @(*) begin
        case (select)
            2'b00: out = A;
            2'b01: out = B;
            2'b10: out = C;
            2'b11: out = D;
            default: out = A;
        endcase 
    end
endmodule
