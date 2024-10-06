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

   logic [63:0] dinA;
   logic [63:0] doutA;
   logic [63:0] dinB;
   logic [63:0] doutB;

   movavg DUT(.clk(clk),
              .reset(reset),
              .dinA(dinA),
              .dinB(dinB),
              .doutA(doutA),
              .doutB(doutB)
	      );

   logic [63:0] chk_tap4;
   logic [63:0] chk_tap3;
   logic [63:0] chk_tap2;
   logic [63:0] chk_tap1;
   logic [63:0] chk_dinA;
   logic [63:0] chk_doutA;
   logic [63:0] chk_dinB;
   logic [63:0] chk_doutB;
   
   initial
     begin
	reset = 1'b1;
	@(negedge clk);
	reset = 1'b0;
	chk_tap1 = 0;
	chk_tap2 = 0;
	chk_tap3 = 0;
	dinA     = 0;
	dinB     = 0;
	
	@(posedge clk);
	
	while (1)
	  begin

	     #1; // making sure we assign new inputs just after the clock edge
	     
	     dinA[31:0]  = $random;
	     dinA[63:32] = $random;

	     dinB[31:0]  = $random;
	     dinB[63:32] = $random;

	     chk_dinB = dinB;
	     chk_dinA = dinA;

	     #(`CLOCKPERIOD - 1);

	     chk_doutA = chk_dinA + chk_dinB + chk_tap1 + chk_tap2;
	     chk_doutB = chk_dinB + chk_tap1 + chk_tap2 + chk_tap3;
	     
	     $display("A %t out %h expected %h OK %d", $time, doutA, chk_doutA, doutA == chk_doutA);
	     $display("B %t out %h expected %h OK %d", $time, doutB, chk_doutB, doutB == chk_doutB);
	     // $display("%t DUT in %h taps %h %h %h",  $time, DUT.din, DUT.tap1, DUT.tap2, DUT.tap3);
	     // $display("%t CHK in %h taps %h %h %h",  $time, chk_din, chk_tap1, chk_tap2, chk_tap3);
	     
	     chk_tap3 = chk_tap1;
	     chk_tap2 = chk_dinB;
	     chk_tap1 = chk_dinA;
		       
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
