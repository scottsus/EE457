
module ee457_fifo(clk, rst, din, wen, full, dout, ren, empty);
  
  function integer log2;
    input integer n;
    integer i;
    begin
      for(i=0; 2**i < n; i=i+1)
      begin
      end
      log2 = i+1;    
    end
  endfunction

  parameter           WIDTH = 8;
  parameter           DEPTH = 4;
  localparam          ADDR_SIZE = log2(DEPTH);
  
  input               clk;
  input               rst;
  input [WIDTH-1:0]   din;
  input               wen;
  input               ren;
  output [WIDTH-1:0]  dout;
  output              full;
  output              empty;
  
  reg [WIDTH-1:0]     mem_array[0:DEPTH-1];

  reg [ADDR_SIZE-1:0] rptr;
  reg [ADDR_SIZE-1:0] wptr;
  
  // Add other signal declarations here
  
  
  begin
    // always output whatever item the read pointer indicates
    assign dout = mem_array[rptr];

    // Write your code here    



  
  end
endmodule
  