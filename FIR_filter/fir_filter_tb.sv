`include "fir_filter.svh"
///////////////////////////////////////////////////////////////
//
// Testbench
//
//
///////////////////////////////////////////////////////////////  

`pragma protect begin                  
`pragma protect end



`ifndef SYNTHESIS

import fir_filter_pkg::*;

module fir_filter_tb #(parameter DUT_VS_REF_SIMULATION = 0);
   
   logic clk;
   logic rst_n;
   tri1 	 scl_inout;
   tri1 	 sda_inout;
   logic [DATABITS-1:0] data_in;
   logic 	data_valid_out;
   logic [DATABITS-1:0] data_out;

   initial
     begin
	clk = '0;
	forever #(CLK_PERIOD/2) clk = ~clk;
     end

   
   initial
     begin
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);	
	rst_n = '1;
     end

   // DUT instantiation
   fir_filter DUT_INSTANCE
     (.clk(clk),
      .rst_n(rst_n),
      .scl_inout(scl_inout),
      .sda_inout(sda_inout),

      .data_in(data_in),
      .data_valid_out(data_valid_out),
      .data_out(data_out)
      );

   // Assertion module binding file inclusion
`ifdef RTL_SIM
`include "fir_filter_svabind.svh"   
`endif 
   

   // Test program instantiation
   fir_filter_test TEST
     (.clk(clk),
      .rst_n(rst_n),
      .scl_inout(scl_inout),
      .sda_inout(sda_inout),

      .data_in(data_in),
      .data_valid_out(data_valid_out),
      .data_out(data_out)

      );
   
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL

	 tri1 ref_scl_inout;
	 tri1 	 ref_sda_inout;
	 logic [DATABITS-1:0] ref_data_in;
	 logic 	      ref_data_valid_out;
	 logic [DATABITS-1:0] ref_data_out;
	 
	 
	 fir_filter REF_INSTANCE
	   (.clk(clk),
	    .rst_n(rst_n),
	    .scl_inout(ref_scl_inout),
	    .sda_inout(ref_sda_inout),
	    
	    .data_in(ref_data_in),
	    .data_valid_out(ref_data_valid_out),
	    .data_out(ref_data_out)
	       );

	 fir_filter_test REF_TEST
	   (.clk(clk),
	    .rst_n(rst_n),
	    .scl_inout(ref_scl_inout),
	    .sda_inout(ref_sda_inout),

	    .data_in(ref_data_in),
	    .data_valid_out(ref_data_valid_out),
	    .data_out(ref_data_out)
	    );
	 
	 always @(posedge clk)
	   begin : checker_proc
	      assert(data_valid_out == ref_data_valid_out)
		else $warning("data_valid_out values differ.");
	      assert(data_out == ref_data_out)
		else $warning("data_out values differ.");
	   end : checker_proc

      end 
   endgenerate
   
      


endmodule 



`endif
