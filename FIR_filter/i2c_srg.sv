`include "fir_filter.svh"

import fir_filter_pkg::*;

module i2c_srg
  
  (input logic clk,
   input logic rst_n,
   input logic shift_in,
   input logic bit_in,
   output logic [NTAPS*16-1:0] data_out
   );

   logic [NTAPS*16-1:0] srg_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : srg
     if(rst_n == '0)
	begin
	  srg_r <= '0;
	end
     else
	begin
	  if(shift_in == '1)
	    srg_r <= {srg_r[NTAPS*16-2:0], bit_in};
	  else
	    srg_r <= srg_r;
	end
   end : srg

   assign data_out = srg_r;
  
endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module i2c_srg_tb #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   logic clr_in;
   logic shift_in;
   logic bit_in;
   logic [NTAPS*16-1:0] data_out;

   // DUT instantiation
   
   i2c_srg DUT_INSTANCE (.*);

   // REF model instantiation

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic [NTAPS*16-1:0] ref_data_out;
	 i2c_srg REF_INSTANCE(.data_out(ref_data_out), .*);
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
	shift_in = '0;
	clr_in = '0;
	bit_in = '0;
	@(negedge clk);
	@(negedge clk);	

	rst_n = '1;
	@(negedge clk);
	@(negedge clk);	

	$info("T2: IDLE");	
	bit_in = '1;
	@(negedge clk);
	@(negedge clk);	

	$info("T3: SHIFT8");	
	shift_in = '1;
	repeat(NTAPS*16)
	@(negedge clk);

	$info("T4: CLR");	
	clr_in = '1;
	@(negedge clk);
	@(negedge clk);	
	clr_in = '0;
	
	$finish;
	
     end
   
   
endmodule

`endif
