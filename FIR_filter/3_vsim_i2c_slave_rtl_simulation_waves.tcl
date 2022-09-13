onerror {resume}
quietly virtual function -install /i2c_slave_tb/DUT_INSTANCE -env /i2c_slave_tb { &{/i2c_slave_tb/DUT_INSTANCE/data_out[7], /i2c_slave_tb/DUT_INSTANCE/data_out[6], /i2c_slave_tb/DUT_INSTANCE/data_out[5], /i2c_slave_tb/DUT_INSTANCE/data_out[4], /i2c_slave_tb/DUT_INSTANCE/data_out[3], /i2c_slave_tb/DUT_INSTANCE/data_out[2], /i2c_slave_tb/DUT_INSTANCE/data_out[1], /i2c_slave_tb/DUT_INSTANCE/data_out[0] }} data_out_7_0
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/clk
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/rst_n
add wave -noupdate -divider PORTS
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/scl_inout
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/sda_inout
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/ack_in
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/start_out
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/stop_out
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/data_out_7_0
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/data_out
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/valid_out
add wave -noupdate -divider {INTERNAL SIGNALS}
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/scl
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/sda
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/past_scl
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/past_sda
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/start
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/stop
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/scl_rise
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/scl_fall
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/oe
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/clr
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/shift
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/seven
add wave -noupdate -divider REGISTERS
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/scl_sff1_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/scl_sff2_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/sda_sff1_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/sda_sff2_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/past_sda_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_sync_1/past_scl_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_srg_1/srg_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_ctr3_1/ctr3_r
add wave -noupdate /i2c_slave_tb/DUT_INSTANCE/i2c_fsm_1/state_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5013 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 214
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {19316 ns}
