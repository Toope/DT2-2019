`include "fir_filter.svh"

import fir_filter_pkg::*;
import i2c_pkg::*;

program control_unit_test
  
  (input logic clk,
   input logic rst_n,

   output logic [7:0] i2c_byte_in,
   output logic i2c_valid_in,
   output logic i2c_start_in,   
   output logic i2c_stop_in,   

   input logic ack_out,
   input logic filter_en_out,
   input logic load_en_out   
   );


   initial
     begin
	//////////////////////////////////////////////////////////////////////
	//
	// T1
	//
	//////////////////////////////////////////////////////////////////////

	$info("T1: RESET");			
	i2c_byte_in = '0;
	i2c_valid_in = '0;
	i2c_start_in = '0;   
	i2c_stop_in = '0;   

	@(posedge rst_n);

	//////////////////////////////////////////////////////////////////////
	//
	// T2
	//
	//////////////////////////////////////////////////////////////////////

	$info("T2: START-STOP");			
      	@(negedge clk);
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	//////////////////////////////////////////////////////////////////////
	//
	// T3
	//
	//////////////////////////////////////////////////////////////////////
	
	$info("T3: HEADER ONLY");		
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { I2C_ADDRESS, 1'b0};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	@(negedge clk);
	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;
	@(negedge clk);

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	//////////////////////////////////////////////////////////////////////
	//
	// T4
	//
	//////////////////////////////////////////////////////////////////////

	$info("T4: PACKET");		
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { I2C_ADDRESS, 1'b0};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	for (int i = 1; i <= 2*NTAPS; ++i)
	  begin

	     i2c_byte_in = i;
	     i2c_valid_in = '1;
	     @(negedge clk);	  
	     
	     i2c_byte_in = '0;
	     i2c_valid_in = '0;

	     repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	       @(negedge clk);	  
	  end
	
	@(negedge clk);
	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;
	@(negedge clk);

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	//////////////////////////////////////////////////////////////////////
	//
	// T5
	//
	//////////////////////////////////////////////////////////////////////

	$info("T5: WRONG ADDERSS");		
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { 7'b0000000, 1'b0};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	for (int i = 1; i <= 2*NTAPS; ++i)
	  begin

	     i2c_byte_in = i;
	     i2c_valid_in = '1;
	     @(negedge clk);	  
	     
	     i2c_byte_in = '0;
	     i2c_valid_in = '0;

	     repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	       @(negedge clk);	  
	  end
	
	@(negedge clk);
	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;
	@(negedge clk);

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	//////////////////////////////////////////////////////////////////////
	//
	// T6
	//
	//////////////////////////////////////////////////////////////////////

	$info("T6: SHORT PACKET");		
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { I2C_ADDRESS, 1'b0};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	for (int i = 1; i <= NTAPS; ++i)
	  begin

	     i2c_byte_in = i;
	     i2c_valid_in = '1;
	     @(negedge clk);	  
	     
	     i2c_byte_in = '0;
	     i2c_valid_in = '0;

	     repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	       @(negedge clk);	  
	  end
	
	@(negedge clk);
	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;
	@(negedge clk);

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	

	//////////////////////////////////////////////////////////////////////
	//
	// T7
	//
	//////////////////////////////////////////////////////////////////////

	$info("T7: WRONG MODE");		
	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { I2C_ADDRESS, 1'b0};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	for (int i = 1; i <= 2*NTAPS; ++i)
	  begin

	     i2c_byte_in = i;
	     i2c_valid_in = '1;
	     @(negedge clk);	  
	     
	     i2c_byte_in = '0;
	     i2c_valid_in = '0;

	     repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	       @(negedge clk);	  
	  end
	
	@(negedge clk);
	i2c_stop_in = '1;
	@(negedge clk);
	i2c_stop_in = '0;
	@(negedge clk);

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	i2c_start_in = '1;
	@(negedge clk);
	i2c_start_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	
	i2c_byte_in = { I2C_ADDRESS, 1'b1};
	i2c_valid_in = '1;
	@(negedge clk);	  

	i2c_byte_in = '0;
	i2c_valid_in = '0;

	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  
	repeat(I2C_CLOCK_PERIOD/CLK_PERIOD)
	  @(negedge clk);	  

	$finish;
	
     end
   

endprogram
   

