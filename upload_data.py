import requests
import RPi.GPIO as GPIO
import time
import datetime
import threading
from threading import Timer
import dht11_sensor
import light_sensor
import subprocess
from dht11_sensor import get_Temp
from light_sensor import get_Light

def get_Time():
    time = str(datetime.datetime.now()).replace(' ', '-').replace(':', '-').replace('.', '-')[0:16]
    return time
def getData(time):
    array = []
    T1=get_Temp()
    if T1:
        pass
    else:
        T1 = get_Temp()
    array.append(T1[0])
    array.append(T1[1])
    T2=get_Light()
    if T2:
        pass
    else:
        T2 = get_Light()
    array.append(T2[0])
    T3 = time
    array.append(T3)
    return array

def arr2dict(array):
    dict = {"sensor":'1' , "time":array[3] , "temperature":str(array[0]) , "humidity":str(array[1]) , "light":str(array[2])}
    return dict

def getImage(time):
    image_name = time +".jpg"
    a = subprocess.call('raspistill -o image/'+image_name+' -q 5', shell=True)

def upload_data(dict,time):
  

    headers = {'content-type': 'application/json',
               'User-Agent': 'Mozilla/5.0 (x11; Ubuntu; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0'}

    r = requests.post('http://115.159.120.50/AgrIntel/upload/uploaddata.php', data = dict)
    files = {'myFile': open("/home/pi/sensor/AgrIntel/image/"+time+".jpg",'rb')}
    res = requests.post("http://115.159.120.50/AgrIntel/upload/uploadimage.php",files = files)
    print res.text
    print r.text
    print r.status_code
    print res.status_code

def begin():
    time = get_Time()
    array = getData(time)
    dict = arr2dict(array)
    getImage(time)
    upload_data(dict,time)
    t = Timer(120,begin)
    t.start()
begin()



