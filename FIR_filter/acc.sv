`include "fir_filter.svh"

import fir_filter_pkg::*;

module acc
  
  (input logic clk,
   input logic 		      rst_n,
   input logic [1:0] 	      ctrl_in,
   input logic [MULBITS-1:0]  mul_in,
   input logic [ACCBITS-1:0]  sum_in,
   output logic [ACCBITS-1:0] acc_out   
   );

   
   logic signed [ACCBITS-1:0] acc_r;

   always_ff @(posedge clk or negedge rst_n)
   begin : accu
     if(rst_n == '0)
	begin
	  acc_r <= '0;
	end
     else
	begin
	  case(ctrl_in)
	    MAC_NOP: acc_r <= acc_r;
	    MAC_LOAD: acc_r <= $signed(mul_in);
	    MAC_ACC: acc_r <= sum_in;
	    MAC_CLR: acc_r <= '0;
	  endcase
	end
   end : accu

   assign acc_out = acc_r;
   
endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module acc_tb  #(parameter DUT_VS_REF_SIMULATION = 0);

   // Testbench signals
   
   logic clk;
   logic rst_n;
   logic [1:0] ctrl_in;
   logic [MULBITS-1:0] mul_in;
   logic [ACCBITS-1:0] sum_in;
   logic [ACCBITS-1:0] acc_out;
   logic [ACCBITS-1:0] past_acc_out;   


   // DUT instantiation   
   acc DUT_INSTANCE (.*);

   // REF model instantiation
   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL

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

   // Data generator   
   initial
     begin
	$info("T0: RESET");
	rst_n = '0;	
	ctrl_in = MAC_NOP;
	mul_in = '0;
	sum_in = '0;

	@(negedge clk);
	rst_n = '0;
	@(negedge clk);
	rst_n = '1;

	@(negedge clk);
	$info("T1: LOAD K*L");

	mul_in = $signed(K) * $signed(L);
	sum_in = $signed(acc_out) + $signed(K) * $signed(L);
	ctrl_in = MAC_LOAD;

	@(negedge clk);
	assert (acc_out == mul_in)
	  else
	    $error("T1: acc_out value wrong");
	
	@(negedge clk);
	$info("T2: ACCUMULATE K2*L");

	mul_in = $signed(K2) * $signed(L);
	sum_in = $signed(acc_out) + $signed(K2) * $signed(L);
	ctrl_in = MAC_ACC;
	
	@(negedge clk);
	assert (acc_out == sum_in)
	  else
	    $error("T2: acc_out value wrong");
	
	@(negedge clk);	
	$info("T3: MAC_NOP");

	mul_in = '0;
	sum_in = '0;
	ctrl_in = MAC_NOP;
	past_acc_out = acc_out;
	@(negedge clk);
	assert (acc_out == past_acc_out)
	  else
	    $error("T3: acc_out value wrong");

	@(negedge clk);	
	$info("T4: MAC_CLR");

	mul_in = '1;
	sum_in = '1;
	ctrl_in = MAC_CLR;
	@(negedge clk);
	assert (acc_out == 0)
	  else
	    $error("T4: acc_out value wrong");
	

	@(negedge clk);
	$finish;
	

     end
endmodule

`endif

