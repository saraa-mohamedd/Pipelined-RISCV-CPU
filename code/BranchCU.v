`timescale 1ns / 1ps
`include "defines.v"


/*******************************************************************
*
* Module: BranchCU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: control unit to manage branch operations, takes flags from ALU as input, and 
* the branch signal from the CU, to produce branchResult, a one bit wire to determine whether or 
* not to branch.
*
* Change history: 09/04/2023 - created module together
* 
*
**********************************************************************/


module BranchCU(
    input [2:0] BR,
    input zf, sf, vf, cf,
    input branch,
    output reg branchResult
);

    always @(*) begin
        if(branch) begin
            case (BR)
                `BR_BEQ:
                    branchResult = zf;
                `BR_BNE:
                    branchResult = ~zf;
                `BR_BLT:
                    branchResult = (sf != vf); 
                `BR_BGE:
                    branchResult = (sf == vf);
                `BR_BLTU:
                    branchResult = ~cf;
                `BR_BGEU:
                    branchResult = cf;
                default:
                    branchResult = 0;
            endcase
        end 
        else begin
            branchResult = 0;
        end
    end
endmodule
