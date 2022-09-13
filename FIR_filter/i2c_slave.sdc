create_clock -name clk -period 5.0 clk
set_input_delay -clock clk 0.0 rst_n
set_input_delay -clock clk 2.0 scl_inout
set_input_delay -clock clk 2.0 sda_inout
set_input_delay -clock clk 2.0 ack_in

set_output_delay -clock clk 2.0 data_out
set_output_delay -clock clk 2.0 valid_out
set_output_delay -clock clk 2.0 sda_inout

