module ps(input wire[63:0] a,
	  input wire  sync,
	  input wire  clk,
	  output wire as);
   
   reg [63:0] 	      ra;
   
   always @(posedge clk)
     if (sync)
       ra <= a;
     else
       ra <= {1'b0, ra[63:1]};
   
   assign as = ra[0];

endmodule // ps
