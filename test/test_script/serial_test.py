import os
import serial
import time
import argparse
import numpy as np
import matplotlib.pyplot as plt
"""
if __name__ == "__main__":
    # entry point of termbin
    parser = argparse.ArgumentParser(
                    prog='termbin.py',
                    description='Raw serial terminal written in python',
                    epilog='Enjoy! :D')
    parser.add_argument('-p', metavar='N', type=str,
                    help='serial port name')
    args = parser.parse_args()
    print(args.p)

def serial_init():
    
    """
# serial port instance
ser = serial.Serial('COM7', 
                    baudrate=9600, 
                    timeout=3)
                
a = bytearray()

# for i in range(256):
#     a.append(0x61)
#     a.append(i)
#     a.append(i)
#     ser.write(a)
#     a.clear()
#     time.sleep(0.3)
#     a.append(0x70)
#     ser.write(a)
#     print(ser.read(3)[1:].hex())
#     a.clear()
# a.append(0x60)
# a.append(0xAA)
# a.append(0xFF)

# ser.write(a)
# a.clear()

a.append(0x60) # write P
a.append(0x00)
a.append(0xf0)

ser.write(a)

#time.sleep(2)

a = bytearray() # re init bytearray

a.append(0x61) # write integral coef
a.append(0x00)
a.append(0x04)

ser.write(a)

a = bytearray() # re init bytearray

a.append(0x62) # write derivative coef
a.append(0x00)
a.append(0xf0)

ser.write(a)

#time.sleep(2)

a = bytearray() # re init bytearray

a.append(0x63) # write set point
a.append(0x00)
a.append(0x0a)

ser.write(a)

#time.sleep(2)

a = bytearray() # re init bytearray

a.append(0x64) # write offset
a.append(0x03)
a.append(0x80)

ser.write(a)

a = bytearray()  # re init byte array

a.append(0x65) # write integral upper limit
a.append(0x00)
a.append(0xa0)

ser.write(a)

a = bytearray()  # re init byte array

a.append(0x66) # write integral lower limit
a.append(0x00)
a.append(0xD0)

ser.write(a)

#time.sleep(2)

a = bytearray()

time.sleep(1)
ser.reset_input_buffer()
ser.reset_output_buffer()

sens_values = []
time_vals = []

t = 0

print("NOW!")
time.sleep(3)

for i in range(0, 500): # collect 1000 samples
    a.append(0x7D)
    ser.write(a)
    distance = int.from_bytes(ser.read(2), "big")
    a.clear()
    a.append(0x7E)
    ser.write(a)
    pid_out = int.from_bytes(ser.read(2), "big")
    a.clear()
    sens_values.append(distance)
    time_vals.append(t)
    t += 0.002
    time.sleep(0.01)

print(sens_values)
print(time_vals)
