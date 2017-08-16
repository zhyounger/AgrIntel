#!/usr/bin/python
import subprocess
import time
import datetime
def getPicture():
    a = subprocess.call("raspistill -o - > image_today.jpg",shell=True)
    return a
