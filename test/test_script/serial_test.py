# Basic script used to send and recevive bytes - testing the UART module

import os
import serial
import time

ser = serial.Serial('COM8', 9600)


# reset

j = 255

some_byte = j.to_bytes(1, byteorder='big')
ser.write(some_byte)
time.sleep(0.1);

i = 0
j = 0
k = 1
m = 254

while True:
    i = 254 

    some_byte = j.to_bytes(1, byteorder='big')
    ser.write(b'\x00')
    time.sleep(0.1);
    
    some_byte = i.to_bytes(2, byteorder='big')
    ser.write(b'\x00')
    time.sleep(0.1)

    some_byte = k.to_bytes(1, byteorder='big')
    ser.write(b'\x01')
    time.sleep(0.1);

    some_byte = i.to_bytes(2, byteorder='big')
    ser.write(b'\x00')
    time.sleep(0.1)

    #if ser.read
    i = i  + 1
    m = m - 1
