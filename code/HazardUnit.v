`timescale 1ns / 1ps

/*******************************************************************
*
* Module: HazardUnit.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: control unit to detect hazards and generate signals accordingly to stall
*
* Change history: 18/04/2023 - created module
*
*
**********************************************************************/


module HazardUnit(
    input [4:0] IF_ID_RegisterRs1, IF_ID_RegisterRs2, ID_EX_RegisterRd,
    input ID_EX_MemRead,
    output reg stall
    );
    
    always @(*) begin
        if ( ( (IF_ID_RegisterRs1 == ID_EX_RegisterRd) || (IF_ID_RegisterRs2 == ID_EX_RegisterRd) ) && ID_EX_MemRead 
	&& ID_EX_RegisterRd != 0)
            stall = 1'b1;
        else
            stall = 1'b0;
    end
endmodule
