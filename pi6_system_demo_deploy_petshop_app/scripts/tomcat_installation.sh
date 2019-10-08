#!/bin/bash

TOMCAT_USER=$1
TOMCAT_PASS=$2

# install tomcat service
sudo systemctl stop apt-daily.service
sudo systemctl stop apt-daily.timer

sudo apt-get update
sudo apt-get install -y tomcat8
sudo apt-get install -y tomcat8-admin
sudo sed -i 's/JAVA_OPTS=\"/JAVA_OPTS=\"-Djava.net.preferIPv4Stack=true\ -Djava.net.preferIPv4Addresses=true\ /g' /etc/default/tomcat8
sudo sed -i "s/\">/\">\n<user username=\"$TOMCAT_USER\" password=\"$TOMCAT_PASS\" roles=\"manager-script,manager-gui\"\/> /g" /etc/tomcat8/tomcat-users.xml
sudo systemctl restart tomcat8

sudo systemctl start apt-daily.service
sudo systemctl start apt-daily.timer