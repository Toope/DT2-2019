`include "fir_filter.svh"


import fir_filter_pkg::*;


module cregs
  (input logic clk,
   input logic rst_n,
   input logic load_en_in,
   input logic [NTAPS*16-1:0] coeffs_in,
   input logic [FADDRBITS-1:0] faddr_in,
   output logic [15:0] coeff_out
   );

   logic [NTAPS-1:0][15:0] cregs_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : cregs_bank
     if(rst_n == '0)
	begin
	  cregs_r <= '0;
	end
     else
	begin
	  if(load_en_in == '1)
	    cregs_r <= coeffs_in;
	end
   end : cregs_bank

   always_comb
   begin : coeff_mux
     if(faddr_in < NTAPS)
	coeff_out = cregs_r[faddr_in];
     else
	coeff_out = '0; 
   end : coeff_mux

   
endmodule



/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module cregs_tb  #(parameter DUT_VS_REF_SIMULATION = 0);

   logic clk;
   logic rst_n;
   logic load_en_in;
   logic [NTAPS*16-1:0] coeffs_in;
   logic [FADDRBITS-1:0] 	 faddr_in;
   logic [15:0] 		 coeff_out;

   cregs DUT_INSTANCE (.*);

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
	load_en_in = '0;
	faddr_in = '0;
	
	for(int i=0; i < NTAPS; ++i)
	  begin
	     coeffs_in[i*16 +: 16] = i+1;
	  end
	
	@(negedge clk);

	rst_n = '1;

	$info("T2: LOAD");	

	load_en_in = '1;
	@(negedge clk);

	load_en_in = '0;
	@(negedge clk);

	$info("T3: MUXTEST");	
	
	for(int i=0; i < 2**FADDRBITS; ++i)
	  begin
	     @(negedge clk);	     
	     faddr_in = i;
	  end

	$finish;
	
     end
   
endmodule

`endif
