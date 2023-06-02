`timescale 1ns / 1ps

/*******************************************************************
*
* Module: FullAdder.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: a full adder module, adds two single bit wires together
*
* Change history: 09/04/2023 - adapted from lab tasks, no further changes
* 
*
**********************************************************************/


module FullAdder(input A, B, Cin, output Sum, Cout);
    assign {Cout,Sum} = A + B + Cin;
endmodule

