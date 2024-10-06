module movavg(
    input logic clk,
    input logic reset,
    input logic [63:0] din,
    output logic [63:0] dout
);

   logic [63:0] 	tap1, tap1_next;
   logic [63:0] 	tap2, tap2_next;
   logic [63:0] 	tap3, tap3_next;

   always_ff @(posedge clk) begin
      if (reset) begin
         tap1 <= 64'h0;
         tap2 <= 64'h0;
         tap3 <= 64'h0;
      end else begin
         tap1 <= tap1_next;
         tap2 <= tap2_next;
         tap3 <= tap3_next;
      end 
   end
   
   logic [63:0] doutreg;
   
   always_comb begin
      doutreg   = din + tap1 + tap2 + tap3;
      tap1_next = din;
      tap2_next = tap1;
      tap3_next = tap2;
   end

   assign dout = doutreg;

endmodule
