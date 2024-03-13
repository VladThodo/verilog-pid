# Basic script used to send and recevive bytes - testing the UART module

import os
import serial
import time

ser = serial.Serial('COM5', baudrate=9600)
 #                           stopbits=serial.STOPBITS_ONE)


j = 0

a = bytearray()

i = 0


while j < 171:
    a.append(0b01100000)
    a.append(j + 1)
    a.append(j)
    ser.write(a)
    # time.sleep(0.)
    a.clear()
    j = j + 1

