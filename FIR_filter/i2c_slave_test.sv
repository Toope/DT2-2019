`include "fir_filter.svh"


import fir_filter_pkg::*;
import i2c_pkg::*;

program i2c_slave_test
  
  (input logic clk,
   input logic rst_n,

   inout tri1 scl_inout,
   inout tri1 sda_inout,
   output logic ack_in,
   input logic stop_out,
   input logic [NTAPS*16-1:0] data_out,
   input logic valid_out
   );

   logic scl_read;
   logic scl_write;
   logic sda_read;
   logic sda_write;

   // Connect read and write variables
   assign scl_read = scl_inout;
   assign scl_inout = scl_write;
   assign sda_read = sda_inout;
   assign sda_inout = sda_write;
   
   initial
     begin
	logic [7:0] tx_byte;
	fork
	   begin

	      // This fork thread drives the I2C bus

	      logic ack;
	      logic [7:0] tmp;

	      sda_write = 'z;
	      scl_write = 'z;

	      // Start action exactly on clock edge to test synchronizer
	      #1us;
	      @(posedge clk);
	      $info("T1");
	      i2c_start_condition(scl_write, sda_write);
	      i2c_write_byte(scl_write, sda_write, tmp);
	      i2c_read_ack(scl_write, sda_read, ack);  //
	      i2c_stop_condition(scl_write, sda_write);

	      $info("T2");  //send k8,k4,k2,k,k2,k4,k8
	      i2c_start_condition(scl_write, sda_write);
	      tmp = {I2C_ADDRESS, sda_write}; //address + write bit
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

	      $info("T3");
	      i2c_start_condition(scl_write, sda_write);
	      tmp = {I2C_ADDRESS, sda_write};
	      i2c_write_byte(scl_write, sda_write, tmp);

	      tmp = 8'b00000001; 
	      i2c_write_bit(scl_write, sda_write, tmp[7]);	      
	      i2c_write_bit(scl_write, sda_write, tmp[6]);
	      i2c_write_bit(scl_write, sda_write, tmp[5]);
	      i2c_write_bit(scl_write, sda_write, tmp[4]);

	      i2c_stop_condition(scl_write, sda_write);

	      #100us;
	   end
	   begin

	      // This fork thread 'listens' to the data outputs	

	      ack_in = '0;
	      forever
		begin
		   @(posedge clk iff valid_out == '1)
		     begin
			if (data_out[7:0] != tx_byte)
			  $error("TX FAILED");			  
		     end
		end
	   end

	join_any
	$finish;

     end
   
   
endprogram

