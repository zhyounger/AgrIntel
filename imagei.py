import requests
url='http://115.159.120.50/myproject/upload.php'
files={'file':open('/var/www/file.jpg','rb')}
with open('/var/www/i.jpg','rb') as f:
    r = requests.post(url,data = f)
#r=requests.post(url,files=files)
print r.status_code
print r.text
