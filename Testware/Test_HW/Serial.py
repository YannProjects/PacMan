import serial


ser = serial.Serial()
ser.baudrate = 9600
ser.port = '/dev/ttyS2'

ser.open()

while 1:
    hello = ser.readline()
    print(hello)

ser.close()
