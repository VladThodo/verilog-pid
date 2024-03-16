"""
    termbin.py - Copyright (C) Vlad Todosin 2024
    Basic serial terminal used to send and receive raw binary data.
    Usage: termbin.py [-p] [-b] [-d] [-l]
        optional arguments:
            -p          serial port name
            -b          baudrate
            -d          data display format, either hex or bin
            -l          list serial ports

"""

import os
import serial
import time
import argparse

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
ser = serial.Serial('COM5', 
                    baudrate=9600, 
                    timeout=3)
                    """

