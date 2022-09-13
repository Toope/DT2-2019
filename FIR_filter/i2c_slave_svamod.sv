`include "fir_filter.svh"

import fir_filter_pkg::*;

module i2c_slave_svamod
  
  (input logic clk,
   input logic 		      rst_n,
   inout tri 		      scl_inout,
   inout tri 		      sda_inout,
   input logic 		      ack_in,
   input logic 		      start_out,
   input logic 		      stop_out,
   input logic [NTAPS*16-1:0] data_out,
   input logic 		      valid_out,
   input logic 		      scl,
   input logic 		      sda,
   input logic 		      past_scl,
   input logic 		      past_sda,
   input logic 		      start,
   input logic 		      stop,
   input logic 		      scl_rise,
   input logic 		      scl_fall,
   input logic 		      oe,
   input logic 		      clr,
   input logic 		      shift,
   input logic 		      seven
   );
      
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(start_out))
     else $error("i2c_slave port start_out is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(stop_out))
     else $error("i2c_slave port stop_out is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(data_out))
     else $error("i2c_slave port data_out is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(valid_out))
     else $error("i2c_slave port valid_out is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(scl))
     else $error("i2c_slave variable scl is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(sda))
     else $error("i2c_slave variable sda is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(past_scl))
     else $error("i2c_slave variable past_scl is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(start))
     else $error("i2c_slave variable start is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(stop))
     else $error("i2c_slave variable stop is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(scl_rise))
     else $error("i2c_slave variable scl_rise is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(scl_fall))
     else $error("i2c_slave variable scl_fall is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(oe))
     else $error("i2c_slave variable oe is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(clr))
     else $error("i2c_slave variable scl is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(scl))
     else $error("i2c_slave variable clr is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(shift))
     else $error("i2c_slave variable shift is unknown");
   assert property ( @(posedge clk) disable iff (rst_n !== '1) !$isunknown(seven))
     else $error("i2c_slave variable seven is unknown");

   ////////////////////////////////////////////////////////////////////////////////////////
   // i2c_sync
   ////////////////////////////////////////////////////////////////////////////////////////

/*   // sda
   
   property p_sda;
     @(posedge clk ) disable iff (rst_n == '0)
       sda_inout === '1 |=> ##1 sda;
   endproperty

   a_sda: assert property(p_sda)
     else $error("i2c_slave signal sda did not follow sda_inout");

   // scl
   
   property p_scl;
     @(posedge clk ) disable iff (rst_n == '0)
       scl_inout === '1 |=> ##1 scl;
   endproperty

   a_scl: assert property(p_sda)
     else $error("i2c_slave signal scl did not follow scl_inout");
*/   
   property p_past_sda;
     @(posedge clk ) disable iff (rst_n == '0)
       $past(sda) == past_sda;
   endproperty

   a_past_sda: assert property(p_past_sda)
     else $error("i2c_slave signal past_sda did not follow sda");

   property p_past_scl;
     @(posedge clk ) disable iff (rst_n == '0)
       $past(scl) == past_scl;
   endproperty

   a_past_scl: assert property(p_past_scl)
     else $error("i2c_slave signal past_scl did not follow scl");
   
   
   ////////////////////////////////////////////////////////////////////////////////////////
   // i2c_detector
   ////////////////////////////////////////////////////////////////////////////////////////
   
   // scl_rise
   
   property p_scl_rise_true;
     @(posedge clk ) disable iff (rst_n == '0)
       scl && !past_scl |-> scl_rise;
   endproperty

   a_scl_rise_true: assert property(p_scl_rise_true)
     else $error("i2c_slave signal scl_rise in wrong state ('0)");
   c_scl_rise_true: cover property(p_scl_rise_true);

   property p_scl_rise_false;
     @(posedge clk ) disable iff (rst_n == '0)
       !(scl && !past_scl) |-> !scl_rise;
   endproperty

   a_scl_rise_false: assert property(p_scl_rise_false)
     else $error("i2c_slave signal scl_rise in wrong state ('1)");

   // scl_fall

   property p_scl_fall_true;
     @(posedge clk ) disable iff (rst_n == '0)
       !scl && past_scl |-> scl_fall;
   endproperty

   a_scl_fall_true: assert property(p_scl_fall_true)
     else $error("i2c_slave signal scl_fall in wrong state ('0)");
   c_scl_fall_true: cover property(p_scl_fall_true);

   property p_scl_fall_false;
     @(posedge clk ) disable iff (rst_n == '0)
       !(!scl && past_scl) |-> !scl_fall;
   endproperty

   a_scl_fall_false: assert property(p_scl_fall_false)
     else $error("i2c_slave signal scl_fall in wrong state ('1)");


   // start

   property p_start_true;
     @(posedge clk ) disable iff (rst_n == '0)
       scl && past_sda && !sda |-> start;
   endproperty

   a_start_true: assert property(p_start_true)
     else $error("i2c_slave signal start in wrong state ('0)");
   c_start_true: cover property(p_start_true);


   property p_start_false;
     @(posedge clk ) disable iff (rst_n == '0)
       !(scl && past_sda && !sda) |-> !start;
   endproperty

   a_start_false: assert property(p_start_false)
     else $error("i2c_slave signal start in wrong state ('1)");

   // stop

   property p_stop_true;
     @(posedge clk ) disable iff (rst_n == '0)
       scl && !past_sda && sda |-> stop;
   endproperty

   a_stop_true: assert property(p_stop_true)
     else $error("i2c_slave signal stop in wrong state ('0)");
   c_stop_true: cover property(p_stop_true);

   
   property p_stop_false;
     @(posedge clk ) disable iff (rst_n == '0)
       !(scl && !past_sda && sda) |-> !stop;
   endproperty

   a_stop_false: assert property(p_stop_false)
     else $error("i2c_slave signal stop in wrong state ('1)");

   // i2c_ctr3

   property p_seven;
     @(posedge clk ) disable iff (rst_n == '0)
       ((shift && !seven) ##1 (!shift && !clr) [* 0:$]) [* 7] |=> seven;
   endproperty
   
   a_seven: assert property(p_seven)
     else $error("i2c_slave signal seven not '1 after 7 shift pulses");


   // data_out (i2c_srg)

   property p_shift;
     @(posedge clk ) disable iff (rst_n == '0)
       shift |=> data_out == { $past(data_out[NTAPS*16-2:0]), $past(sda) };
   endproperty
   
   a_shift: assert property(p_shift)
     else $error("i2c_srg output data_out not shifted correctly");

   // valid_out (i2c_fsm)

   property p_valid_rise;
     @(posedge clk ) disable iff (rst_n == '0)
       !stop && seven && scl_rise |=> $rose(valid_out);
   endproperty
   
   a_valid_rise: assert property(p_valid_rise)
     else $error("i2c_fsm output valid_out is not '1 after 8th received bit");

   property p_valid_fall;
     @(posedge clk ) disable iff (rst_n == '0)
       $rose(valid_out) |-> (valid_out && !stop && !scl_fall) [* 0:$] ##1 (valid_out && (stop || scl_fall)) ##1 !valid_out;
   endproperty
   
   a_valid_fall: assert property(p_valid_fall)
     else $error("i2c_fsm output valid_out waveform incorrect");

   // oe (i2c_fsm)

   property p_oe_rise;
     @(posedge clk ) disable iff (rst_n == '0)
       valid_out && !stop && scl_fall |=> $rose(oe);
   endproperty
   
   a_oe_rise: assert property(p_oe_rise)
     else $error("i2c_fsm output oe_out is not '1 after byte was received");

   property p_oe_fall;
     @(posedge clk ) disable iff (rst_n == '0)
       $rose(oe) |-> (oe && !stop && !scl_fall) [* 0:$] ##1 (oe && (stop || scl_fall)) ##1 !oe;
   endproperty
   
   a_oe_fall: assert property(p_oe_fall)
     else $error("i2c_fsm output oe_out waveform is wrong");

   // clr (i2c_fsm)

   property p_clr_rise;
     @(posedge clk ) disable iff (rst_n == '0)
       start ##1 !stop [*0:$] ##1 stop |-> $rose(clr);
   endproperty
   
   a_clr_rise: assert property(p_clr_rise)
     else $error("i2c_fsm output clr did not rise when stop was signalled");

   property p_clr_false;
     @(posedge clk ) disable iff (rst_n == '0)
       !stop |-> !clr;
   endproperty
   
   a_clr_false: assert property(p_clr_false)
     else $error("i2c_fsm output clr not '0 when stop was not signalled");
   
endmodule
