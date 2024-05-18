import tkinter as tk
from tkinter import ttk

import serial

ser = serial.Serial('COM7', 
                    baudrate=9600, 
                    timeout=3)
a = bytearray()
b = bytearray()
b.append(0x7E)
a.append(0x7D)
root = tk.Tk()
progress = tk.IntVar()
progress1 = tk.IntVar()

def update_ball_pos():
    ser.write(a)
    distance = int.from_bytes(ser.read(2), "big")
    progress.set(distance)
    root.after(20, update_ball_pos)

def update_pid_o():
    ser.write(b)
    distance = int.from_bytes(ser.read(2), "big")
    progress1.set(distance)
    root.after(20, update_pid_o)

root.title("PID Controller Data")
text = ttk.Label(text="Distance")
text1 = ttk.Label(text="PID output")
progressbar = ttk.Progressbar(orient=tk.VERTICAL, length=300, variable=progress, maximum=18)
progressbar1 = ttk.Progressbar(orient=tk.VERTICAL, length=300, variable=progress1, maximum=4000)
progressbar.place(x=30, y=70)
progressbar1.place(x=70, y=70)
text.place(x = 20, y = 50)
text1.place(x = 70, y = 380)
progress.set(50)
root.geometry("500x500")

update_ball_pos()
update_pid_o()

root.mainloop()

