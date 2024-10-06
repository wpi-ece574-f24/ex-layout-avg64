`timescale 1ns/1ps

// The Data Introduction Interval (DII) specifies the number of clock cycles
// between successive data inputs.
`define DII 1

// The Latency specifies the number of clock cycles between the entry of the first
// input, and the first output.
`define LATENCY 63

// The CLOCKPERIOD defines the number of time units in a clock period
`define CLOCKPERIOD 10

module tb;
   
   reg clk, reset;
   
   always
     begin
	clk = 1'b0;
	#(`CLOCKPERIOD/2);
	clk = 1'b1;
	#(`CLOCKPERIOD/2);
     end
   
   initial
     begin
	reset = 1'b1;
	#(`CLOCKPERIOD);	
	reset = 1'b0;
     end
   
`ifdef USE_SDF
   initial
     begin
	$sdf_annotate("../layout/synout/movavg_delays.sdf",tb.DUT,,"sdf.log","MAXIMUM");
     end
`endif
   
   reg [63:0] din, snapdout, expdout, prev_expdout;
   wire [63:0] dout;
   
   movavg DUT(.clk(clk),
	      .reset(reset),
	      .din(din),
	      .dout(dout));
   
   reg [63:0]  chk_in;
   reg [63:0]  chk_tap1;
   reg [63:0]  chk_tap2;
   reg [63:0]  chk_tap3;
   
   integer     n;
   
   initial
     begin	
	$dumpfile("trace.vcd");
	$dumpvars(0, tb);
	
	#(`CLOCKPERIOD/2); // reset delay
	
	chk_in   = 64'b0;
	chk_tap1 = 64'b0;
	chk_tap2 = 64'b0;
	chk_tap3 = 64'b0;
	prev_expdout = 64'd0;
	
	for (n=0; n < 1024; n = n + 1)
          begin
	     
	     din[31: 0] = $random;
	     din[63:32] = $random;

	     chk_tap3 = chk_tap2;
	     chk_tap2 = chk_tap1;
	     chk_tap1 = chk_in;
	     chk_in   = din;

	     // the testbench will check the *previous* data output
	     // because it takes 64 cycles (+ latency) before a
	     // bitserial result is converted back to bitparallel
	     
	     prev_expdout = expdout;	     
	     expdout  = chk_in+chk_tap1+chk_tap2+chk_tap3;
	     
	     repeat (4) @(posedge clk);
	     snapdout = dout;
			
	     repeat (`LATENCY - 4) @(posedge clk);

	     #(`CLOCKPERIOD - 1);
	     	     
	     $display("%d din %x dout %x exp %x OK %d",
		      n,
		      din, 
		      snapdout, 
		      prev_expdout, 
		      snapdout == prev_expdout);

	     @(posedge clk);
	  end
	
	$finish;
	
     end
   
endmodule
