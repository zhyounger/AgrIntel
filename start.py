#!/usr/bin/python
import os
import RPi.GPIO as GPIO
import time
import datetime
import threading
from threading import Timer
import dht11_sensor
import light_sensor
import image
from dht11_sensor import getData
from light_sensor import getLight
from image import getPicture
def begin():
    array=[]
    time=str(datetime.datetime.now())
    array.append(time)
    #print array
    T1=getData()
    if T1:
        pass
    else:
        T1 = getData()
    array.append(T1)
    T2=getLight()
    if T2:
        pass
    else:
        T2 = getLight()
    array.append(T2)
    T3=getPicture()
    array.append(T3)
    print array
    t=Timer(8,begin)
    t.start()
    return array
    #print array
def tes():
    data = begin()
    info = {}
    info = {'time':data[0],{}.fromkeys(['temperature','humidity',data[1]]),'light':data[2],'image':data[3]}
    print info
    return info
tes()
    
