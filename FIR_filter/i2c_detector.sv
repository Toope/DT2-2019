`include "fir_filter.svh"


import fir_filter_pkg::*;

module i2c_detector
  (
   input logic sda_in,
   input logic scl_in,
   input logic past_sda_in,
   input logic past_scl_in,

   output logic start_out,
   output logic stop_out,
   output logic scl_rise_out,
   output logic scl_fall_out
   );

always_comb
   begin
      if(scl_in == '1 && past_scl_in == '1 && sda_in == '0 && past_sda_in == '1)
	start_out = '1;
      else
	start_out = '0;
      if(scl_in == '1 && past_scl_in == '1 && sda_in == '1 && past_sda_in == '0)
	stop_out = '1;
      else
	stop_out = '0;
      if(scl_in == '1 && past_scl_in == '0)
	scl_rise_out = '1;
      else
	scl_rise_out = '0;
      if(scl_in == '0 && past_scl_in == '1)
	scl_fall_out = '1;
      else
	scl_fall_out = '0;
   end


endmodule

/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module i2c_detector_tb  #(parameter DUT_VS_REF_SIMULATION = 0); 
   logic sda_in;
   logic scl_in;
   logic past_scl_in;
   logic past_sda_in;
   logic start_out;
   logic stop_out;
   logic scl_rise_out;
   logic scl_fall_out;
   
   i2c_detector DUT_INSTANCE (.*);

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_start_out;
	 logic ref_stop_out;
	 logic ref_scl_rise_out;
	 logic ref_scl_fall_out;
	 i2c_sync REF_INSTANCE(.start_out(ref_start_out),
			       .stop_out(ref_stop_out),
			       .scl_rise_out(ref_scl_rise_out),
			       .scl_fall_out(ref_scl_fall_out),
			       .*);
      end 
   endgenerate
   
   initial
     begin
	scl_in = '1;
	past_scl_in = '1;
	sda_in = '1;
	past_sda_in = '1;
	#100ns;
	$info("T1: START");
	sda_in = '0;
	#50ns;
	past_sda_in = '0;	
	scl_in = '0;
	#50ns;
	$info("T2: SCL RISE");
	past_scl_in = '0;	
	scl_in = '1;
	#50ns;
	$info("T3: SCL FALL");	
	past_scl_in = '1;		
	scl_in = '0;
	#50ns;
	past_scl_in = '0;			
	scl_in = '1;
	#50ns;
	$info("T4: STOP");	
	past_scl_in = '1;					
	sda_in = '1;
	#50ns;
	past_sda_in = '1;	
     end
   
   
endmodule


`endif

