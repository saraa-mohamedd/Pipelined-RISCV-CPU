`timescale 1ns / 1ps

/*******************************************************************
*
* Module: prv32_ALU.v
* Project: CSCE3301_PROJECT1
* Author: Sara Mohamed - sara_mohamed@aucegypt.edu
          Mohamed Noureldin - mohamed-sherif@aucegypt.edu
* Description: ALU of RISCV
*
* Change history: 09/04/2023 - taken from code offered in project description
*                 26/04/2023 - added support for RISCV-32M instructions (multiply/divide/remainder)
*
**********************************************************************/

module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg signed [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    Shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD    :   r = add;
            `ALU_SUB    :   r = add;
            `ALU_PASS   :   r = b;
            // logic
            `ALU_OR     :   r = a | b;
            `ALU_AND    :   r = a & b;
            `ALU_XOR    :   r = a ^ b;
            // shift
            `ALU_SRL    :   r = sh;
            `ALU_SLL    :   r = sh;
            `ALU_SRA    :   r = sh;
            // slt & sltu
            `ALU_SLT    :   r = {31'b0,(sf != vf)}; 
            `ALU_SLTU   :   r = {31'b0,(~cf)};
            // multiplication
            `ALU_MUL    :   r = ($signed(a)*$signed(b));
            `ALU_MULH   :   r = ($signed(a)*$signed(b)) >> 32;
            `ALU_MULSU  :   r = ($signed(a)*b) >> 32;
            `ALU_MULU   :   r = (a*b) >> 32;
            // division
            `ALU_DIV    :   r = $signed(a)/$signed(b);
            `ALU_DIVU   :   r = a/b;
            // remainder
            `ALU_REM    :   r = $signed(a)%$signed(b);
            `ALU_REMU   :   r = a%b;
            
            default     :   r = 0;
        endcase
    end
endmodule
