module sp(input wire as,
	  input wire 	     sync,
	  input wire 	     clk,
	  output wire [63:0] a);
   
   reg [63:0] 		     ra;
   
   always  @(posedge clk)
     ra <= {as, ra[63:1]};
   
   assign a  = sync ? ra : 8'b0;
   
endmodule // sp
