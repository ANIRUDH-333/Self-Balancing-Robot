import serial                                      # add Serial library for serial communication                                 # add pyautogui library for programmatically controlling the mouse and keyboard.
import time
import statistics as st

ser = serial.Serial('com6',115200)
time.sleep(2)

# Read and record the data
data =[]                       # empty list to store the data
for i in range(200):
    b = ser.readline()         # read a byte string
    string_n = b.decode()  # decode byte string into Unicode
    string = string_n.rstrip() # remove \n and \r
    if (string == "Initializing I2C devices..."):
        string = "0.0"
    elif (string == "Testing device connections..."):
        string = "0.0"
    flt = float(string)        # convert string to float
    print(flt)
    data.append(flt)           # add to the end of data list
    time.sleep(0.1)            # wait (sleep) 0.1 seconds

ser.close()

# show the data

for line in data:
    print(line)
data.remove(0.0)
print(st.mean(data))
