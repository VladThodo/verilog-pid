import serial
import time
from scipy.io import savemat

ser = serial.Serial('COM7', 
                    baudrate=9600, 
                    timeout=3)

a = bytearray()
a.append(0x63) # scriere valoare de referinta
a.append(0x00)
a.append(0x08)
ser.write(a)

time.sleep(5)

a.clear()
a = bytearray()

a.append(0x63) # scriere valoare de referinta
a.append(0x00)
a.append(0x0e)
ser.write(a)

ser.reset_input_buffer()
ser.reset_output_buffer()

distanta = []
eroare = []
integrala = []
derivata = []
timp = []
iesire_pid = []

t = 0

ser.reset_input_buffer()
ser.reset_output_buffer()

a.clear()
a = bytearray()

a.append(0x63) # scriere valoare de referinta
a.append(0x00)
a.append(0x0e)
ser.write(a)

ser.reset_input_buffer()
ser.reset_output_buffer()

a.clear()
a = bytearray()
ser.reset_input_buffer()
ser.reset_output_buffer()
ser.reset_input_buffer()
ser.reset_output_buffer()
# 1000 de esantioane la intervale de 20 ms
for i in range(2000):
    
    a.clear()
    a.append(0x7D) # distanta
    ser.write(a)
    distance = int.from_bytes(ser.read(2), "big")
    
    # a.clear()
    # a.append(0x7A) # eroarea 
    # ser.write(a)
    # eroare.append(int.from_bytes(ser.read(2), "big"))
    
    # a.clear()
    # a.append(0x7B) # integrala 
    # ser.write(a)
    # integrala.append(int.from_bytes(ser.read(2), "big"))

    # a.clear()
    # a.append(0x7C) # derivata
    # ser.write(a)
    # derivata.append(int.from_bytes(ser.read(2), "big"))

    # a.clear()
    # a.append(0x7E) # iesire pid
    # ser.write(a)
    # iesire_pid.append(int.from_bytes(ser.read(2), "big"))

    if distance in range(0, 100):
        distanta.append(distance)
        timp.append(t)
        t += 0.01
   # time.sleep(0.01)

savemat('rasp_impuls14.mat', {'y': distanta, 't': timp, 'e': eroare, 'i': integrala, 'd':derivata, 'out': iesire_pid})