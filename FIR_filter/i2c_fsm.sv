`include "fir_filter.svh"


import fir_filter_pkg::*;

module i2c_fsm
  
  (input logic clk,
   input logic rst_n,
   input logic start_in,
   input logic stop_in,
   input logic scl_rise_in,
   input logic scl_fall_in,
   input logic seven_in,
   output logic clr_out,   
   output logic shift_out,
   output logic valid_out,
   output logic oe_out
   );


   enum  logic [1:0] { IDLE = 2'b01, RX = 2'b11, VALID = 2'b10, ACK = 2'b00 } state_r, next_state;

   always_ff @(posedge clk or negedge rst_n)
     begin : i2c_fsm_reg
	if (rst_n == '0)
	  begin
	     state_r <= IDLE;
	  end
	else
	  begin
	     state_r <= next_state;
	  end
     end : i2c_fsm_reg


   always_comb
     begin : i2c_fsm
	shift_out = '0;
	clr_out = '0;
	oe_out = '0;
	valid_out = '0;
	next_state = IDLE;
	case(state_r)
	  IDLE:
	    begin
	      if(start_in == '1)
		next_state = RX;
	      else
		next_state = IDLE;	  
	    end
	  RX:
	    begin
	      if(stop_in == '1)
		begin
		  clr_out = '1;
		  next_state = IDLE;
		end
	      else if(scl_rise_in == '1)
		begin
		  shift_out = '1;
	      	  if(seven_in == '1)
		     next_state = VALID;
		  else
		     next_state = RX;
		end
	      else
		next_state = RX;	  
	    end
	  VALID: 
	    begin
	      valid_out = '1;
	      if(stop_in == '1)
		begin
		  clr_out = '1;
		  next_state = IDLE;
		end
	      else if(scl_fall_in == '1)
		next_state = ACK;
	      else
		next_state = VALID;	  
	    end
	  ACK:
	    begin
	      oe_out = '1;
	      if(stop_in == '1)
		begin
		  clr_out = '1;
		  next_state = IDLE;
		end
	      else if(scl_fall_in == '1)
		next_state = RX;
	      else
		next_state = ACK;			  
	    end
	endcase
     end : i2c_fsm

   
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
//
// Testbench
//
/////////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS

module i2c_fsm_tb  #(parameter DUT_VS_REF_SIMULATION = 0);
   
   logic clk;
   logic rst_n;
   logic tb_start_in;
   logic tb_stop_in;
   logic tb_scl_rise_in;
   logic tb_scl_fall_in;
   logic tb_seven_in;
   logic tb_clr_out;   
   logic tb_shift_out;
   logic tb_valid_out;
   logic tb_oe_out;
   
   // DUT instantiation

   i2c_fsm DUT_INSTANCE
     (.clk(clk),
      .rst_n(rst_n),
      .start_in(tb_start_in),
      .stop_in(tb_stop_in),
      .scl_rise_in(tb_scl_rise_in),
      .scl_fall_in(tb_scl_fall_in),
      .seven_in(tb_seven_in),
      .clr_out(tb_clr_out),
      .shift_out(tb_shift_out),
      .valid_out(tb_valid_out),
      .oe_out(tb_oe_out)
      );

   // REF model instantiation

   generate
      if (DUT_VS_REF_SIMULATION) begin : REF_MODEL
	 logic ref_clr_out;
	 logic ref_shift_out;
	 logic ref_valid_out;
	 logic ref_oe_out;	 	 	 
	 i2c_fsm REF_INSTANCE
	   (.clk(clk),
	    .rst_n(rst_n),
	    .start_in(tb_start_in),
	    .stop_in(tb_stop_in),
	    .scl_rise_in(tb_scl_rise_in),
	    .scl_fall_in(tb_scl_fall_in),
	    .seven_in(tb_seven_in),
	    .clr_out(ref_clr_out),
	    .shift_out(ref_shift_out),
	    .valid_out(ref_valid_out),
	    .oe_out(ref_oe_out)
	    );
      end 
   endgenerate
   
   // Clock generator process

   always
     begin
	if (clk == '0)
	  clk = '1;
	else
	  clk = '0;
	#5ns;
//	#(CLK_PERIOD/2);
     end

   // Data generator process
   
   initial
     begin
	rst_n = '1;
	tb_start_in = '0;
	tb_stop_in = '0;
	tb_scl_rise_in = '0;
	tb_scl_fall_in = '0;
	tb_seven_in = '0;				

	$info("T1");
	
	// Reset
	#10ns; // Wait for 100ns
	rst_n = '0;
	#10ns;
	rst_n = '1;

	$info("T2");	
	
	// IDLE => RX
	#30ns;
	tb_start_in = '1;
	#10ns;
	tb_start_in = '0;	

	// RX => IDLE
	#40ns;
	tb_stop_in = '1;
	#10ns;
	tb_stop_in = '0;	

	$info("T3");	
	
	// IDLE => RX
	#40ns;
	tb_start_in = '1;
	#10ns;
	tb_start_in = '0;
	
	// RX => RX
	#40ns;
	tb_scl_rise_in = '1;
	#10ns;
	tb_scl_rise_in = '0;
	
	// RX => IDLE
	#40ns;
	tb_stop_in = '1;
	#10ns;
	tb_stop_in = '0;

	$info("T4");	
	
	// IDLE => RX
	#40ns;
	tb_start_in = '1;
	#10ns;
	tb_start_in = '0;
	
	// RX => VALID
	#40ns;
	tb_scl_rise_in = '1;
	tb_seven_in = '1;
	#10ns;
	tb_scl_rise_in = '0;
	tb_seven_in = '0;
	
	// VALID => IDLE
	#40ns;
	tb_stop_in = '1;
	#10ns;
	tb_stop_in = '0;

	$info("T5");		
	
	// IDLE => RX
	#40ns;
	tb_start_in = '1;
	#10ns;
	tb_start_in = '0;
	
	// RX => VALID
	#40ns;
	tb_scl_rise_in = '1;
	tb_seven_in = '1;
	#10ns;
	tb_scl_rise_in = '0;
	tb_seven_in = '0;
	
	// VALID => ACK
	#40ns;
	tb_scl_fall_in = '1;
	#10ns;
	tb_scl_fall_in = '0;
	
	// ACK => IDLE
	#40ns;
	tb_stop_in = '1;
	#10ns;
	tb_stop_in = '0;

	$info("T6");		
	
	// IDLE => RX
	#40ns;
	tb_start_in = '1;
	#10ns;
	tb_start_in = '0;
	
	// RX => VALID
	#40ns;
	tb_scl_rise_in = '1;
	tb_seven_in = '1;
	#10ns;
	tb_scl_rise_in = '0;
	tb_seven_in = '0;
	
	// VALID => ACK
	#40ns;
	tb_scl_fall_in = '1;
	#10ns;
	tb_scl_fall_in = '0;
	
	// ACK => RX
	#40ns;
	tb_scl_fall_in = '1;
	#10ns;
	tb_scl_fall_in = '0;

	$info("T7");		
	
	// RESET
	#40ns;
	rst_n  = '0;
	#10ns;
	rst_n  = '1;

	#40ns;	
	$finish;
	
     end

endmodule

`endif
