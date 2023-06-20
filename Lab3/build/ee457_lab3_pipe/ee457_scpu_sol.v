`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:57 03/22/2010 
// Design Name: 
// Module Name:    ee357_mcpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ee457_scpu(
    // I/O interface to memory
    output 	    [31:0] 	imem_addr,
    output 		[31:0] 	imem_wdata,
    output 				imemread,
    output 				imemwrite,
    input		[31:0]	imem_rdata,

    output 		[31:0] 	dmem_addr,
    output 		[31:0] 	dmem_wdata,
    output 				dmemread,
    output 				dmemwrite,
    input		[31:0]	dmem_rdata,


    // Register File I/O for debug/checking purposes
    output		[4:0]	reg_ra,
    output		[4:0]	reg_rb,
    output		[4:0]	reg_wa,
    output		[31:0]	reg_radata,
    output		[31:0]	reg_rbdata,
    output		[31:0]	reg_wdata,
    output				regwrite,
     
    // Clock and reset
    input 				clk,
    input 				rst
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

    // ALU signals
    wire [31:0]		ina;
    wire [31:0]		inb;
    reg  [5:0]		alu_func;
    wire [31:0]		alu_res;
    wire 			sov;
    wire            uov;
    wire			zero;
    
    // Control Signals
    wire 			jump;
    wire 			branch;
    wire 			memtoreg;
    wire 			regdst;
    wire 			alusrc;
    wire [1:0]		aluop;

    wire [5:0]		opcode;
    wire [4:0]		rs;
    wire [4:0]		rt;
    wire [4:0]		rd;
    wire [4:0]		shamt;	
    wire [5:0]		func;
    wire [15:0]		imm;
    wire [25:0]		jmpaddr;

    reg  [31:0]		pc;
    reg  [31:0]		pc_d;
    wire [31:0]		next_pc;
    wire [31:0] 	imm_sext;
    wire [31:0]		imm_sext_sh2;
    wire [31:0]		jump_target_pc;
    wire [31:0]		branch_target_pc;
    
    
    
    // PC process
    always @(posedge clk)
    begin
        if (rst == 1)
            pc <= 32'b0;
        else 
            pc <= pc_d;
    end

    assign imemread = 1'b1;
    assign imemwrite = 1'b0;
    assign imem_addr = pc;
    assign imem_wdata = 32'b0;

    assign next_pc = pc + 32'd4;
  
    // IR Field Breakout
    assign opcode = imem_rdata[31:26];
    assign rs = imem_rdata[25:21];
    assign rt = imem_rdata[20:16];
    assign rd = imem_rdata[15:11];
    assign shamt = imem_rdata[10:6];	
    assign func = imem_rdata[5:0];
    assign imm = imem_rdata[15:0];
    assign jmpaddr = imem_rdata[25:0];
    
    assign reg_ra = rs;
    assign reg_rb = rt;
    
    assign imm_sext = { {16{imm[15]}},imm};

    // Control Unit (state machine)
    ee457_scpu_cu ctrl_unit(
        .op(opcode),
        .func(func),
        .branch(branch),
        .jmp(jump),
        .mr(dmemread),
        .mw(dmemwrite),
        .regw(regwrite),
        .mtor(memtoreg),
        .rdst(regdst),
        .alusrc(alusrc),
        .aluop(aluop)
    );

    
    // Regfile instance
    ee457_regfile_2r1w regfile (
        .ra(reg_ra),
        .rb(reg_rb),
        .wa(reg_wa),
        .wdata(reg_wdata),
        .wen(regwrite),
        .clk(clk),
        .rst(rst),
        .radata(reg_radata),
        .rbdata(reg_rbdata)
    );


    assign imm_sext_sh2 = {imm_sext[29:0],2'b0};
    assign branch_target_pc = next_pc + imm_sext_sh2;
    assign jump_target_pc = {next_pc[31:28],jmpaddr,2'b00};
     
    assign ina = reg_radata;
    assign inb = alusrc ? imm_sext : reg_rbdata;

    always @*
    begin
        if (aluop == 2'b00)
            alu_func = FUNC_ADD;
        else if (aluop == 2'b01)
            alu_func = FUNC_SUB;
        else
            alu_func = func;
    end
     
    // ALU instance
    ee457_alu alu (
        .opa(ina),
        .opb(inb),
        .func(alu_func),
        .res(alu_res), 
        .uov(), 
        .sov(sov),
        .zero(zero),
        .cout()
        );

    assign dmem_addr = alu_res;
    assign dmem_wdata = reg_rbdata;

    always @*
    begin
        if (opcode == OP_BEQ && zero == 1 || opcode == OP_BNE && zero == 0)
            pc_d = branch_target_pc;
        else if (jump == 1)
            pc_d = jump_target_pc;
        else
            pc_d = next_pc;
    end

    assign reg_wdata = memtoreg ? dmem_rdata : alu_res;
    assign reg_wa = regdst ? rd : rt;
      

endmodule

