# Synthesize our memory block. Yay!

set outputDir ./buildData
file mkdir $outputDir

# Read UART source code

read_verilog [glob ./src/mem/*.v]

# Run synthesis

synth_design -top mem_ctrl -part xc7a100tcsg324-1
write_checkpoint -force $outputDir/post_synth

# Opt design

opt_design
write_checkpoint -force $outputDir/post_opt

# Place design
place_design
write_checkpoint -force $outputDir/post_place