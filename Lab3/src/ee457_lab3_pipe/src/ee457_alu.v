`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:53 01/05/2010 
// Design Name: 
// Module Name:    ee357_alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//		FUNC[5:0] =>
//         00 hex => shift left logical (opa = shift amount, opb = shift data)
//         02 hex => shift right logical (opa = shift amount, opb = shift data)
//         03 hex => shift right arithmetic (opa = shift amount, opb = shift data)
//         20 hex => add 
//         22 hex => sub (opa - opb)
//         24 hex => and
//         25 hex => or
//         26 hex => xor
//         27 hex => nor
//			  2a hex => slt
//		COUT => Raw carry-out for arithmetic operations, 0 for shift & logical ops.
//		UOV  => Unsigned overflow flag for arith. ops., 0 for shift & logical ops.
//		SOV  => Signed overflow flag for arith. ops., 0 for shift & logical ops.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ee457_alu(
    input [31:0] opa,
    input [31:0] opb,
    input [5:0] func,
    output [31:0] res,
    output reg uov,
    output reg sov,
	 output zero,
    output reg cout
    );

	wire [32:0] arith_res;
	wire [31:0] slt_res;
	reg [31:0] res_fb;
	reg cin;
	reg [31:0] opb_int;
	wire slt_flag;
	wire signed [31:0] opb_signed;
	// Use these for decoding
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
	
	// Arithmetic operation pre-process
	always @(opb, func)
	begin
		// Sub && SLT
		if (func == FUNC_SUB || func == FUNC_SLT)
			begin
			opb_int <= ~opb;
			cin <= 1;			
			end
		// Add
		else
			begin
			opb_int <= opb;			
			cin <= 0;
			end
	end

	assign arith_res = {1'b0,opa} + {1'b0,opb_int} + cin;
	assign opb_signed = opb;
	// Result generation process
	always @(opa, opb, arith_res, opb_signed, func)
	begin
		// Shift left logical
		if (func == FUNC_SLL)
			res_fb <= opb << opa;
		// Shift right logical
		else if (func == FUNC_SRL)
			res_fb <= opb >> opa;
		// Shift right arithmetic
		else if (func == FUNC_SRA)
			res_fb <= opb_signed >>> opa;
		// AND
		else if (func == FUNC_AND)
			res_fb <= opa & opb;
		// OR
		else if (func == FUNC_OR)
			res_fb <= opa | opb;
		// XOR
		else if (func == FUNC_XOR)
			res_fb <= opa ^ opb;
		// NOR
		else if (func == FUNC_NOR) 
			res_fb <= ~(opa | opb);
		// Arithmetic result
		else
			res_fb <= arith_res[31:0];
	end
	
	// Output flag generation process
	always @(opa, opb_int, arith_res, func)
	begin
		// Default values for Shift and Logical ops
		uov <= 0;
		sov <= 0;
		cout <= 0;

		// Add 
		if (func == FUNC_ADD)
			begin
			cout <= arith_res[32];
			uov <= arith_res[32];
			sov <= (opa[31] & opb_int[31] & ~arith_res[31]) | 
					 (~opa[31] & ~opb_int[31] & arith_res[31]);
			end
		// Sub 
		else if (func == FUNC_SUB || func == FUNC_SLT)
			begin
			cout <= arith_res[32];
			uov <= ~arith_res[32];
			sov <= (opa[31] & opb_int[31] & ~arith_res[31]) | 
					 (~opa[31] & ~opb_int[31] & arith_res[31]);
			end		
	end
	
	// ============ TO BE COMPLETED BY YOU ==================
	// Change the logic for slt_flag below
	// slt_flag = 1 if result of subtraction indicates A < B, 
	//            0 otherwise
	// Be sure to take overflow into account 
	//            (Note: SLT assumes signed operands)
	assign slt_flag = sov ^ arith_res[31];

	assign slt_res = {31'b0, slt_flag};
	assign res = (func == FUNC_SLT) ? slt_res : res_fb;
	assign zero = (res == 32'b0) ? 1 : 0;
	
endmodule
