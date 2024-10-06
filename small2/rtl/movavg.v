module movavg(input wire         clk,
	      input wire 	 reset,
	      input wire [63:0]  din,
	      output wire [63:0] dout);

   reg [63:0] 			  tap1, tap1_next;
   reg [63:0] 			  tap2, tap2_next;
   reg [63:0] 			  tap3, tap3_next;

   reg [5:0] 			  ctr, ctr_next;

   always @(posedge clk)
     begin
	if (reset)
	  begin
	     tap1 <= 64'h0;
	     tap2 <= 64'h0;
	     tap3 <= 64'h0;
	     ctr <= 5'd0;
	  end
	else
	  begin
	     tap1 <= tap1_next;
	     tap2 <= tap2_next;
	     tap3 <= tap3_next;
	     ctr  <= ctr_next;	     
	  end
     end // always @ (posedge clk)

   // controller
   reg ctl0, ctl1, ctl2, ctl3, ctl4;
   always @(*)
     begin
	ctr_next = ctr + 6'b1;
	ctl0 = (ctr == 6'd0);
	ctl1 = (ctr == 6'd1);
	ctl2 = (ctr == 6'd2);
	ctl3 = (ctr == 6'd3);
	ctl4 = (ctr == 6'd4);
     end
   
   // first stage: parallel to serial conversion
   wire din_s;
   ps stage1(.a(din), .sync(ctl0), .clk(clk), .as(din_s));

   // second stage: delay line
   always @(*)
     begin
	tap1_next = {din_s, tap1[63:1]};
	tap2_next = {tap1[0], tap2[63:1]};
	tap3_next = {tap2[0], tap3[63:1]};	
     end

   // third stage: first set of adders
   wire a1_s, a2_s;   
   serialadd a1(.a(din_s),    .b(tap1[0]), .s(a1_s), .sync(ctl1), .clk(clk));
   serialadd a2(.a(tap2[0]),  .b(tap3[0]), .s(a2_s), .sync(ctl1), .clk(clk));

   // fourth stage: second adder
   wire a3_s;
   serialadd a3(.a(a1_s), .b(a2_s), .s(a3_s), .sync(ctl2), .clk(clk));

   // final stage: s/p converter
   sp stage9(.as(a3_s), .sync(ctl3), .clk(clk), .a(dout));

endmodule



