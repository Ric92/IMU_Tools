from visual import *
import serial
import string
import math

from time import time

grad2rad = float(3.141592/180.0)
#toSI = float(9.81 * 0.061 / 1000)   # acel raw data to m/s2
toSI = 1   # acel raw data to m/s2

ser = serial.Serial(port='/dev/ttyACM0',baudrate=115200, timeout=1)

file = open("Serial"+str(time())+".txt", 'w')
print("Starting record loop")
while 1:
    line = ser.readline()
    if line.find("!ANG:") != -1:          # filter out incomplete (invalid) lines
        line = line.replace("!ANG:","")   # Delete "!ANG:"
        words = string.split(line,",")    # Fields split
        if len(words) > 2:
            try:
                timestamp = float(words[0])
                roll = float(words[1]) 
                pitch = float(words[2]) 
                yaw = float(words[3]) 
                ax = float(words[4])
                ay = float(words[5])
                az = float(words[6])
                girox = float(words[7])
                giroy = float(words[8])
                giroz = float(words[9])
                magnex = float(words[10])
                magney = float(words[11])
                magnez = float(words[12])
                #print("timestamp: " + str(timestamp/1000) + " ax: " + str(ax * toSI) + " ay: " + str(ay * toSI) + " az: " + str(az * toSI))
                #print(" timestamp: % 5.4f ax: % 5.4f ay: % 5.4f az: % 5.4f roll: % 5.4f pitch: % 5.4f yaw: % 5.4f" %(timestamp/1000, ax * toSI, ay * toSI, az * toSI,roll,pitch,yaw)) 
            except:
                print("Invalid line")

        file.write(str(timestamp/1000) + ", " + str(ax) + ", " +str(ay) + ", " +str(az) + ", " + str(roll) + ", " +str(pitch) + ", " +str(yaw) + ", ") 
        file.write(str(girox) + ", " + str(giroy) + ", " +str(giroz) + ", ") 
        file.write(str(magnex) + ", " +str(magney) + ", " +str(magnez) + "\n") 

        #print(str(1/(time() - start)))              
ser.close
f.close