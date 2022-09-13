`include "fir_filter.svh"


`ifndef SYNTHESIS

import fir_filter_pkg::*;
import i2c_pkg::*;

program fir_filter_test
  
  (input logic clk,
   input logic rst_n,

   inout tri1 scl_inout,
   inout tri1 sda_inout,

   output logic [DATABITS-1:0] data_in, 
   input logic data_valid_out,
   input logic [DATABITS-1:0] data_out
      
   );

   logic scl_read;
   logic scl_write;
   logic sda_read;
   logic sda_write;

   localparam real SIMULATION_LENGTH = 10000.0;

   // Connect read and write variables
   assign scl_read = scl_inout;
   assign scl_inout = scl_write;
   assign sda_read = sda_inout;
   assign sda_inout = sda_write;
   
   initial
     begin

      //1) drive all inputs into a known state
      sda_write = 'z;
      scl_write = 'z;

      //2) wait for rst_n to rise before fork statement     
      $info("T1");	      
      wait(rst_n);
      //3) wait for some more time
      #1us;
      @(posedge clk)

	fork
	   //i2c bus control block
	   begin
	      logic ack;
	      logic [7:0] tmp;
	      data_in = '0;  //is held at zero


	      $info("T2");  //send k8,k4,k2,k,k2,k4,k8
	      i2c_start_condition(scl_write, sda_write);
	      tmp = {I2C_ADDRESS, '0}; //address + write bit
	      i2c_write_byte(scl_write, sda_write, tmp);  
	      i2c_read_ack(scl_write, sda_read, ack);

	      tmp = K8[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);
	      tmp = K8[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);

	      tmp = K4[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);
	      tmp = K4[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);

	      tmp = K2[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);
	      tmp = K2[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack); 

	      tmp = K[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack); 
	      tmp = K[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);

	      tmp = K2[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack); 
	      tmp = K2[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);

	      tmp = K4[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);
	      tmp = K4[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack); 

	      tmp = K8[15:8];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);
	      tmp = K8[7:0];
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);

	      i2c_stop_condition(scl_write, sda_write);
	      
	      //5) add wait time
	      #1ms;

	   end

	   //the lower fork block
	   begin
	      const real pi = 3.14159265359;
	      real 	 angle;
	      logic signed [DATABITS-4:0] noise;
	      data_in = '0;
	      
	      //////////////////////////////////////////////////////////////
	      //
	      // Step
	      //
	      //////////////////////////////////////////////////////////////

	      @(posedge clk iff data_valid_out == '1)
		$info("T3"); 
	        data_in = '0;   

	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = '0;
		end

	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = L;
		end		
		

	      //////////////////////////////////////////////////////////////
	      //
	      // Negative Step
	      //
	      //////////////////////////////////////////////////////////////

	      @(posedge clk iff data_valid_out == '1)
		$info("T4");
		data_in = '0;
     
	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = '0;
		end

	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = -L;
		end

	      //////////////////////////////////////////////////////////////
	      //
	      // Impulse
	      //
	      //////////////////////////////////////////////////////////////
	      
	      @(posedge clk iff data_valid_out == '1)
		$info("T5");
		data_in = '0;
      
	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = '0;
		end

	      repeat (1) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = L;
		end

	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = 0;
		end

   
	      //////////////////////////////////////////////////////////////
	      //
	      // Negative Impulse
	      //
	      //////////////////////////////////////////////////////////////
	      
	      @(posedge clk iff data_valid_out == '1)
		$info("T6");
		data_in = '0;
     
	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = '0;
		end

	      repeat (1) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = -L;
		end

	      repeat (NTAPS) @(posedge clk iff data_valid_out == '1)
		begin
		  data_in = 0;
		end

	      //////////////////////////////////////////////////////////////
	      //
	      // Frequency Sweep
	      //
	      //////////////////////////////////////////////////////////////
	      
	      @(posedge clk iff data_valid_out == '1)
		$info("T7");
	      
	      forever
		begin
		   angle = 0.0;		
		   for (real sample = 0.0; sample < SIMULATION_LENGTH; sample += 1.0)
		     begin
			@(posedge clk iff data_valid_out == '1)
			  begin
			     data_in = ((2**(DATABITS-3))-1)*$sin(angle);
			     angle = angle + (sample/SIMULATION_LENGTH)*(pi/2.0);
			  end
		     end
		end

	      
	   end
	join_any

	$finish;

     end
   
   
endprogram
   
`endif
