@echo off

set arg1=%1

if %arg1% == uart vivado -mode batch -source ./tcl/uart_synth.tcl
if %arg1% == mem  vivado -mode batch -source ./tcl/mem_synth.tcl
if %arg1% == clean del *.jou del *.log 
if %arg1% == wrapper vivado -mode batch -source ./tcl/wrapper_synth.tcl