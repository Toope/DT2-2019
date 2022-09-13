`include "fir_filter.svh"


import fir_filter_pkg::*;

module filter_unit
  
  (input logic clk,
   input logic 		       rst_n,
   input logic 		       filter_en_in,
   input logic 		       load_en_in, 
   input logic [NTAPS*16-1:0]  coeffs_in,
   input logic [DATABITS-1:0]  data_in,
   output logic [DATABITS-1:0] data_out,
   output logic 	       data_valid_out
   );
 
   logic			oload;
   logic [1:0]			mctrl;
   logic			clr;
   logic			dwe;
   logic [FADDRBITS-1:0]	faddr;
   logic [15:0]			coeff;
   logic [DATABITS-1:0]		data;
   logic [MULBITS-1:0]		mul;
   logic [ACCBITS-1:0]		sum;
   logic [ACCBITS-1:0]		acc;
   logic [DATABITS-1:0]		filtered;

   
   filter_unit_control filter_unit_control_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.filter_en_in(filter_en_in),
	.oload_out(oload),
	.mctrl_out(mctrl),
	.clr_out(clr),
	.dwe_out(dwe),
	.faddr_out(faddr)
      );

   cregs cregs_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.load_en_in(load_en_in),
	.faddr_in(faddr),
	.coeffs_in(coeffs_in),
	.coeff_out(coeff)
      );

   dregs dregs_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.clr_in(clr),
	.dwe_in(dwe),
	.faddr_in(faddr),
	.data_in(data_in),
	.data_out(data)
      );

   muladd muladd_1
     (
	.c_in(coeff),
	.d_in(data),
	.acc_in(acc),
	.mul_out(mul),
	.sum_out(sum)
      );
   
   acc acc_1 
     (
	.clk(clk),
	.rst_n(rst_n),
	.ctrl_in(mctrl),
	.mul_in(mul),
	.sum_in(sum),
	.acc_out(acc)
      );

   sat sat_1 
     (
	.sat_in(acc),
	.sat_out(filtered)
      );
   
   oreg oreg_1
     (
	.clk(clk),
	.rst_n(rst_n),
	.ld_in(oload),
	.clr_in(clr),
	.data_in(filtered),
	.data_valid_out(data_valid_out),
	.data_out(data_out)
      );



endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module filter_unit_tb  #(parameter DUT_VS_REF_SIMULATION = 0);
   
   // Testbench signals
   logic clk;
   logic rst_n;
   logic clr_in;
   logic filter_en_in;
   logic load_en_in;   
   logic [NTAPS-1:0][15:0] coeffs_in;
   logic [DATABITS-1:0] data_in;
   logic [DATABITS-1:0] data_out;
   logic 		data_valid_out;
   
   // DUT instantiation
   filter_unit DUT_INSTANCE (.*);

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic [DATABITS-1:0] ref_data_out;
	 logic 		      ref_data_valid_out;
	 filter_unit REF_INSTANCE(.data_out(ref_data_out),
			       .data_valid_out(ref_data_valid_out),
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
   
   // Data generator
   initial
     begin

	coeffs_in = { K8, K4, K2, K, K2, K4, K8 };  //my NTAPS = 7
	
	data_in = '0;
	filter_en_in = '0;
	load_en_in = '0;
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);	
	rst_n = '1;
	@(negedge clk);

	/////////////////////////////////////////////////////////
	// T1: Load coefficients
	/////////////////////////////////////////////////////////	

	$info("T1: Load coefficients");
	
	load_en_in = '1;
	@(negedge clk);
	load_en_in = '0;	
	@(negedge clk);
	
	/////////////////////////////////////////////////////////
	// T2: Run filter
	/////////////////////////////////////////////////////////	

	$info("T2: Run filter");

	data_in = L;	
	filter_en_in = '1;
	@(negedge clk);	

	repeat (2*NTAPS+4)
	  begin
	     @(negedge clk);	
	  end

	/////////////////////////////////////////////////////////
	// T3: Stop filter
	/////////////////////////////////////////////////////////	
	
	$info("T3: Stop filter");
	
	@(negedge clk);	
	filter_en_in = '0;

	repeat (2*NTAPS)
	  begin
	     @(negedge clk);	
	  end
	
	$finish;
	
     end

   
endmodule

`endif
