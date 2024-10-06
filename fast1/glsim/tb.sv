`timescale 1ns/1ps
`define CLOCKPERIOD 10

module tb;
   logic clk, reset;

   always
     begin
       clk = 1'b0;
       #(`CLOCKPERIOD/2);
       clk = 1'b1;
       #(`CLOCKPERIOD/2);
     end

   logic [63:0] din;
   logic [63:0] dout;

   movavg DUT(.clk(clk),
              .reset(reset),
              .din(din),
              .dout(dout)
	      );

   logic [63:0] chk_tap3;
   logic [63:0] chk_tap2;
   logic [63:0] chk_tap1;
   logic [63:0] chk_din;
   logic [63:0] chk_dout;
   logic [63:0] p_chk_dout;
   logic [63:0] pp_chk_dout;
   
`ifdef USE_SDF
   initial
     begin
	$sdf_annotate("../layout/synout/movavg_delays.sdf",tb.DUT,,"sdf.log","MAXIMUM");
     end
`endif

   initial
     begin
	reset = 1'b1;
	@(negedge clk);
	reset = 1'b0;
	chk_tap1 = 0;
	chk_tap2 = 0;
	chk_tap3 = 0;
	din      = 0;
	
	@(posedge clk);
	
	while (1)
	  begin

	     #1; // making sure we assign new inputs just after the clock edge
	     
	     din[31:0]  = $random;
	     din[63:32] = $random;

	     chk_din = din;

	     #(`CLOCKPERIOD - 1);
	     
	     // This delay ensures the tested output matches the pipelined output (2 pipe stages)
	     pp_chk_dout = p_chk_dout;	     
	     p_chk_dout = chk_dout;	     
	     chk_dout = chk_din + chk_tap3 + chk_tap2 + chk_tap1;
	     
	     $display("%t out %h expected %h OK %d", $time, dout, pp_chk_dout, dout == pp_chk_dout);
	     $display("%t CHK in %h taps %h %h %h -> %h",  $time, chk_din, chk_tap1, chk_tap2, chk_tap3, chk_dout);
	     
	     chk_tap3 = chk_tap2;
	     chk_tap2 = chk_tap1;
	     chk_tap1 = chk_din;
	     @(posedge clk);
	     
	  end
     end
   
   initial
     begin
	repeat(256)
	  @(posedge clk);
	$finish;
     end

endmodule
