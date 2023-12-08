# Build our UART. Yay!

set outputDir ./buildData
file mkdir $outputDir

# Read UART source code

read_verilog ./src/uart/clk_divider.v
read_verilog ./src/uart/receiver.v
read_verilog ./src/uart/transmitter.v
read_verilog ./src/uart/UART.v

read_xdc ./constr/uart_const.xdc

# Run synthesis

synth_design -top UART -part xc7a100tcsg324-1

# Implementation 

opt_design
place_design
route_design
opt_design

# Write bitstream

write_bitstream -force $outputDir/uart.bit