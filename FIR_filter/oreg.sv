`include "fir_filter.svh"


import fir_filter_pkg::*;

 module oreg
  
  (input logic clk,
   input logic rst_n,
   input logic clr_in,   
   input logic ld_in,
   input logic [DATABITS-1:0] data_in,
   output logic [DATABITS-1:0] data_out,
   output logic data_valid_out
   );

   logic 	              data_valid_r;     
   logic [DATABITS-1:0]       oreg_r;

   always_ff @(posedge clk or negedge rst_n)
     begin : oreg_regs
	if (rst_n == '0)
	  begin
	     oreg_r <= '0;
	     data_valid_r <= '0; 
	  end
	else
	  begin
	     data_valid_r <= ld_in;	     
	     if (clr_in == '1)
	       oreg_r <= '0;
	     else if (ld_in == '1) 
	       oreg_r <= data_in;
	  end
     end : oreg_regs

   assign data_valid_out = data_valid_r;
   assign data_out = oreg_r;   
   
endmodule // oregs


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

//import i2c_pkg::*;

module oreg_tb #(parameter DUT_VS_REF_SIMULATION = 0);

   // Testbench signals
   logic clk;
   logic rst_n;
   logic clr_in;  
   logic ld_in;
   logic [DATABITS-1:0] data_in;
   logic [DATABITS-1:0] data_out;
   logic data_valid_out;

`pragma protect begin                  
   
   // To do: DUT instantiation   
   oreg DUT_INSTANCE (.*);

   // To do: REF model instantiation
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
        logic [DATABITS-1:0] ref_data_out;
        logic ref_data_valid_out;
	oreg REF_INSTANCE(.data_out(ref_data_out),
			       .data_valid_out(ref_data_valid_out),
			       .*);

      end 
   endgenerate

  // Done: Clock generator   
   always
     begin
	if (clk == '0)
	  clk = '1;
	else
	  clk = '0;
	#(CLK_PERIOD/2);
     end

   // To do:Data generator   
   initial
     begin
	clr_in = '1;
	ld_in = '1;
	data_in = '1;

	$info("T1: RESET");	
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);	
	rst_n = '1;
	@(negedge clk);
	#(CLK_PERIOD);  //voi olla I2C_CLOCK_PERIOD

	$info("T2: CLR_I FALL");		
	@(negedge clk);		
	clr_in = '0;
	#(CLK_PERIOD);

	$info("T3: LD_I FALL");		
	@(negedge clk);		
	ld_in = '0;
	#(CLK_PERIOD);	

	$info("T4: DATAIN FALL");
	@(negedge clk);		
	data_in = '0;
	#(CLK_PERIOD);

	$info("T5: CLR_I RISE");				
	@(negedge clk);		
	clr_in = '1;
	#(CLK_PERIOD);	

	$info("T6: LD_I RISE");				
	@(negedge clk);		
	ld_in = '1;
	#(CLK_PERIOD);	

	$info("T7: DATAIN RISE");				
	@(negedge clk);		
	data_in = '1;
	#(CLK_PERIOD);	
	
	
	$finish;
	
     end

`pragma protect end

endmodule

`endif
