`include "fir_filter.svh"


import fir_filter_pkg::*;

module dregs
  
  (input logic clk,
   input logic rst_n,
   input logic clr_in,
   input logic dwe_in,
   input logic [FADDRBITS-1:0] faddr_in,
   input logic [DATABITS-1:0] data_in,
   output logic [DATABITS-1:0] data_out
   );

   logic [NTAPS-1:0][DATABITS-1:0] dregs_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : dregs_bank
     if(rst_n == '0)
	begin
	  dregs_r <= '0;
	end
     else
	begin
	  if(clr_in == '1)
	    dregs_r <= '0;
	  else if(dwe_in == 1)
	    begin
	      dregs_r[0] <= data_in;
	      for(int i = (NTAPS-1); i > 0; i--)
	        dregs_r[i] <= dregs_r[i-1];
	    end
	end
   end : dregs_bank

   always_comb
   begin : dregs_mux
     if(faddr_in < NTAPS)
	data_out = dregs_r[faddr_in];
     else
	data_out = '0; 
   end : dregs_mux

endmodule

/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module dregs_tb  #(parameter DUT_VS_REF_SIMULATION = 0);

   // Testbench signals
   logic clk;
   logic rst_n;
   logic clr_in;
   logic dwe_in;
   logic [$clog2(NTAPS)-1:0] faddr_in;
   logic [DATABITS-1:0] data_in;
   logic [DATABITS-1:0] data_out;

   dregs DUT_INSTANCE (.*);

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
	dwe_in = '0;
	clr_in = '0;
	faddr_in = '0;
	

	data_in[DATABITS-1:0] = 7;
	
	@(negedge clk);

	rst_n = '1;

	$info("T2: LOAD");	

	dwe_in = '1;
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
        data_in[DATABITS-1:0] = 8;
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);
	dwe_in = '0;
	@(negedge clk);

	$info("T3: MUX");	
	
	for(int i=0; i < 2**FADDRBITS; ++i)
	  begin
	     @(negedge clk);	     
	     faddr_in = i;
	  end

	$info("T4: CLR");

	clr_in = '1;
	@(negedge clk);

	clr_in = '0;
	@(negedge clk);


	$finish;
	
     end
   
endmodule

`endif
