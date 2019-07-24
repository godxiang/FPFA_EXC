## Generated SDC file "hsc.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Full Version"

## DATE    "Mon Apr 25 13:49:19 2016"

##
## DEVICE  "EP4CE22F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {SYSTEM_CLK} -period 40.000 -waveform { 0.000 20.000 } [get_ports {ext_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {SYSTEM_CLK} [get_pins {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[4]} -source [get_pins {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 4 -master_clock {SYSTEM_CLK} [get_pins {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[4]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -to [get_ports {fx3_db[31] fx3_a[0] fx3_a[1] fx3_db[0] fx3_db[1] fx3_db[2] fx3_db[3] fx3_db[4] fx3_db[5] fx3_db[6] fx3_db[7] fx3_db[8] fx3_db[9] fx3_db[10] fx3_db[11] fx3_db[12] fx3_db[13] fx3_db[14] fx3_db[15] fx3_db[16] fx3_db[17] fx3_db[18] fx3_db[19] fx3_db[20] fx3_db[21] fx3_db[22] fx3_db[23] fx3_db[24] fx3_db[25] fx3_db[26] fx3_db[27] fx3_db[28] fx3_db[29] fx3_db[30] fx3_pktend_n fx3_slcs_n fx3_sloe_n fx3_slrd_n fx3_slwr_n}] 12.000
set_max_delay -from [get_ports {fx3_flaga fx3_flagb fx3_flagc fx3_flagd fx3_db[31] fx3_db[0] fx3_db[1] fx3_db[2] fx3_db[3] fx3_db[4] fx3_db[5] fx3_db[6] fx3_db[7] fx3_db[8] fx3_db[9] fx3_db[10] fx3_db[11] fx3_db[12] fx3_db[13] fx3_db[14] fx3_db[15] fx3_db[16] fx3_db[17] fx3_db[18] fx3_db[19] fx3_db[20] fx3_db[21] fx3_db[22] fx3_db[23] fx3_db[24] fx3_db[25] fx3_db[26] fx3_db[27] fx3_db[28] fx3_db[29] fx3_db[30]}] 7.000
set_max_delay -from [get_clocks {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[1]}] -to [get_ports {fx3_pclk}] 5

#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -to [get_ports {fx3_db[31] fx3_a[0] fx3_a[1] fx3_db[0] fx3_db[1] fx3_db[2] fx3_db[3] fx3_db[4] fx3_db[5] fx3_db[6] fx3_db[7] fx3_db[8] fx3_db[9] fx3_db[10] fx3_db[11] fx3_db[12] fx3_db[13] fx3_db[14] fx3_db[15] fx3_db[16] fx3_db[17] fx3_db[18] fx3_db[19] fx3_db[20] fx3_db[21] fx3_db[22] fx3_db[23] fx3_db[24] fx3_db[25] fx3_db[26] fx3_db[27] fx3_db[28] fx3_db[29] fx3_db[30] fx3_pktend_n fx3_slcs_n fx3_sloe_n fx3_slrd_n fx3_slwr_n}] 9.000
set_min_delay -from [get_ports {fx3_flaga fx3_flagb fx3_flagc fx3_flagd fx3_db[31] fx3_db[0] fx3_db[1] fx3_db[2] fx3_db[3] fx3_db[4] fx3_db[5] fx3_db[6] fx3_db[7] fx3_db[8] fx3_db[9] fx3_db[10] fx3_db[11] fx3_db[12] fx3_db[13] fx3_db[14] fx3_db[15] fx3_db[16] fx3_db[17] fx3_db[18] fx3_db[19] fx3_db[20] fx3_db[21] fx3_db[22] fx3_db[23] fx3_db[24] fx3_db[25] fx3_db[26] fx3_db[27] fx3_db[28] fx3_db[29] fx3_db[30]}] 4.000
set_min_delay -from [get_clocks {u1_sys_ctrl|pll_controller_inst|altpll_component|auto_generated|pll1|clk[1]}] -to [get_ports {fx3_pclk}] 3

#**************************************************************
# Set Input Transition
#**************************************************************

