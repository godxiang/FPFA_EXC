transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/altera/13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/altera/13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {c:/altera/13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/gitwork/FPFA_EXC/uart_rx/rtl {D:/gitwork/FPFA_EXC/uart_rx/rtl/uart_rx_byte.v}
vlog -vlog01compat -work work +incdir+D:/gitwork/FPFA_EXC/uart_rx/prj/ip/issp {D:/gitwork/FPFA_EXC/uart_rx/prj/ip/issp/issp_uart_recv.v}
vlog -vlog01compat -work work +incdir+D:/gitwork/FPFA_EXC/uart_rx/rtl {D:/gitwork/FPFA_EXC/uart_rx/rtl/uart_rx_top.v}

vlog -vlog01compat -work work +incdir+D:/gitwork/FPFA_EXC/uart_rx/prj/../testbench {D:/gitwork/FPFA_EXC/uart_rx/prj/../testbench/uart_rx_byte_tb.v}
vlog -vlog01compat -work work +incdir+D:/gitwork/FPFA_EXC/uart_rx/prj/../testbench {D:/gitwork/FPFA_EXC/uart_rx/prj/../testbench/uart_tx_byte.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  uart_rx_byte_tb

add wave *
view structure
view signals
run -all
