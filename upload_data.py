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
    datatime = str(datetime.datetime.now()).replace(' ', '-').replace(':', '-').replace('.', '-')[0:16]
    return datatime
def getData(datatime):
    array = []
    T1=get_Temp()
    array.append(T1[0])
    array.append(T1[1])
    T2=get_Light()
    array.append(T2)
    T3 = datatime
    array.append(T3)
    return array

def arr2dict(array):
    dict = {"sensor":'1' , "time":array[3] , "temperature":array[0] , "humidity":array[1], "light":array[2]}
    return dict

def getImage(datatime):
    image_name = datatime +".jpg"
    a = subprocess.call('raspistill -o image/'+image_name+' -q 5', shell=True)

def upload_data(dict,datatime):
  

    headers = {'content-type': 'application/json',
               'User-Agent': 'Mozilla/5.0 (x11; Ubuntu; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0'}

    r = requests.post('http://115.159.120.50/AgrIntel/upload/uploaddata.php', data = dict)
    files = {'myFile': open("/home/pi/sensor/AgrIntel/image/"+datatime+".jpg",'rb')}
    res = requests.post("http://115.159.120.50/AgrIntel/upload/uploadimage1.php",files = files)
    print res.text
    print r.text
    print r.status_code
    print res.status_code

def begin():
    try:
        datatime = get_Time()
        array = getData(datatime)
        dict = arr2dict(array)
        getImage(datatime)
        upload_data(dict,datatime)
        time.sleep(10)
        subprocess.call('rm -rf image/'+datatime+'.jpg',shell = True)
    except Exception,e:
        print Exception, ":", e
    t = Timer(120,begin)
    t.start()
begin()



