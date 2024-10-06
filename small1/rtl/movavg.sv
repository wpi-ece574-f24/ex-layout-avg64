module movavg(input logic 	  clk,
	      input logic 	  reset,
	      input logic [63:0]  din,
	      output logic [63:0] dout,
	      output logic 	  read
	      );

   typedef enum 	logic [3:0] {
				     S0 = 4'b0000,
				     S1 = 4'b0001,
				     S2 = 4'b0010,
				     S3 = 4'b0011,
				     S4 = 4'b0100
				     } state_t;
   
   logic [63:0]  tap1, tap1_next;
   logic [63:0]  tap2, tap2_next;
   logic [63:0]  tap3, tap3_next;

   state_t state, state_next;
   logic [63:0]  acc, acc_next;

   always_ff @(posedge clk)
     begin
        if (reset)
          begin
             tap1 <= 64'h0;
             tap2 <= 64'h0;
             tap3 <= 64'h0;
             acc  <= 64'h0;
             state <= S0;
          end
        else
          begin
             tap1  <= tap1_next;
             tap2  <= tap2_next;
             tap3  <= tap3_next;
             acc   <= acc_next;
             state <= state_next;
          end
     end
   
   logic [63:0] doutreg;
   logic 	readreg;
   
   always @(*)
     begin
	state_next = state;
	acc_next   = acc;
	tap1_next  = tap1;
	tap2_next  = tap2;
	tap3_next  = tap3;
	doutreg    = 64'h0;
	readreg    = 1'b0;	
        case (state)
          S0:
            begin
               acc_next   = din;
	       readreg    = 1'b1;
               state_next = S1;
            end
          S1:
            begin
               acc_next   = acc + tap1;
               state_next = S2;
            end
          S2:
            begin
               acc_next   = acc + tap2;
               state_next = S3;
            end
          S3:
            begin
               acc_next   = acc + tap3;
               state_next = S4;
            end
          S4:
            begin
               doutreg    = acc;
               tap1_next  = din;
               tap2_next  = tap1;
               tap3_next  = tap2;
               state_next = S0;
            end
          default:
            state_next = S0;
        endcase
     end

   assign dout = doutreg;
   assign read = readreg;
   
endmodule
