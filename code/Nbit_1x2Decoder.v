`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Nbit_1x2Decoder.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: module that models a 1x2 decoder taking N-bit inputs
*
* Change history: 25/04/2023 - created module
*
*
**********************************************************************/

module Nbit_1x2Decoder #(parameter N=32) (input [N-1:0] in, input select, output reg [N-1:0] firstOut, output reg [N-1:0] secondOut);
    always @(*) begin
        if(select == 1'b1)
            firstOut = in;
        else
            secondOut = in;
    end
endmodule
