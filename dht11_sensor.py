import RPi.GPIO as GPIO
import dht11
import time
import datetime

def get_Temp():
# read data using pin 12
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BOARD)
    #GPIO.cleanup()
    
    instance = dht11.DHT11(pin=12)
    res = []
    result = instance.read()
    if result.is_valid():
	res.append(result.temperature)
	res.append(result.humidity)
    return res
    GPIO.cleanup()
