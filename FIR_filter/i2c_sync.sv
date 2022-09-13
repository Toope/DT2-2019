`include "fir_filter.svh"

import fir_filter_pkg::*;

module i2c_sync
  
  (input logic clk,
   input logic rst_n,

   input logic sda_in,   
   input logic scl_in,

   output logic sda_out,
   output logic scl_out,

   output logic past_sda_out,
   output logic past_scl_out
   );


   logic scl_sff1_r;
   logic scl_sff2_r;
   logic sda_sff1_r;
   logic sda_sff2_r;
   logic past_scl_r;
   logic past_sda_r;

   always_ff @(posedge clk or negedge rst_n)  
   begin : sync_ffs
     if(rst_n == '0)
	begin
	  scl_sff1_r <= '1;
	  scl_sff2_r <= '1;
	  sda_sff1_r <= '1;
	  sda_sff2_r <= '1;
	end
     else
	begin
	  scl_sff1_r <= scl_in;
	  scl_sff2_r <= scl_sff1_r;
	  sda_sff1_r <= sda_in;
	  sda_sff2_r <= sda_sff1_r;
	end
   end : sync_ffs

   assign sda_out = sda_sff2_r;
   assign scl_out = scl_sff2_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : edgedet_ffs
     if(rst_n == '0)
	begin
	  past_scl_r <= '1;
	  past_sda_r <= '1;
	end
     else
	begin
	  past_scl_r <= scl_sff2_r;
	  past_sda_r <= sda_sff2_r;
	end
   end : edgedet_ffs


   assign past_scl_out = past_scl_r;
   assign past_sda_out = past_sda_r;



   
endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

import i2c_pkg::*;

module i2c_sync_tb #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   logic sda_in;   
   logic scl_in;
   logic sda_out;
   logic scl_out;
   logic past_sda_out;
   logic past_scl_out;
   
   i2c_sync DUT_INSTANCE (.*);

   // REF model instantiation

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_sda_out;
	 logic ref_scl_out;
	 logic ref_past_sda_out;
	 logic ref_past_scl_out;
	 i2c_sync REF_INSTANCE(.sda_out(ref_sda_out),
			       .scl_out(ref_scl_out),
			       .past_sda_out(ref_past_sda_out),
			       .past_scl_out(ref_past_scl_out),
			       .*);
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
	sda_in = '1;
	scl_in = '1;

	$info("T1: RESET");	
	rst_n = '0;
	@(negedge clk);
	rst_n = '1;
	#(I2C_CLOCK_PERIOD);

	// T2 - T5: I2C signals change on clk rising edge
	
	$info("T2: SDA FALL VIOL");		
	@(posedge clk);		
	sda_in = '0;
	#(I2C_CLOCK_PERIOD);

	$info("T3: SCL FALL VIOL");		
	@(posedge clk);		
	scl_in = '0;
	#(I2C_CLOCK_PERIOD);	

	$info("T4: SDA RISE VIOL");
	@(posedge clk);		
	sda_in = '1;
	#(I2C_CLOCK_PERIOD);

	$info("T5: SCL RISE VIOL");				
	@(posedge clk);		
	scl_in = '1;
	#(I2C_CLOCK_PERIOD);	

	// T6 - T9: I2C signals change on clk falling edge

	$info("T6: SDA FALL");		
	@(negedge clk);		
	sda_in = '0;
	#(I2C_CLOCK_PERIOD);

	$info("T7: SCL FALL");		
	@(negedge clk);		
	scl_in = '0;
	#(I2C_CLOCK_PERIOD);	

	$info("T8: SDA RISE");
	@(negedge clk);		
	sda_in = '1;
	#(I2C_CLOCK_PERIOD);

	$info("T9: SCL RISE");				
	@(negedge clk);		
	scl_in = '1;
	#(I2C_CLOCK_PERIOD);	
	
	$finish;
	
     end
   
   
endmodule


`endif
