####################################################################################################
#
# Top module selection
#
####################################################################################################

set DESIGN_NAME "fir_filter"
#set DESIGN_NAME "i2c_slave"
#set DESIGN_NAME "i2c_detector"
#set DESIGN_NAME "i2c_fsm"
#set DESIGN_NAME "i2c_sync"
#set DESIGN_NAME "i2c_srg"
#set DESIGN_NAME "i2c_ctr3"
#set DESIGN_NAME "filter_unit"
#set DESIGN_NAME "muladd"
#set DESIGN_NAME "acc"
#set DESIGN_NAME "sat" 
#set DESIGN_NAME "oreg"
#set DESIGN_NAME "cregs"
#set DESIGN_NAME "dregs"
#set DESIGN_NAME "filter_unit_control"
#set DESIGN_NAME "control_unit"
#set DESIGN_NAME "reset_sync"

####################################################################################################
#
# Common design settings
#
####################################################################################################

# P1: Define NTAPS and DATABITS so that they can be used in tool scripts
set NTAPS 7
set DATABITS 16
# P1: Define your clock period value (ns)
set CLOCK_PERIODS        {   6.0  }
# P1: Set input delays to 20% of clock period
set INPUT_DELAYS         { 1.20 }
# P1: Set input delays to 20% of clock period
set OUTPUT_DELAYS        { 1.20 }

set CLOCK_NAMES          { "clk" }
set CLOCK_LATENCIES      { 0.0 }
set CLOCK_UNCERTAINTIES  { 0.0 }
set RESET_NAMES          { "rst_n" }
set RESET_LEVELS         {   0  }
set RESET_STYLES         { "async"  }
set OUTPUT_LOAD          0.01
set RTL_LANGUAGE         "SystemVerilog"

####################################################################################################
#
# Top-module specific design settings
#
####################################################################################################

switch $DESIGN_NAME {

    "fir_filter" {
	set DESIGN_FILES { \
			       "input/fir_filter_pkg.sv" \
			       "input/i2c_pkg.sv" \
			       "input/i2c_sync.sv" \
			       "input/i2c_detector.sv" \
			       "input/i2c_ctr3.sv" \
			       "input/i2c_srg.sv" \
			       "input/i2c_fsm.sv" \
			       "input/i2c_slave.sv" \
			       "input/cregs.sv" \
			       "input/dregs.sv" \
			       "input/muladd.sv" \
			       "input/acc.sv" \
			       "input/sat.sv" \
			       "input/oreg.sv" \
			       "input/filter_unit_control.sv" \
			       "input/filter_unit.sv" \
			       "input/control_unit.sv" \
			       "input/reset_sync.sv" \
			       "input/fir_filter.sv" \
			   }
	set TESTBENCH_FILES { \
				  "input/fir_filter_tb.sv" \
				  "input/fir_filter_test.sv" \
			      }
	set SDC_FILE input/fir_filter.sdc
	set QUESTA_INIT_FILE input/fir_filter.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
        set VSIM_DISABLE_TIMINGCHECKS { "*sff1*" }
	set SYNTHESIS_DONT_UNGROUP { "reset_sync" "i2c_slave" "filter_unit" "control_unit"  }
	set SYNTHESIS_FIX_HOLD 1
	set SYNTHESIS_RECREM_ARCS 1
    }

    "i2c_slave" {
	set DESIGN_FILES { \
			       "input/fir_filter_pkg.sv" \
			       "input/i2c_pkg.sv" \
			       "input/i2c_sync.sv" \
			       "input/i2c_detector.sv" \
			       "input/i2c_ctr3.sv" \
			       "input/i2c_srg.sv" \
			       "input/i2c_fsm.sv" \
			       "input/i2c_slave.sv" \
			   }
	set TESTBENCH_FILES { "input/i2c_slave_svamod.sv" "input/i2c_slave_test.sv" "input/i2c_slave_tb.sv" }
	set SDC_FILE input/i2c_slave.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_CONFIGURATION "input/i2c_slave_gatelevel_cfg.sv"
	set GATELEVEL_SIMULATION_TIME 150us
        set VSIM_DISABLE_TIMINGCHECKS { "*sff1*" }
	set SYNTHESIS_DONT_UNGROUP { "i2c_sync" "i2c_detector" "i2c_srg" "i2c_ctr3" "i2c_fsm" }
    }

    "i2c_detector" {
	set DESIGN_FILES [list "input/i2c_pkg.sv"  "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/no_clock.sdc
	set QUESTA_INIT_FILE input/no_clock.questa_init
	set CLOCK_NAMES          { }
	set RTL_SIMULATION_TIME 1us
	set GATELEVEL_SIMULATION_TIME 1us
    }

    "i2c_fsm" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "i2c_sync" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
        set VSIM_DISABLE_TIMINGCHECKS { "*sff1*" }
    }

    "i2c_srg" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "i2c_ctr3" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "filter_unit" {
	set DESIGN_FILES { \
			       "input/fir_filter_pkg.sv" \
			       "input/cregs.sv" \
			       "input/dregs.sv" \
			       "input/muladd.sv" \
			       "input/acc.sv" \
			       "input/sat.sv" \
			       "input/oreg.sv" \
			       "input/filter_unit_control.sv" \
			       "input/filter_unit.sv" \
			   }
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "filter_unit_control" {
	set DESIGN_FILES { \
			       "input/fir_filter_pkg.sv" \
			       "input/filter_unit_control.sv" \
			   }
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "muladd" {
	set DESIGN_FILES [list "input/i2c_pkg.sv"  "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/no_clock.sdc
	set QUESTA_INIT_FILE input/no_clock.questa_init
	set CLOCK_NAMES          { }
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "sat" {
	set DESIGN_FILES [list "input/i2c_pkg.sv"  "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/no_clock.sdc
	set QUESTA_INIT_FILE input/no_clock.questa_init
	set CLOCK_NAMES          { }
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "acc" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }


    "oreg" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "cregs" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "dregs" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "control_unit" {
	set DESIGN_FILES [list "input/i2c_pkg.sv" "input/fir_filter_pkg.sv" "input/${DESIGN_NAME}.sv" ]
	set TESTBENCH_FILES { "input/control_unit_test.sv" "input/control_unit_tb.sv" }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME "-all"
	set GATELEVEL_SIMULATION_TIME "-all"
    }

    "reset_sync" {
	set DESIGN_FILES { \
			       "input/fir_filter_pkg.sv" \
			       "input/i2c_pkg.sv" \
			       "input/reset_sync.sv" \
			   }
	set TESTBENCH_FILES { }
	set SDC_FILE input/clock.sdc
	set QUESTA_INIT_FILE input/clock.questa_init
	set RTL_SIMULATION_TIME 200ns
	set GATELEVEL_SIMULATION_TIME 200ns
        set VSIM_DISABLE_TIMINGCHECKS { "*sff1*" "*connect_reg*" "*srst_n_reg*"}
    }
}

set SVA_BIND_FILE "input/fir_filter_svabind.sv"


####################################################################################################
#
# Tool settings
#
####################################################################################################

set VSIM_SCHEMATIC 1
set DC_SUPPRESS_MESSAGES { "UID-401" "TEST-130" "TIM-104" "VER-26" "TIM-179" }
set VSIM_GATELEVEL_OPTIONS "+nowarn3448 +nowarn3438 +nowarn8756 -suppress 3009 -debugdb"
set VSIM_GATELEVEL_WAVES "input/5_vsim_module_gatelevel_waves.tcl"
set VSIM_GATELEVEL_LOG 1
set GATELEVEL_SDF MAX
set POSTLAYOUT_SDF MAX
