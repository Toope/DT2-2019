create_clock -name clk -period 6.0 clk

set_input_delay -clock clk 0.0 rst_n
set_input_delay -clock clk 1.2 scl_inout
set_input_delay -clock clk 1.2 sda_inout

set_output_delay -clock clk 1.2 data_out
set_output_delay -clock clk 1.2 data_valid_out
set_output_delay -clock clk 1.2 sda_inout

#set_min_delay 0.4 -rise  -through { reset_sync_1/srst_n } -reset_path
#set_min_delay 0.4 -fall  -through { reset_sync_1/srst_n } -reset_path


