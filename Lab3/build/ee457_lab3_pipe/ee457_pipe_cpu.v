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
module ee457_pipe_cpu(
    // I/O interface to memory
    output 		[31:0] 	imem_addr,
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


    // Use these for opcode decoding as necessary
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
    reg  [31:0]     ina_fu;
    wire [31:0]     ina;
    reg  [31:0]     inb_fu;
    wire [31:0]     inb;
    reg  [5:0]      alu_func;
    wire [31:0]     alu_res;
    wire            sov;
    wire            uov;
    wire            zero;
    
    // Control Signals
    wire            cu_jump;
    wire            cu_branch;
    wire            cu_memtoreg;
    wire            cu_regdst;
    wire            cu_alusrc;
    wire [1:0]      cu_aluop;
    wire            cu_regwrite;
    wire            cu_dmemread;
    wire            cu_dmemwrite;
    wire [5:0]      opcode;
    wire [4:0]      rs;
    wire [4:0]      rt;
    wire [4:0]      rd;
    wire [4:0]      shamt;	
    wire [5:0]      func;
    wire [15:0]     imm;
    wire [25:0]     jmpaddr;

    
    wire [31:0]     next_pc;
    wire [31:0]     imm_sext;
    wire [31:0]     imm_sext_sh2;
    wire [31:0]     jump_target_pc;
    wire [31:0]     branch_target_pc;

    // Fetch stage signals
    reg  [31:0]     pc;
    wire [31:0]     if_next_pc;
    reg             instruct_flushed;

    // IF/ID pipeline signals
    reg [31:0]      if_id_next_pc;
    reg [31:0]      if_id_instruc;
    
    wire            hdu_stall;
    wire            irwrite;
    wire            pcwrite;
    wire            stall;

    // ID/EX pipeline signals
    reg [31:0]      id_ex_next_pc;
    reg [31:0]      id_ex_reg_radata;
    reg [31:0]      id_ex_reg_rbdata;
    reg [31:0]      id_ex_imm_sext;
    reg [5:0]       id_ex_opcode;
    reg [5:0]       id_ex_func;
    reg [4:0]       id_ex_rs;
    reg [4:0]       id_ex_rt;
    reg [4:0]       id_ex_rd;
    reg [25:0]      id_ex_jump_addr;
    reg             id_ex_branch;
    reg             id_ex_jump;
    reg             id_ex_regdst;
    reg             id_ex_alusrc;
    reg [1:0]       id_ex_aluop;
    reg             id_ex_memread;
    reg             id_ex_memwrite;
    reg             id_ex_regwrite;
    reg             id_ex_memtoreg;
    
    wire [1:0]      alu_sela;
    wire [1:0]      alu_selb;
    
    // EX/MEM pipeline signals
    reg [31:0]      ex_mem_next_pc;
    reg [5:0]       ex_mem_opcode;
    reg [31:0]      ex_mem_alu_result;
    reg [31:0]      ex_mem_reg_rbdata;
    reg             ex_mem_alu_zero;
    reg [4:0]       ex_mem_write_reg_id;
    reg             ex_mem_branch;
    reg             ex_mem_jump;
    reg             ex_mem_regdst;
    reg             ex_mem_memread;
    reg             ex_mem_memwrite;
    reg             ex_mem_regwrite;
    reg             ex_mem_memtoreg;

    reg [31:0]      ex_mem_next_pc_d;
    wire [4:0]      ex_mem_write_reg_id_d;
    
    wire            branch_taken;
    

    // TODO: Define MEM/WB pipeline signals
    //  We suggest names with the prefix mem_wb_<signal>
    // MEM/WB pipeline signals
    reg [31:0]      mem_wb_alu_result;
    reg [31:0]      mem_wb_dmem_rdata;
    reg [4:0]       mem_wb_write_reg_id;
    reg             mem_wb_regdst;
    reg             mem_wb_regwrite;
    reg             mem_wb_memtoreg;

    // WB stage signals
    reg [31:0]      wb_alu_result;
    reg [31:0]      wb_dmem_rdata;
    reg             wb_regwrite;
    reg [4:0]       wb_write_reg_id;
    reg             memtoreg;  
    reg             regdst;

    //=================================
    //  Fetch Stage
    //=================================
    // PC process
    always @(posedge clk)
    begin
        if (rst == 1)
            pc <= 32'b0;
        else if (branch_taken == 1)
            pc <= ex_mem_next_pc;
        else if (pcwrite == 1)
            pc <= if_next_pc;
    end
    assign if_next_pc = pc + 32'd4;

    assign imemread = 1'b1;
    assign imemwrite = 1'b0;
    assign imem_addr = pc;
    assign imem_wdata = 32'b0;

    // IF/ID Stage Register process
    always @(posedge clk)
    begin
        instruct_flushed <= branch_taken || rst;
        if (branch_taken || rst)
            begin
            if_id_next_pc <= 32'b0;
            if_id_instruc <= 32'b0;
            end
        else if (branch_taken == 0 && irwrite == 1)
            begin
            if_id_next_pc <= if_next_pc;
            if_id_instruc <= imem_rdata;
            end
    end
    

    //=================================
    //  Decode Stage
    //=================================

    // IR Field Breakout
    assign opcode = if_id_instruc[31:26];
    assign rs = if_id_instruc[25:21];
    assign rt = if_id_instruc[20:16];
    assign rd = if_id_instruc[15:11];
    assign shamt = if_id_instruc[10:6];	
    assign func = if_id_instruc[5:0];
    assign imm = if_id_instruc[15:0];
    assign jmpaddr = if_id_instruc[25:0];
    
    assign reg_ra = rs;
    assign reg_rb = rt;
    
    assign imm_sext = {{16{imm[15]}}, imm};

    // Control Unit (state machine)
    ee457_scpu_cu ctrl_unit(
        .op(opcode),
        .func(func),
        .branch(cu_branch),
        .jmp(cu_jump),
        .mr(cu_dmemread),
        .mw(cu_dmemwrite),
        .regw(cu_regwrite),
        .mtor(cu_memtoreg),
        .rdst(cu_regdst),
        .alusrc(cu_alusrc),
        .aluop(cu_aluop)
    );

    // TODO: Connect the signals to the HDU
    ee457_hdu hdu(
        .ex_lw(ex_mem_memread),
        .ex_wa(ex_mem_write_reg_id),
        .id_ra(id_ex_rs),
        .id_rb(id_ex_rt),
        .stall(hdu_stall),
        .irwrite(irwrite),
        .pcwrite(pcwrite)
    );

    // TODO: Map the appropriate signals to wa, wdata, and wen
    // Regfile instance
    ee457_regfile_2r1w regfile (
        .ra(reg_ra),
        .rb(reg_rb),
        .wa(reg_wa),
        .wdata(reg_wdata),
        .wen(regwrite),
        .clk(clk),
        .rst(rst),
        .memtoreg(memtoreg),
        .radata(reg_radata),
        .rbdata(reg_rbdata)
    );

    // TODO: assign the signals you connect to the regfile above
    //   to the primary outputs (for debugging purposes)
    assign reg_wa = mem_wb_write_reg_id;
    assign regwrite = ex_mem_regwrite || mem_wb_regwrite;
    assign reg_wdata = memtoreg ? wb_dmem_rdata : mem_wb_alu_result;
    // assign blah = memtoreg ? wb_dmem_rdata : mem_wb_alu_result;

    // TODO: Use hdu_stall and other signals to produce the 
    //       signal which we call `insert_bubble` which we
    //       use in the id_ex pipe to insert a bubble.
    assign insert_bubble = hdu_stall || instruct_flushed;	

    // ID/EX Stage Register process
    always @(posedge clk)
    begin
        if (rst == 1 || insert_bubble == 1)
            begin
            id_ex_next_pc <= 32'bX;
            id_ex_reg_radata <= 32'bX;
            id_ex_reg_rbdata <= 32'bX;
            id_ex_imm_sext <= 32'bX;
            id_ex_opcode <= 6'bX;
            id_ex_func <= 6'bX;
            id_ex_rs <= 5'b0;
            id_ex_rt <= 5'b0;
            id_ex_rd <= 5'b0;
            id_ex_jump_addr <= 26'bX;
            id_ex_regdst <= 0;
            id_ex_alusrc <= 0;
            id_ex_aluop <= 2'b00;
            id_ex_branch <= 1'b0;
            id_ex_jump <= 1'b0;
            id_ex_memread <= 1'b0;
            id_ex_memwrite <= 1'b0;
            id_ex_regwrite <= 1'b0;
            id_ex_memtoreg <= 1'b0;
            end
        else
            begin
            id_ex_next_pc <= if_id_next_pc;
            id_ex_reg_radata <= reg_radata;
            id_ex_reg_rbdata <= reg_rbdata;
            id_ex_imm_sext <= imm_sext;
            id_ex_opcode <= opcode;
            id_ex_func <= func;
            id_ex_rs <= rs;
            id_ex_rt <= rt;
            id_ex_rd <= rd;
            id_ex_jump_addr <= if_id_instruc[25:0];
            id_ex_regdst <= cu_regdst;
            id_ex_alusrc <= cu_alusrc;
            id_ex_aluop <= cu_aluop;
            id_ex_branch <= cu_branch;
            id_ex_jump <= cu_jump;
            id_ex_memread <= cu_dmemread;
            id_ex_memwrite <= cu_dmemwrite;
            id_ex_regwrite <= cu_regwrite;
            id_ex_memtoreg <= cu_memtoreg;
            end
    end


    //=================================
    //  Execute Stage
    //=================================
    assign imm_sext_sh2 = {id_ex_imm_sext[29:0], 2'b0};
    assign branch_target_pc = id_ex_next_pc + imm_sext_sh2;
    assign jump_target_pc = {id_ex_next_pc[31:28], id_ex_jump_addr, 2'b00};

    // We still won't branch until MEM stage but we can mux the
    // appropriate PC now to avoid ex/mem pipeline registers for
    // each different PC target
    always @*
    begin
    if (id_ex_branch)
      ex_mem_next_pc_d = branch_target_pc;
    else if (id_ex_jump)
      ex_mem_next_pc_d = jump_target_pc;
    else
      ex_mem_next_pc_d = id_ex_next_pc;
    end

    // TODO: Connect the signals to the forwarding unit
    ee457_FU fu	(
        .mem_regwrite(mem_wb_regwrite),
        .mem_wa(mem_wb_write_reg_id),
        .wb_regwrite(wb_regwrite),
        .wb_wa(wb_write_reg_id),
        .ex_ra(id_ex_rs),
        .ex_rb(id_ex_rt),
        .alu_sela(alu_sela),
        .alu_selb(alu_selb)
        
        // .mem_regwrite(ex_mem_regwrite),
        // .mem_wa(ex_mem_write_reg_id),
        // .wb_regwrite(mem_wb_regwrite),
        // .wb_wa(mem_wb_write_reg_id),
        // .ex_ra(reg_ra),
        // .ex_rb(reg_rb),
        // .alu_sela(alu_sela),
        // .alu_selb(alu_selb)
    );

    // Forwarding muxes - Should produce output signals: ina_fu, inb_fu
    always @*
    begin
        // TODO: Describe the forwarding muxes
        if (alu_sela == 2'b01)
            ina_fu = ex_mem_alu_result;
        else if (alu_sela == 2'b10)
            ina_fu = wb_alu_result;		
        else
            ina_fu = id_ex_reg_radata;

        // $display("ex_mem_alu_result: %d", ex_mem_alu_result);
        // $display("memtoreg: %d, reg_wdata: %d", memtoreg, wb_alu_result);
        // $display("id_ex_reg_radata: %d", id_ex_reg_radata);

        if (alu_selb == 2'b01)
            inb_fu = ex_mem_alu_result;
        else if (alu_selb == 2'b10)
            inb_fu = wb_alu_result;		
        else
            inb_fu = id_ex_reg_rbdata;

        // $display("SelA: %d, ina_fu: %d", alu_sela, ina_fu);
        // $display("SelB: %d, inb_fu: %d", alu_selb, id_ex_alusrc ? id_ex_imm_sext : inb_fu);
    end
        
    // ALU Control
    always @*
    begin
    if (id_ex_aluop == 2'b00)
      alu_func = FUNC_ADD;
    else if (id_ex_aluop == 2'b01)
      alu_func = FUNC_SUB;
    else
      alu_func = id_ex_func;
    end

    assign ina = ina_fu;
    assign inb = id_ex_alusrc ? id_ex_imm_sext : inb_fu;

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

    // Regdst mux
    assign ex_mem_write_reg_id_d = id_ex_regdst ? id_ex_rd : id_ex_rt;

    // EX/MEM Stage Register process
    always @(posedge clk)
    begin
        // TODO:  Update the next line
        if (rst == 1 || insert_bubble)
            begin
            ex_mem_next_pc <= 32'bX;
            ex_mem_opcode <= 6'b0;
            ex_mem_alu_result <= 32'bX;
            ex_mem_alu_zero <= 1'b0;
            ex_mem_write_reg_id <= 5'b0;
            ex_mem_branch <= 1'b0;
            ex_mem_jump <= 1'b0;
            ex_mem_regdst <= 1'b0;
            ex_mem_memread <= 1'b0;
            ex_mem_memwrite <= 1'b0;
            ex_mem_regwrite <= 1'b0;
            ex_mem_memtoreg <= 1'b0;
            // TODO:  One signal has been forgotten add it
            // here and assign it in the `else` section below
            ex_mem_reg_rbdata <= 32'bX;
            end
        else
            begin
            ex_mem_next_pc <= ex_mem_next_pc_d;
            ex_mem_opcode <= id_ex_opcode;
            ex_mem_alu_result <= alu_res;
            ex_mem_alu_zero <= zero;
            ex_mem_write_reg_id <= ex_mem_write_reg_id_d;
            ex_mem_branch <= id_ex_branch;
            ex_mem_jump <= id_ex_jump;
            ex_mem_regdst <= id_ex_regdst;
            ex_mem_memread <= id_ex_memread;
            ex_mem_memwrite <= id_ex_memwrite;
            ex_mem_regwrite <= id_ex_regwrite;
            ex_mem_memtoreg <= id_ex_memtoreg;
            // TODO:  Add the forgotten signal assignment
            ex_mem_reg_rbdata <= id_ex_reg_rbdata;
            end
    end

    //=================================
    //  Mem Stage
    //=================================

    // TODO: Produce the logic for branch_taken
    assign branch_taken = 
        cu_branch || 
        (ex_mem_branch && 
            (ex_mem_opcode == OP_BEQ && ex_mem_alu_zero || 
                ex_mem_opcode == OP_BNE && ~ex_mem_alu_zero));

    // TODO: Determine what signals to output to the data memory
    assign dmem_addr = ex_mem_alu_result;
    assign dmem_wdata = reg_rbdata;
    assign dmemread = ex_mem_memread;
    assign dmemwrite = ex_mem_memwrite;

    ee457_mem mem (
        .addr(dmem_addr[9:2]),
        .wdata(dmem_wdata),
        .memread(dmemread),
        .memwrite(dmemwrite),
        .clk(clk),
        .rdata(dmem_rdata)
        );

    // TODO: Add the MEM/WB pipeline register.  
    //       Consider what signals need to be registered 
    //       and which need to be initialized to 0 or 1 on rst
    //       versus signals that can be left as Xs
    // MEM/WB Stage Register process
    always @(posedge clk)
    begin
        if (rst == 1)
            begin
            // TODO: add appropriate signal initialization
            mem_wb_alu_result <= 32'bX;
            mem_wb_write_reg_id <= 5'b0;
            mem_wb_regdst <= 1'b0;
            mem_wb_regwrite <= 1'b0;
            mem_wb_memtoreg <= 1'b0;
            end
        else
            begin
            // TODO: add appropriate signal updates
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_dmem_rdata <= dmem_rdata;
            mem_wb_write_reg_id <= ex_mem_write_reg_id;
            mem_wb_regdst <= ex_mem_regdst;
            mem_wb_regwrite <= ex_mem_regwrite;
            mem_wb_memtoreg <= ex_mem_memtoreg;

            // $display("mem_wb_alu_result: %d", ex_mem_alu_result);
            // $display("dmem_rdata: %d", dmem_rdata);
            // $display("writeregId: %d", mem_wb_write_reg_id);
            end
    end
    
    //=================================
    //  WB Stage
    //=================================

    // TODO: implement the memtoreg mux using the appropriate signals
    always @(posedge clk)
    begin
        wb_alu_result <= mem_wb_alu_result;
        wb_dmem_rdata <= dmem_rdata;
        wb_regwrite <= mem_wb_regwrite;
        wb_write_reg_id <= mem_wb_write_reg_id;
        memtoreg <= ex_mem_memtoreg;
        regdst <= mem_wb_regdst;
    end      

endmodule

