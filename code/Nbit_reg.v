`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Nbit_reg.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: register for Nbit values, specified using parameter
*
* Change history: 09/04/2023 - adapted from lab tasks, no further changes
* 
*
**********************************************************************/

module Nbit_reg #(parameter N = 8)
(input clk, reset, load, shiften, input [N-1:0] data, output reg [N-1:0] Q);

wire[N-1:0] shiftedQ;
Nbit_shiftleft1 #(N) uut(Q, shiftedQ);

always @(posedge clk, posedge reset) begin
    if(reset == 1'b1) begin
        Q <= 0; end
    else if (load == 1'b1) begin
        Q <= data; end
    else if (shiften == 1'b1) begin
        Q <= shiftedQ ; end
end
endmodule
