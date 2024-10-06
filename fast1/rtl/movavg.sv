module movavg(
    input logic clk,
    input logic reset,
    input logic [63:0] din,
    output logic [63:0] dout
);

   logic [63:0] 	tap1, tap1_next;
   logic [63:0] 	tap2, tap2_next;
   logic [63:0] 	tap3, tap3_next;

   logic [63:0]         pipe1a, pipe1a_next;
   logic [63:0] 	pipe1b, pipe1b_next;
   logic [63:0] 	pipe1c, pipe1c_next;
   logic [63:0] 	pipe2a, pipe2a_next;
   logic [63:0]         pipe2b, pipe2b_next;

   always_ff @(posedge clk) begin
      if (reset) begin
         tap1 <= 64'h0;
         tap2 <= 64'h0;
         tap3 <= 64'h0;
         pipe1a <= 64'h0;
         pipe1b <= 64'h0;
         pipe1c <= 64'h0;
         pipe2a <= 64'h0;
         pipe2b <= 64'h0;
      end else begin
         tap1 <= tap1_next;
         tap2 <= tap2_next;
         tap3 <= tap3_next;
         pipe1a <= pipe1a_next;
         pipe1b <= pipe1b_next;
         pipe1c <= pipe1c_next;
         pipe2a <= pipe2a_next;
         pipe2b <= pipe2b_next;
      end 
   end
   
   logic [63:0] doutreg;
   
   always_comb begin
      pipe1a_next = din + tap1;
      pipe1b_next = tap2;
      pipe1c_next = tap3;
      pipe2a_next = pipe1a + pipe1b;
      pipe2b_next = pipe1c;
      doutreg     = pipe2a + pipe2b;
      tap1_next   = din;
      tap2_next   = tap1;
      tap3_next   = tap2;
   end

   assign dout = doutreg;

endmodule
