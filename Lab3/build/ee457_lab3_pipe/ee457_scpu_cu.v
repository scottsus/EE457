`timescale 1ns / 1ps
/*
 * File:  				ee457_scpu_cu.v
 *	Description:  		Control Unit for Single Cycle CPU
 *	Author: 				Mark Redekopp
 * Revisions:
 *   2012-June-5		Initial Release
 */
 
 module ee457_scpu_cu(
    // Machine instruction opcodes
  input  		[5:0]  	op,
  input  		[5:0]  	func,

  // Control signals to be generated
  output reg		     branch,
  output reg 					     jmp,
  output reg 					     mr,
  output reg 					     mw,
  output reg 					     regw,
  output reg 					     mtor,
  output reg 					     rdst,
  output reg 					     alusrc,
  output reg [1:0]     aluop
     
   );

    // Use these for opcode decoding
    localparam OP_LW    = 6'b100011;
    localparam OP_SW    = 6'b101011;
    localparam OP_RTYPE = 6'b000000;
    localparam OP_BEQ   = 6'b000100;
    localparam OP_BNE   = 6'b000101;
    localparam OP_JMP   = 6'b000010;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_JAL   = 6'b000011;
    localparam FUNC_ADD = 6'b100000;
    localparam FUNC_SUB = 6'b100010;
    localparam FUNC_AND = 6'b100100;
    localparam FUNC_OR  = 6'b100101;
    localparam FUNC_XOR = 6'b100110;
    localparam FUNC_NOR = 6'b100111;
    localparam FUNC_SLT = 6'b101010;
    localparam FUNC_SLL = 6'b000000;
    localparam FUNC_SRL = 6'b000010;
    localparam FUNC_SRA = 6'b000011;
    localparam FUNC_JR  = 6'b001000;

    always @*
    begin
    branch = 1'b0;
    jmp = 1'b0;
    mr = 1'b0;
    mw = 1'b0;
    regw = 1'b0;
    mtor = 1'b0;
    rdst = 1'b0;
    alusrc = 1'b0;
    aluop = 2'b00;
    if(op == OP_RTYPE)
        begin
        regw = 1'b1;
        aluop = 2'b10;
        alusrc = 1'b0;
        mtor = 1'b0;
        rdst = 1'b1;
        end
    else if(op == OP_LW)
        begin
        regw = 1'b1;
        aluop = 2'b00;
        alusrc = 1'b1;
        mr = 1'b1;
        mtor = 1'b1;
        rdst = 1'b0;        
        end
    else if(op == OP_SW)
        begin
        aluop = 2'b00;
        alusrc = 1'b1;
        mw = 1'b1;        
        end
    else if(op == OP_BEQ || op == OP_BNE)
        begin
        aluop = 2'b01;
        alusrc = 1'b0;
        branch = 1'b1;                
        end
    else if(op == OP_JMP)
        begin
        jmp = 1'b1;                        
        end
    else if(op == OP_ADDI)
        begin
        aluop = 2'b00;
        alusrc = 1'b1;
        regw = 1'b1;
        rdst = 1'b0;
        mtor = 1'b0;
        end

    end
endmodule

