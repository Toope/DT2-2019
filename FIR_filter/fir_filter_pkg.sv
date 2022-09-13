`include "fir_filter.svh"

package fir_filter_pkg;

   // Design localparams

   localparam int NTAPS = 7;
   localparam int DATABITS = 16;
   localparam logic [6:0] I2C_ADDRESS = 7'b1111000;

   localparam int MULBITS = 32;  
   localparam int ACCBITS = 38;  
   localparam int FADDRBITS = $clog2(NTAPS);

   localparam logic [15:0] K         = 16'b00100000_10101001;
   localparam logic [15:0] K2        = 16'b11101111_10101100;
   localparam logic [15:0] K4        = 16'b00001000_00101010;
   localparam logic [15:0] K8        = 16'b11111011_11101011;
   localparam logic [15:0] K16       = 16'b00000010_00001010;
   localparam logic [DATABITS-1:0] L = 16'b00111111_11101110;  
   
   localparam logic [1:0] MAC_NOP = 2'b00;
   localparam logic [1:0] MAC_LOAD = 2'b01;
   localparam logic [1:0] MAC_ACC = 2'b10;      
   localparam logic [1:0] MAC_CLR = 2'b11;      

   // Simulation localparams
   
`ifndef SYNTHESIS

   //clock period
   localparam real CLK_PERIOD = 6.0;         
   
`endif
   
endpackage
