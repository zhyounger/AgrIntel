#import RPi.GPIO as GPIO
import time
import datetime
import smbus
def get_Light():
    arr = []
    bus=smbus.SMBus(1)
    addr=0x23
    data=bus.read_i2c_block_data(addr,0x11)
    l = str(round((data[1] + (256 * data[0])) / 1.2,1))
    arr.append(l)
    if arr:
        pass      
    else:
        print 'not light'
        arr = get_Light()     
    return arr
    GPIO.cleanup()
