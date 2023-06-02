`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Nbit_2x1mux.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: 2x1 multiplexer to pick between two wires, of size according to parameter
*
* Change history: 09/04/2023 - adapted from lab tasks, no further changes
* 
*
**********************************************************************/

module Nbit_2x1mux #(parameter N = 8) (
    input [N-1:0] A, B,
    input select,
    output [N-1:0] out
    );
    assign out = (select)?B:A;
endmodule
