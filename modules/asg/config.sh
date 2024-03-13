#!/bin/bash

sudo apt update && apt install wget unzip apache2 -y

sudo systemctl start apache2

wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip

unzip -o 2137_barista_cafe.zip

sudo cp -rf 2137_barista_cafe/* /var/www/html

sudo systemctl restart apache2
