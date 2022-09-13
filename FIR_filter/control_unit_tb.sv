`include "fir_filter.svh"
/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS


import fir_filter_pkg::*;
import i2c_pkg::*;

module control_unit_tb #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   logic [7:0] i2c_byte_in;
   logic i2c_valid_in;
   logic i2c_start_in;   
   logic i2c_stop_in;   
   logic ack_out;
   logic filter_en_out;
   logic load_en_out;
   
   // DUT model instantiation   
  control_unit DUT_INSTANCE (.*);
  control_unit_test TEST (.*);   

   // REF model instantiation
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_ack_out;
	 logic ref_filter_en_out;
	 logic ref_logic_en_out;	 
	 
	 control_unit DUT_INSTANCE (.ack_out(ref_ack_out),
				    .filter_en_out(ref_filter_en_out),
				    .load_en_out(ref_load_en_out),				    
				    .*);	 
      end 
   endgenerate

   // Clock generator   
   always
     begin
	if (clk == '0)
	  clk = '1;
	else
	  clk = '0;
	#(CLK_PERIOD/2);
     end

   // Reset generator
   initial
     begin
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);	
	rst_n = '1;
     end
   
endmodule

`endif //  `ifndef SYNTHESIS
