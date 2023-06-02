`timescale 1ns / 1ps

/*******************************************************************
*
* Module: ForwardingUnit.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: control unit to detect the need to forward and generate output signals accordingly
*
* Change history: 18/04/2023 - created module
                  26/04/2023 - removed unnecessary inputs and outputs to module, turned forwardA and forwardB to one bit
*
*
**********************************************************************/



module ForwardingUnit(
    input [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2, MEM_WB_RegisterRd,
    input MEM_WB_RegWrite,
    output reg forwardA, forwardB
    );
    
    always @(*) begin
	    if ( (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1) ) begin
   		   forwardA = 1'b1;
   		end 
   		else begin
   		   forwardA = 1'b0;
   		end
   		
   		if ( (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) ) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2) ) begin
   		   forwardB = 1'b1;
   		end
   		else begin
   		   forwardB = 1'b0;
   		end
    end
    
endmodule
