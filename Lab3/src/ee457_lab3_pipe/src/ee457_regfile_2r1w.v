`timescale 1ns / 1ps
/*
 * File:  				ee357_regfile_2r1w.v
 *	Description:  		Register file with 2 read ports and 1 write port
 *                       ** With Internal Forwarding **
 *	Author: 				Mark Redekopp
 * Revisions:
 *   	2009-Mar-18		Initial Release
 *		2012-June-5 	Yue Gao (Add Internal Forwarding)
 */
 
 module ee457_regfile_2r1w 
	(
	input		[4:0]	ra,
	input		[4:0]	rb,
	input		[4:0]	wa,
	input	 	[31:0]  wdata,
	input          		wen,
	input          		clk,
	input       	   	rst,
	output 		[31:0] 	radata,
	output 		[31:0] 	rbdata
	);
	
	wire 		[31:0] 	radata_no_forwarding;
	wire 		[31:0] 	rbdata_no_forwarding;
	
	
 	parameter INIT_FILE = "reg_file.txt";
	parameter ADDR_SIZE = 5;
	parameter DATA_SIZE = 32;
	
	localparam ARRAY_DEPTH = 1 << ADDR_SIZE;
	
	reg [DATA_SIZE-1:0] 	regarray [0:ARRAY_DEPTH-1];
	
		
	always @ (posedge clk)
	begin
		if (rst)
			//$readmemh(INIT_FILE, array);
			;
		else if (wen)
			regarray[wa] <= wdata;
	end
	
	assign	radata_no_forwarding = (ra == 5'b00000) ? 32'b0 : regarray[ra];
	assign	rbdata_no_forwarding = (rb == 5'b00000) ? 32'b0 : regarray[rb];	
	assign	radata = (wa == ra && wen) ? wdata : radata_no_forwarding;	
	assign	rbdata = (wa == rb && wen) ? wdata : rbdata_no_forwarding;	
endmodule
