`include "fir_filter.svh"


import fir_filter_pkg::*;

module i2c_ctr3
  
  (input logic clk,
   input logic rst_n,
   input logic clr_in,
   input logic count_in,
   output logic seven_out
   );

   logic [2:0] ctr3_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : ctr3
     if(rst_n == '0)
	begin
	  ctr3_r <= '0;
	end
     else
	begin
	  if(clr_in == '1)
	    ctr3_r <= 0;
	  else if(count_in == '1)
	    ctr3_r <= 3'(ctr3_r + 1);
	  else
	    ctr3_r <= ctr3_r;
	end
     end : ctr3


   always_comb
   begin : ctr3_decode
     if(ctr3_r == 7)
	seven_out = 1;
     else
	seven_out = 0;
   end : ctr3_decode

   
endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module i2c_ctr3_tb #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   logic clr_in;
   logic count_in;
   logic seven_out;
   
   i2c_ctr3 DUT_INSTANCE (.*);

      // REF model instantiation

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_seven_out;
	 i2c_ctr3 REF_INSTANCE(.seven_out(ref_seven_out), .*);
      end 
   endgenerate

   always
     begin
	if (clk == '0)
	  clk = '1;
	else
	  clk = '0;
	#(CLK_PERIOD/2);
     end

   initial
     begin
	$info("T1: RESET");	
	rst_n = '0;
	clr_in = '0;
	count_in = '0;
	@(negedge clk);
	rst_n = '1;
	@(negedge clk);

	$info("T1: IDLE");			
	@(negedge clk);
	@(negedge clk);	
	
	$info("T2: COUNT12");		
	count_in = '1;	
	repeat(12)
	  @(negedge clk);	  

	$info("T3: CLR");		
	clr_in = '1;	
	@(negedge clk);
	@(negedge clk);	

	$finish;
	
     end
   
   
endmodule


`endif
