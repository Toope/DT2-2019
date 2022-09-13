`include "fir_filter.svh"

`ifndef SYNTHESIS

//`define SIMPLE_VERSION 1

import fir_filter_pkg::*;
import i2c_pkg::*;

module i2c_slave_tb  #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   tri1 	 scl_inout;
   tri1 	 sda_inout;
   logic ack_in;
   logic start_out;
   logic stop_out;
   logic [NTAPS*16-1:0] data_out;
   
   logic       valid_out;

   // DUT instantiation
   i2c_slave DUT_INSTANCE (.*);

`ifdef RTL_SIM
   // Bind assertion module   
   bind i2c_slave i2c_slave_svamod SVA_i2c_slave (.*);
 `endif
 
   // Clock generator
   always
     begin
	if (clk == '0)
	  clk = '1;
	else
	  clk = '0;
	#(CLK_PERIOD/2.0);
     end
   
   // Reset generator
   initial
     begin
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);	
	rst_n = '1;
     end

   /////////////////////////////////////////////////////////////////////////////////
   //
   // Simple test data generator
   //
   /////////////////////////////////////////////////////////////////////////////////

 `ifdef SIMPLE_VERSION
   
   logic scl_out;
   logic sda_out;
   
   assign scl_inout = scl_out;
   assign sda_inout = sda_out;   
   
   initial
     begin
	logic [7:0] tx_byte;

	tx_byte = { I2C_ADDRESS, 1'b0 };

	fork
	   begin

	      // This fork thread drives the I2C bus
	      
	      scl_out = 'z;
	      sda_out = 'z;

	      // Start action exactly on clock edge to test synchronizer
	      #1us;
	      @(posedge clk);
	      
	      
	      // START
	      $info("I2C START");
	      
	      sda_out = '0;
	      #(I2C_CLOCK_PERIOD/2.0);
	      scl_out = '0;
	      
	      $info("TX BYTE");	
	      
	      for (int i = 7; i >= 0; --i)
		begin
		   if (tx_byte[i] == '1)
		     sda_out = 'z;
		   else
		     sda_out = '0;	       
		   #(I2C_CLOCK_PERIOD/2.0);
		   scl_out = 'z;
		   #(I2C_CLOCK_PERIOD/2.0);
		   scl_out = '0;	     
		end
	      
	      $info("ACK");
	      sda_out = 'z;
	      
	      #(I2C_CLOCK_PERIOD/2.0);
	      scl_out = 'z;
	      assert(sda_inout == '0)
		else
		  $error("ACK != '0");
	      
	      #(I2C_CLOCK_PERIOD/2.0);	
	      $info("I2C STOP");
	      scl_out = '0;
	      sda_out = '0;		
	      #(I2C_CLOCK_PERIOD/2.0);
	      scl_out = 'z;
	      #(I2C_CLOCK_PERIOD/2.0);
	      sda_out = 'z;		
	      #(I2C_CLOCK_PERIOD/2.0);
	   end 
	   begin

	      // This fork thread 'listens' to the data outputs	

	      ack_in = '0;
	      forever
		begin
		   @(posedge clk iff valid_out == '1)
		     begin
			if (data_out[7:0] != tx_byte)
			  $error("TX FAILED (wrong value at data_out[7:0])");			  
		     end
		end
	   end
	join_any
	
	$finish;	
     end

   /////////////////////////////////////////////////////////////////////////////////
   //
   // A6 part: Test program and reference model instantiation
   //
   /////////////////////////////////////////////////////////////////////////////////
   
`else
   i2c_slave_test TEST (.*);   
`endif
   
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 tri1 	 ref_scl_inout;
	 tri1 	 ref_sda_inout;
	 logic 	 ref_ack_in;
	 logic 	 ref_start_out;
	 logic 	 ref_stop_out;
	 logic [NTAPS*16-1:0] ref_data_out;
	 logic 		      ref_valid_out;

	 i2c_slave REF_INSTANCE(.clk(clk),
				.rst_n(rst_n),
				.scl_inout(ref_scl_inout),
				.sda_inout(ref_sda_inout),
				.ack_in(ref_ack_in),
				.start_out(ref_start_out),
				.stop_out(ref_stop_out),				
				.data_out(ref_data_out),
				.valid_out(ref_valid_out)
				);
	 
	 i2c_slave_test REF_TEST (.clk(clk),
				  .rst_n(rst_n),
				  .scl_inout(ref_scl_inout),
				  .sda_inout(ref_sda_inout),
				  .ack_in(ref_ack_in),
				  .stop_out(ref_stop_out),
				  .data_out(ref_data_out),
				  .valid_out(ref_valid_out)
				  );


	 always @(posedge clk)
	   begin : checker_proc
	      assert(stop_out == ref_stop_out)
		else $warning("stop_out values differ.");
	      assert(valid_out == ref_valid_out)
		else $warning("valid_out values differ.");
	      assert(data_out == ref_data_out)
		else $warning("data_out values differ.");
	   end : checker_proc

      end 
   endgenerate
   

   

   
endmodule

`endif
