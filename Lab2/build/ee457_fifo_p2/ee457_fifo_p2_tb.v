`timescale 1ns / 1ps

module fifo_tb;
  localparam WIDTH = 8;
  localparam DEPTH = 4;
  wire   full, empty;
  reg    clk, rst, ren, wen;
  reg [WIDTH-1:0] din;
  wire [WIDTH-1:0] dout;
  integer i;
  ee457_fifo #(WIDTH, DEPTH) fifo(clk, rst, din, wen, full, dout, ren, empty);
  
  
  always #5 clk = ~clk;

  initial
    
  begin
    clk = 1;
    rst = 1;
    ren = 0;
    wen = 0;
    din = 1;
    # 15;
    rst = 0;
    # 7;
    for (i = 0; i < DEPTH; i = i + 1)
    begin
      din = din + 1;
      wen = 1;
      # 10;
    end
    for (i = 0; i < 2; i = i + 1)
    begin
      din = din + 1;
      wen = 1;
      ren = 1;
      # 10;
    end
    din = din + 1;
    wen = 1;
    ren = 1;
    # 10;    
    wen = 0;
    din = din + 1;
    ren = 1;
    # 10;    
    for (i = 0 ; i < DEPTH - 1; i = i + 1)
    begin
      ren = 1;
      # 10;
    end
    din = din + 1;
    wen = 1;
    ren = 1;
    # 10;
    wen = 0;
    # 10;    
    ren = 1;
    # 10;
    ren = 0;
    #20;
    
  end

endmodule