module movavg(
    input logic clk,
    input logic reset,
    input logic [63:0] dinA,
    input logic [63:0] dinB,
    output logic [63:0] doutA,
    output logic [63:0] doutB
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
   
   logic [63:0] doutregA;
   logic [63:0] doutregB;
   
   always_comb begin
      doutregA   = dinA + dinB + tap1 + tap2;
      doutregB   = dinB + tap1 + tap2 + tap3;
      tap1_next = dinA;
      tap2_next = dinB;
      tap3_next = tap1;
   end

   assign doutA = doutregA;
   assign doutB = doutregB;

endmodule
