`include "fir_filter.svh"

import fir_filter_pkg::*;

module sat
  (input  logic [ACCBITS-1:0] sat_in,
   output logic [DATABITS-1:0] sat_out);
   
   logic signed [ACCBITS-16:0] sat_temp;	
  
   always_comb
     begin : shorten
	sat_temp = $signed(sat_in) >> 15;  //get rid of decimals
	if($signed(sat_temp) < -32768)
	  sat_out = -32768;
	else if($signed(sat_temp) > 32767)
	  sat_out = 32767;
	else
	  sat_out = $signed(sat_temp[DATABITS-1:0]);  //range -32768 to 32767
     end : shorten
   
endmodule

   
/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module sat_tb #(parameter DUT_VS_REF_SIMULATION = 0);
   logic [ACCBITS-1:0] sat_in;
   logic [DATABITS-1:0] sat_out;

   sat DUT_INSTANCE (.*);

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic signed [DATABITS-1:0] ref_sat_out;

	 sat REF_INSTANCE(.sat_out(ref_sat_out),
			  .*);
      end 
   endgenerate
   
   
   initial
     begin
	logic signed [ACCBITS-1:0] longvalue;

	#(CLK_PERIOD);
	$info("T1 Zero");
	sat_in = '0;
	
	#(CLK_PERIOD);
	$info("T2 Positives");
	longvalue = 1;
	repeat(ACCBITS-1)
	  begin
	     sat_in = $unsigned(longvalue);
	     #(CLK_PERIOD);
	     longvalue = longvalue <<< 1;
	  end

	#(CLK_PERIOD);
	$info("T3 Negatives");
	
	longvalue = -1;
	repeat(ACCBITS)
	  begin
	     sat_in = $unsigned(longvalue);
	     #(CLK_PERIOD);
	     longvalue = longvalue <<< 1;
	  end
	
	#(CLK_PERIOD);	     		
	sat_in = '0;
	#(CLK_PERIOD);	     		
	
	$finish;
	
     end
endmodule 


`endif
