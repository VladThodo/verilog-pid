# Synthesize and implement our wrapper. Yay!

set outputDir ./buildData
file mkdir $outputDir

# Read UART source code

read_verilog ./src/uart/receiver.v
read_verilog ./src/uart/transmitter.v
read_verilog ./src/uart/UART.v

# Read clock_wizard code

read_verilog ./src/clocking/clock_wizard.v

# Read memory source code

read_verilog ./src/mem/edge_detector.v
read_verilog ./src/mem/mem_ctrl.v
read_verilog ./src/mem/memory.v

# Read wrapper source code

read_verilog ./src/wrapper.v

# Read constraints

read_xdc ./constr/uart_const.xdc

# Run synthesis

synth_design -top wrapper -part xc7a100tcsg324-1
#write_checkpoint -force $outputDir/post_synth

# Debug core

create_debug_core u_ila_0 ila
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk]]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list data_rdy]]
create_debug_port u_ila_0 probe1
set_property port_width 5 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {addr[0]} {addr[1]} {addr[2]} {addr[3]} {addr[4]}]]
create_debug_port u_ila_0 probe2
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {data_link[0]} {data_link[1]} {data_link[2]} {data_link[3]} {data_link[4]} {data_link[5]} {data_link[6]} {data_link[7]}]]

# Implementation

opt_design
place_design
route_design
opt_design


# Bitsream

write_bitstream -force $outputDir/wrapper.bit

# Debug probes

write_debug_probes -force $outputDir/debug.ltx