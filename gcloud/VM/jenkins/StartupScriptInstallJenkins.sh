#!/bin/bash

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update

sudo apt-get install apache2 -y

sudo apt-get install default-jre -y

sudo apt-get install jenkins -y

sudo service jenkins start



