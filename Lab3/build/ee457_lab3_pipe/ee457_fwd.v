`timescale 1ns / 1ps
/*
 * 	File:  				ee457_FU.v
 *	Description:  		Forwarding Unit incomplete
 *	Author: 			 Mark Redekopp
 * 	Revisions:
 *  
 *  2014-July-8     Creation
 */
 
 module ee457_FU
	(
		// other inputs to determine true dependencies
		input                   mem_regwrite,
		input [4:0]             mem_wa,
		input                   wb_regwrite,
		input [4:0]             wb_wa,
		input [4:0]             ex_ra,
		input [4:0]             ex_rb,
		output reg [1:0]	 	alu_sela,
		output reg [1:0]        alu_selb
	);
	
	// Define local reg/wire signals here
	
	always @*
	begin
		alu_sela = 2'b00;
		alu_selb = 2'b00;
		if(mem_regwrite == 1 && (ex_ra == mem_wa) )
			alu_sela = 2'b01;
		else if(wb_regwrite == 1 && (ex_ra == wb_wa) )
			alu_sela = 2'b10;
		if(mem_regwrite == 1 && (ex_rb == mem_wa) )
			alu_selb = 2'b01;
		else if(wb_regwrite == 1 && (ex_rb == wb_wa) )
			alu_selb = 2'b10;
	end
		
endmodule
