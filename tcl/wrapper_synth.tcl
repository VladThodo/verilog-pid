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

# Implementation

opt_design
place_design
route_design
opt_design

# Bitsream

write_bitstream -force $outputDir/wrapper.bit

# Debug probes

write_debug_probes -force $outputDir/debug.ltx