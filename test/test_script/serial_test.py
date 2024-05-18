import os
import serial
import time
import argparse
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
ser = serial.Serial('COM6', 
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

a.append(0x7D)
while True:
    ser.write(a)
    print(ser.read(2).hex())
    time.sleep(0.1)

