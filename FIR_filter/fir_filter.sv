`include "fir_filter.svh"
import fir_filter_pkg::*;

module fir_filter
  
  (input logic clk,
   input logic rst_n,

   inout tri scl_inout,
   inout tri sda_inout,

   input logic [DATABITS-1:0] data_in,
   output logic [DATABITS-1:0] data_out,
   output logic data_valid_out
   );

   logic 	       i2c_start;   
   logic 	       i2c_stop;   
   logic [NTAPS*16-1:0]  i2c_data;
   logic 	       i2c_valid;

   logic 	       ack;
   logic 	       filter_en;
   logic 	       load_en;   
   
   logic 	       srst_n;

   i2c_slave i2c_slave_1
      
     (
      .clk(clk),
      .rst_n(srst_n),
      .scl_inout(scl_inout),
      .sda_inout(sda_inout),
      .ack_in(ack),
      .start_out(i2c_start),
      .stop_out(i2c_stop),
      .data_out(i2c_data),
      .valid_out(i2c_valid)
      );

   control_unit control_unit_1
     (
      .clk(clk),
      .rst_n(srst_n),
      .i2c_byte_in(i2c_data[7:0]),
      .i2c_valid_in(i2c_valid),
      .i2c_start_in(i2c_start),      
      .i2c_stop_in(i2c_stop),      
      .ack_out(ack),
      .filter_en_out(filter_en),
      .load_en_out(load_en)
      );


   filter_unit filter_unit_1
     (
      .clk(clk),
      .rst_n(srst_n),
      .filter_en_in(filter_en),  
      .load_en_in(load_en),
      .coeffs_in(i2c_data), 
      .data_in(data_in),
      .data_out(data_out),
      .data_valid_out(data_valid_out)      
      );


   reset_sync reset_sync_1
     (
      .clk(clk),
      .rst_n(rst_n),
      .srst_n(srst_n)
      );
     
	
endmodule


