#!/usr/bin/python
import serial
import sys

print sys.argv

x = int(sys.argv[1]) * 40
y = int(sys.argv[2]) * 40
port = sys.argv[3] 

cmd="PA;PA;!VZ10;!PZ0,100;PU %d %d;PD %d %d;!MC0;" % (x,y,x,y)

print cmd

serial = serial.Serial(port, baudrate=9600, rtscts=True, timeout=0)
serial.write(cmd)
serial.close()
