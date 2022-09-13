`include "fir_filter.svh"


import fir_filter_pkg::*;

module control_unit
  
  (input logic clk,
   input logic rst_n,

   input logic [7:0] i2c_byte_in,
   input logic i2c_valid_in,
   input logic i2c_start_in,   
   input logic i2c_stop_in,   

   output logic ack_out,
   output logic filter_en_out,
   output logic load_en_out   
   );

   logic [3:0] count;
   logic count_en, count_signal, count_res, flag_r;


   enum logic [2:0] {IDLE, WAIT_HEADER, WAIT_DOWN, WAIT_UP, INC, STOP} state_r, next_state;

   always_ff @(posedge clk or negedge rst_n)
     begin : control_unit_reg
	if(rst_n == 0)
	  state_r <= IDLE;
	else
	  state_r <= next_state;
     end : control_unit_reg

   always_ff @(posedge clk or negedge rst_n) 
     begin : flag_reg
	if(rst_n == 0)
	  flag_r <= '0;
	else
          flag_r <= filter_en_out;
     end : flag_reg

   always_comb
     begin : control_unit
 	ack_out = 0;          //1 in IDLE
	load_en_out = 0;
	filter_en_out = flag_r; 
	count_res = 0;
	count_en = 0;
	next_state = IDLE;
	case(state_r)
	  IDLE:
	    begin
	      ack_out = '1;
	      count_res = '1;
	      if(i2c_start_in == '1)
		next_state = WAIT_HEADER;
	      else
		next_state = IDLE;
	    end
	  WAIT_HEADER:
	    begin
	      ack_out = '1;
	      if(i2c_stop_in == '1)
		next_state = IDLE;
	      else if(i2c_valid_in == '1)
	        begin
		if(i2c_byte_in[7:1] == I2C_ADDRESS)	//check address
		  begin
		  if(i2c_byte_in[0] == 0)  //write = 0
		    begin
		      ack_out = 0;
		      next_state = WAIT_DOWN;  //right address
		    end
		  else
		    begin
		    //disable filter_en_in
		    filter_en_out = 0;
		    next_state = IDLE;    //wrong address
		    end
		  end
	        end
	      else
		begin
		  next_state = WAIT_HEADER;
		end
	    end
	  WAIT_DOWN:
	    begin
	      ack_out = '0;
	      if(i2c_stop_in == '1)
		next_state = IDLE;
	      else if(i2c_valid_in == '0)
		next_state = WAIT_UP;
	      else
		begin
		  next_state = WAIT_DOWN;
		end
	    end
	  WAIT_UP:
	    begin
	      ack_out = '0;
	      if(i2c_stop_in == '1)
		next_state = IDLE;
	      else if(i2c_valid_in == '1)
		begin
		  count_en = 1;
		  next_state = INC;
		end
	      else
		begin
		  next_state = WAIT_UP;
		end
	    end
	  INC:
	    begin
	      if(i2c_stop_in == '1)
	        next_state = IDLE;
	      else if(i2c_valid_in == '0)
		begin
		  if(count_signal == '1)
		    begin
		    load_en_out = '1;
		    //enable filter_en_in
		    filter_en_out = '1;
		    ack_out = '0;      
		    next_state = STOP;
		    end
		  else
		    next_state = WAIT_DOWN;
		end
	      else
		begin
		  next_state = INC;
		end
	    end
	  STOP:
	    begin
	      count_res = 1;          //reset counter
	      ack_out = '1; 
	      if(i2c_stop_in == '1)
		next_state = IDLE;
	      else
		next_state = STOP;
	    end
	  default
	    next_state = IDLE;
	endcase
     end : control_unit

   always_ff @(posedge clk or negedge rst_n)
   begin : counter
     if(rst_n == '0)
	begin
	  count <= '0;
	end
     else
	begin
	  if(count_res == '1)
	    count <= '0;
	  else if(count_en == '1)
	    begin
	      count <= 4'(count + 1);
	    end
	  else
	    count <= count;
	end
     end : counter


   always_comb
   begin : counter_signal
     if(count == 2*NTAPS)
	count_signal = 1;
     else
	count_signal = 0;
   end : counter_signal
  
   
endmodule


