`include "fir_filter.svh"


import fir_filter_pkg::*;

module reset_sync
  
  (input logic clk,
   input logic rst_n,
   output logic srst_n   
   );

   logic connect;

   always_ff @(posedge clk or negedge rst_n)
     begin : sync1
        if(rst_n == 0)
          connect <= 0;
	else
	  connect <= 1;
     end : sync1

   always_ff @(posedge clk or negedge rst_n)
     begin : sync2
        if(rst_n == 0)
          srst_n <= 0;
	else
	  srst_n <= connect;
     end : sync2

   
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module reset_sync_tb  #(parameter DUT_VS_REF_SIMULATION = 0);

   // Testbench signals
   
   logic clk;
   logic rst_n;
   logic srst_n;   

   // DUT instantiation   
   reset_sync DUT_INSTANCE (.*);

   // REF model instantiation
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_srst_n;
	 reset_sync REF_INSTANCE (.srst_n(ref_srst_n), .*);
      end 
   endgenerate

   initial
     begin
	clk = '0;
	rst_n = '1;
	#(CLK_PERIOD/2);

	$info("T1: ASYNC RESET");
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	#(CLK_PERIOD/4);	
	rst_n = '0;
	#(CLK_PERIOD/4);
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	#(CLK_PERIOD/4);		
	rst_n = '1;
	#(CLK_PERIOD/4);

	repeat(5)
	  begin
	     clk = '1;
	     #(CLK_PERIOD/2);
	     clk = '0;
	     #(CLK_PERIOD/2);
	  end


	$info("T2: RECOVERY VIOLATION");
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	rst_n = '0;
	#(CLK_PERIOD/2);
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	#(CLK_PERIOD/2-0.001ns);
	rst_n = '1;
	#(0.001ns)

	repeat(5)
	  begin
	     clk = '1;
	     #(CLK_PERIOD/2);
	     clk = '0;
	     #(CLK_PERIOD/2);
	  end

	$info("T2: REMOVAL VIOLATION");
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	rst_n = '0;
	#(CLK_PERIOD/2);
	clk = '1;
	#(CLK_PERIOD/2);
	clk = '0;
	#(CLK_PERIOD/2);
	clk = '1;	
	#(0.045ns)
	rst_n = '1;
	#(CLK_PERIOD/2-0.045ns);

	repeat(5)
	  begin
	     #(CLK_PERIOD/2);
	     clk = '0;
	     #(CLK_PERIOD/2);
	     clk = '1;

	  end
	
     end
endmodule // reset_sync_tb

`endif
