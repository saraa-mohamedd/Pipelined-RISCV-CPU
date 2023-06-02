`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Nbit_shiftleft1.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that shifts wire left one bit
*
* Change history: 09/04/2023 - adapted from lab tasks, no further changes
* 
*
**********************************************************************/

module Nbit_shiftleft1 #(parameter N = 8) (
    input [N-1:0] in,
    output [N-1:0] out
    );
    assign out = {in[N-2:0], 1'b0};
endmodule
