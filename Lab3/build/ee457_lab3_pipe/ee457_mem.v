`timescale 1ns / 1ps
/*
 * File:  				ee457_mem.v
 *	Description:  		256x32 Memory
 *	Author: 				Mark Redekopp
 * Revisions:
 *   2009-Mar-18		Initial Release
 */
 
 module ee457_mem 
 (
	input			[7:0]		addr,
	input	 		[31:0]  	wdata,
	input       	   	memread,
	input       	   	memwrite,
	input 					clk,
	output reg	[31:0] 	rdata
	);
	parameter INIT_FILE = "mem_file.txt";
	parameter ADDR_SIZE = 8;
   parameter DATA_SIZE = 32;
	
	localparam ARRAY_DEPTH = 1 << ADDR_SIZE;
	
	reg [DATA_SIZE-1:0] 	mem [0:ARRAY_DEPTH-1];
	
	initial
		$readmemh(INIT_FILE, mem);
		
	always @*
	begin
		if(memread)
			rdata <= mem[addr];
		else
			rdata <= 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	end
	
	always @(posedge clk)
	begin
		if(memwrite)
			mem[addr] <= wdata;
	end

endmodule
