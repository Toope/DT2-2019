`include "fir_filter.svh"

import fir_filter_pkg::*;

module i2c_slave
  
  (input logic clk,
   input logic rst_n,
   inout tri scl_inout,
   inout tri sda_inout,
   input logic ack_in,

   output logic start_out,
   output logic stop_out,
   output logic [NTAPS*16-1:0] data_out,
   output logic valid_out
   );

   logic 	scl;
   logic 	sda;
   logic 	past_scl;
   logic 	past_sda;
   logic 	start;
   logic 	stop;
   logic 	scl_rise;
   logic 	scl_fall;
   logic 	oe;
   logic 	clr;
   logic 	shift;
   logic 	seven;

   i2c_sync i2c_sync_1 
     (
	.clk(clk),
	.rst_n(rst_n),
	.scl_in(scl_inout),
	.sda_in(sda_inout),
	.scl_out(scl),
	.sda_out(sda),
	.past_scl_out(past_scl),
	.past_sda_out(past_sda)
      );
   
   i2c_detector i2c_detector_1
     (
	.scl_in(scl),
	.sda_in(sda),
	.past_scl_in(past_scl),
	.past_sda_in(past_sda),
	.start_out(start),
	.stop_out(stop),
	.scl_rise_out(scl_rise),
	.scl_fall_out(scl_fall)
      );

   assign start_out = start;
   assign stop_out = stop;
   
   i2c_ctr3 i2c_ctr3_1 
     (
	.clk(clk),
	.rst_n(rst_n),
	.clr_in(clr),
	.count_in(shift),
	.seven_out(seven)
      );
   
   i2c_srg i2c_srg_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.shift_in(shift),
	.bit_in(sda),
	.data_out(data_out)
      );
   
   i2c_fsm i2c_fsm_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.start_in(start),
	.stop_in(stop),
	.scl_rise_in(scl_rise),
	.scl_fall_in(scl_fall),
	.seven_in(seven),
	.oe_out(oe),
	.valid_out(valid_out),
	.clr_out(clr),
	.shift_out(shift)
      );


   assign sda_inout = ((oe == '1) ? ( (ack_in == '1) ? 'z : '0) : 'z);

endmodule // i2c_slave


