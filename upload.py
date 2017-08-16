#!/usr/bin/python
import urllib2
import json
import dht11_sensor
import light_sensor
from dht11_sensor import thread1
from light_sensor import thread2
data=[]
T1=thread1()
T2=thread2()
data.append(T1)
data.append(T2)
#r=urllib2.urlopen(url="http://115.159.120.50/myproject/upload.php",data=json.dumps(data))
data=json.dumps(data)
print data
#print r.status_code
#print r.text
