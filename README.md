# Verilog PID controller
This was developed as part of my Bachelor's diploma project. It is a full system capable of communicating with a computer via serial UART and reading data from a serial-capable sensor. It can be adapted to any sort of sensor without too much difficulty.

The GitHub documentation is still under development. If you think this project might help ypu, please reach out to me for more detailed information.

# System architecture overview

As a practical application, the PID controller is responsible of controlling the height at which a ping-pong ball "levitates" in a plastic tube by adjusting the speed of a fan. As such, the system was developed more or less proprietary for this application.

Most of the important modules communicate via the memory module. Although this might seem overly complicated at first, it allow for easy, real-time debugging, as memory locations can be read continously via serial at runtime and various graphs (such as the integral compontent of the PID) can be plotted. 

A Python script for reading the data and saving the results in `.mat` files for analysis in Matlab is also provided. It was mostly designed to plot the step response of the system, but can be adapted to various other tasks.

The main components of the system are:
  - an UART controller (designed to operate at 9600bps in the 8N1 format)
  - a clock wizard (used to generate a clock enable signal for all the orher modules)
  - a sensor interface (which consists of UART and a state machine, given the fact that the sensor sends its data in multiple bytes)
  - a memory controller (interfaced by the UART and capable of writing and reading memory locations)
  - a memory module (16 x 16, holding data used by various other modules)
  - a PWM generator (at 25kHz, used to control a PC fan as an output device)
  - a PID controller module (which reads Kp, Ki, Kd, setpoint and sensor output from the memory and computes the error and correction)

An overview is also persented in the block diagram below.

<br>

<img width="1429" alt="top_structure" src="https://github.com/user-attachments/assets/6bfd68d3-50fa-4f83-893d-cd1377c6340e" />

