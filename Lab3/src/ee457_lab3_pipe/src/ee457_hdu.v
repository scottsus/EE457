`timescale 1ns / 1ps
/*
 * 	File:  				ee457_HDU.v
 *	Description:  		Hazard Detection Unit incomplete
 *	Author: 			Yue (Sam) Gao, Professor Mark Redekopp
 * 	Revisions:
 *  2012-June-5		Creation
 *	2012-June-8 	Compiled the incomplete version for students
 *  2014-July-8     Removed flush signal, fixed reg declarations
 */
 
 module ee457_hdu
	(
		// other inputs to determine true dependencies
		input                   ex_lw,
		input [4:0]             ex_wa,
		input [4:0]             id_ra,
		input [4:0]             id_rb,
		output reg   		 	stall,	// think: which stage registers need the stall signal? Do you need multiple stall signals for each stage?
		output 					irwrite,
		output 					pcwrite
	);
	
	// Define local reg/wire signals here
	always @ *					// OPTION 1
	begin
		
		stall = 0;
		if (ex_lw && (ex_wa == id_ra || ex_wa == id_rb) ) begin
		   stall = 1;
		end
	end
	assign irwrite = ~stall;
	assign pcwrite = ~stall;
		
endmodule
