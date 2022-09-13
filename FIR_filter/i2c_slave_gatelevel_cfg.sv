`include "fir_filter.svh"
config GATELEVEL_HIERARCHY_CFG;
   design gatelevel_lib.i2c_slave;
   default liblist gatelevel_lib;
endconfig

config GATELEVEL_SIMULATION_CFG;   
   design work.i2c_slave_tb;
   default liblist work;
   instance i2c_slave_tb.DUT_INSTANCE use work.GATELEVEL_HIERARCHY_CFG:config;
   instance i2c_slave_tb.REF_MODEL.REF_INSTANCE use work.i2c_slave;
endconfig
   


   

