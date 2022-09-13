# data_in and data_out range

proc analog_wave { path } {
    set obj [find signals $path]
    set obj_value [examine $obj]
    set obj_bits [string range $obj_value 0 [expr [string first "'" $obj_value] - 1]]
    set obj_max [expr (2 ** ($obj_bits-1)) - 1]
    set obj_min [expr -(2 ** ($obj_bits-1))]
    add wave -radix decimal -format Analog-Step -height 84 -max $obj_max -min $obj_min $path
}


set data_in_max [expr {2**($DATABITS-1)-1}]
set data_in_min [expr {-(2**($DATABITS-1)-1)}]
set data_out_max $data_in_max
set data_out_min $data_in_min

onerror {resume}
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/clk
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/rst_n
add wave -noupdate -divider Ports
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/scl_inout
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/sda_inout
analog_wave /fir_filter_tb/DUT_INSTANCE/data_in
analog_wave /fir_filter_tb/DUT_INSTANCE/data_out

#add wave -noupdate -format Analog-Step -height 84 -max $data_in_max -min $data_in_min -radix decimal /fir_filter_tb/DUT_INSTANCE/data_in
#add wave -noupdate -format Analog-Step -height 84 -max $data_out_max -min $data_out_min -radix decimal /fir_filter_tb/DUT_INSTANCE/data_out
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/data_valid_out
add wave -noupdate -divider Internal
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/i2c_start
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/i2c_stop
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/i2c_data
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/i2c_valid
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/ack
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/filter_en
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/load_en
add wave -noupdate /fir_filter_tb/DUT_INSTANCE/srst_n
configure wave -signalnamewidth 1
configure wave -datasetprefix 0
update

