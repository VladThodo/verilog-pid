##########################################################
# Verilog PID controler tunning tool
# How it works:
# - iterate through all possilbe PID coefficients values from given lists
# - iterate through all possilbe set points
# - track the changes in ball position for 200 ms for each coefficient combo & for each setpoint
# - the coefficients with the least number of changes for all setpoints are outputed
##########################################################

import serial
import time
import itertools

SER_PORT_NAME = 'COM7' # change accordingly

ser = serial.Serial(port=SER_PORT_NAME,
                    baudrate=9600,
                    timeout=3)

p_possible_values = [50, 100, 150, 250]
i_possible_values = [2, 3, 4]
d_possible_values = [1, 6, 9]

setpoint_list = []

integral_upper_limit_val = 0
integral_lower_limit_val = 0

pid_offset_val = 0

def flush_serial():
    time.sleep(1)
    ser.reset_input_buffer()
    ser.reset_output_buffer()

def write_p_coefficient(coef_val):
    print(f"-> Wrote P value {coef_val}")

def write_i_coefficient(coef_val):
    print(f"-> Wrote I value {coef_val}")

def write_d_coefficient(coef_val):
    print(f"-> Wrote D value {coef_val}")

def write_integral_lower_limit():
    pass

def write_integral_upper_limit():
    pass

def write_setpoint(setpoint_val):
    pass

def write_pid_val(pid_val):
    pass

def read_sensor_val():
    flush_serial()
    distance = int.from_bytes(ser.read(2), "big")
    return distance


def find_lift_offset():
    """ 
    Return the value of the offset needed for the ball to lift up
    Procedure:
        - increment PID output val until the distance is consistently over 6
    """
    for i in range(0, 4000):
        write_pid_val(i)       
    pass


def run_self_calib():
    print("#### Begin self tunning ####")
    i = 1
    for coef_combination in itertools.product(p_possible_values, i_possible_values, d_possible_values):
        print()
        print(f"% Attempt {i}")
        i += 1
        write_p_coefficient(coef_combination[0])
        write_i_coefficient(coef_combination[1])
        write_d_coefficient(coef_combination[2])

        for setval in setpoint_list:
            write_setpoint(setval)

run_self_calib()