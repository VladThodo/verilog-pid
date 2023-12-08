# Basic script used to send and recevive bytes - testing the UART module

import os
import serial
import time

ser = serial.Serial('COM5', 9600)

i = 0

while True:
    some_byte = i.to_bytes(1, byteorder='big')
    ser.write(some_byte)

    #if ser.read() != some_byte:
    #    print(f"Wrong response value for {i}")
    
    i = i  + 1
    time.sleep(1)
