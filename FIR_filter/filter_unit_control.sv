`include "fir_filter.svh"
import fir_filter_pkg::*;

module filter_unit_control
  
  (input logic clk,
   input logic rst_n,
   input logic filter_en_in,
   output logic clr_out,
   output logic dwe_out,
   output logic [FADDRBITS-1:0] faddr_out,
   output logic [1:0] mctrl_out,
   output logic oload_out

   );

   enum logic [3:0] {STOPPED = 4'b0000, READ = 4'b0001, TAP0 = 4'b0010, TAP1 = 4'b0011, TAP2 = 4'b0100, TAP3 = 4'b0101, TAP4 = 4'b0110, TAP5 = 4'b0111, TAPN_READ = 4'b1000} state_r, next_state; 

   always_ff @(posedge clk or negedge rst_n)
     begin : filter_unit_reg
	if(rst_n == 0)
	  state_r <= STOPPED;
	else
	  state_r <= next_state;
     end : filter_unit_reg

   always_comb
     begin : filter_unit_fsm
	dwe_out = 0;
	faddr_out = 0;
	mctrl_out = MAC_NOP;
	clr_out = 0;
	oload_out = 0;
	next_state = STOPPED; 
	case(state_r)
	  STOPPED:
	    begin
	      clr_out = 1;
	      mctrl_out = MAC_CLR;    //should be cleared here
	      if(filter_en_in == '1)
		  next_state = READ;
	      else
		next_state = STOPPED;
	    end
	  READ:
	    begin
	      dwe_out = 1;
	      if(filter_en_in == '1)
		  next_state = TAP0;
	      else
		next_state = STOPPED;
	    end
	  TAP0:
	    begin
	      mctrl_out = MAC_LOAD;
	      if(filter_en_in == '1)
		  next_state = TAP1;
	      else
		next_state = STOPPED;
	    end
	  TAP1:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = 1;
	      if(filter_en_in == '1)
		  next_state = TAP2;
	      else
		next_state = STOPPED;
	    end
	  TAP2:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = 2;
	      if(filter_en_in == '1)
		  next_state = TAP3;
	      else
		next_state = STOPPED;
	    end
	  TAP3:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = 3;
	      if(filter_en_in == '1)
		  next_state = TAP4;
	      else
		next_state = STOPPED;
	    end
	  TAP4:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = 4;
	      if(filter_en_in == '1)
		  next_state = TAP5;
	      else
		next_state = STOPPED;
	    end
	  TAP5:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = 5;
	      if(filter_en_in == '1)
		  next_state = TAPN_READ;
	      else
		next_state = STOPPED;
	    end
	  TAPN_READ:
	    begin
	      mctrl_out = MAC_ACC;
	      faddr_out = NTAPS-1;
	      dwe_out = 1;              //for reading
	      oload_out = 1;            //set oload
	      if(filter_en_in == '1)
		  next_state = TAP0;       
	      else
		next_state = STOPPED;
	    end
	  default
	    next_state = STOPPED;
	endcase

     end : filter_unit_fsm

   
endmodule


/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module filter_unit_control_tb #(parameter DUT_VS_REF_SIMULATION = 0);
   logic clk;
   logic rst_n;
   logic filter_en_in;
   logic clr_out;
   logic dwe_out;
   logic [FADDRBITS-1:0] faddr_out;
   logic [1:0] mctrl_out;
   logic oload_out;
   
   filter_unit_control DUT_INSTANCE (.*);

      // REF model instantiation

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_clr_out;
	 logic dwe_out;
	 logic [FADDRBITS-1:0] ref_faddr_out;
	 logic [1:0] 	       ref_mctrl_out;
	 logic 		       ref_oload_out;
	 filter_unit_control REF_INSTANCE(.clr_out(ref_clr_out),
					  .dwe_out(ref_dwe_out),
					  .faddr_out(ref_faddr_out),
					  .mcrtl_out(ref_mctrl_out),
					  .oload_out(oload_out),
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
	$info("T1: RESET");	
	rst_n = '0;
	filter_en_in = '0;
	@(negedge clk);
	rst_n = '1;
	@(negedge clk);

	$info("T1: IDLE");			
	@(negedge clk);
	@(negedge clk);	
	
	$info("T2: FILTER");		
	filter_en_in = '1;	
	repeat(3*NTAPS)
	  @(negedge clk);	  

	@(negedge clk);
	@(negedge clk);	
	
	$info("T3: STOP");		
	filter_en_in = '0;
	
	@(negedge clk);
	@(negedge clk);
	@(negedge clk);	
	@(negedge clk);		

	$finish;
	
     end
   
   
endmodule


`endif
