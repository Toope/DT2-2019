`include "fir_filter.svh"

import fir_filter_pkg::*;

module muladd
  
  (input logic [15:0] c_in,
   input logic [DATABITS-1:0] d_in,
   input logic [ACCBITS-1:0] acc_in,
   output logic [MULBITS-1:0] mul_out,
   output logic [ACCBITS-1:0] sum_out   
   );

   logic signed [MULBITS-1:0] multemp;
   logic signed [ACCBITS-1:0] acc_temp;
   logic signed [ACCBITS:0] sumtemp;
   logic signed [DATABITS-1:0] c_temp, d_temp;

   always_comb
     begin : mul
	c_temp = $signed(c_in);
	d_temp = $signed(d_in);
	multemp = c_temp * d_temp;
     end : mul

   always_comb
     begin : adder
	acc_temp = $signed(acc_in);
	sumtemp = multemp + acc_temp;
     end : adder

   assign mul_out = $unsigned(multemp);
   assign sum_out = $unsigned(sumtemp);

endmodule

   
/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module muladd_tb #(parameter DUT_VS_REF_SIMULATION = 0);
   logic [15:0] c_in;
   logic [DATABITS-1:0] d_in;
   logic [ACCBITS-1:0] 	acc_in;
   logic [MULBITS-1:0] 	mul_out;
   logic [ACCBITS-1:0] sum_out;

   muladd DUT_INSTANCE (.*);

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic [MULBITS-1:0] 	ref_mul_out;
	 logic [ACCBITS-1-2:0] 	ref_sum_out;

	 muladd REF_INSTANCE(.mul_out(ref_mul_out),
			     .sum_out(ref_sum_out),
			     .*);
      end 
   endgenerate
   
   
   initial
     begin
	c_in = '0;
	d_in = '0;
	acc_in = '0;

	#(CLK_PERIOD);
	$info("T1");
	c_in = K16;
	d_in = L;

	#(CLK_PERIOD);
	$info("T2");
	acc_in = sum_out;
	c_in = K8;

	#(CLK_PERIOD);
	$info("T3");
	acc_in = sum_out;
	c_in = K4;

	#(CLK_PERIOD);
	$info("T4");
	acc_in = sum_out;
	c_in = K2;

	#(CLK_PERIOD);
	$info("T5");
	acc_in = sum_out;
	c_in = K;

	#(CLK_PERIOD);	     	
	
	$finish;
	
     end
endmodule 


`endif
