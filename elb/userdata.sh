#!/bin/bash 
sudo su
yum update -y
yum install httpd -y
cd /var/www/html
echo "<p>Hello world from instance A</p>" > index.html
service httpd start