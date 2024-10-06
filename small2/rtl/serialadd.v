module serialadd(input wire a, input wire b, output wire s,
                 input wire sync, input wire clk);   
   reg 			    carry, q;
   
   always @(posedge clk)
     if (sync)
       begin
          carry <= a & b;
          q     <= a ^ b;
       end
     else
       begin
          q     <= a ^ b ^ carry;
          carry <= (a & b) | (b & carry) | (carry & a);
       end
   
   assign s = q;
   
endmodule
